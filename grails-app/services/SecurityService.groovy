import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import javax.security.auth.login.Configuration
import javax.security.auth.login.AppConfigurationEntry
import javax.naming.*
import javax.naming.directory.*
import javax.naming.ldap.*
import javax.net.ssl.*

import LoginException

class SecurityService{
	static scope = "session"
	public static String GROUP_MANAGER = 'COLLABORATION_GROUP_MANAGER'
	public static String GDOC_ADMIN = 'GDOC_ADMIN'
	public static String USER = 'USER'
	def springSecurityService
	def jdbcTemplate
	def sharedItems = [:]

	def setLastLogin(userId){
		log.debug "find user, $userId"
		def user = GDOCUser.findByUsername(userId)
		if(user){
			log.debug "found $user"
			user.lastLogin = new Date()
			try{
				if(user.hasErrors() || !user.save(flush:true)){
					log.debug "did NOT set last login"
					user.errors.each{
						log.debug it
					}
				}
				else{
					log.debug "user last login has been updated"
				}
			}
			catch(Exception e){
				e.printStackTrace() 
			}
				
		}
	}
	
	
	def validateToken(token){
		log.debug "prepare to decrypt token $token"
		String decryptedToken = EncryptionUtil.decrypt(token);
		String[] info = decryptedToken.split("\\|\\|");
		String username = info[0];
		log.debug "$username accessing gdoc" 
		Long timeRequested = Long.parseLong(info[1]);
		Long currentTime = System.currentTimeMillis();
		Long diff = currentTime - timeRequested;
		Long hours = diff / (60 * 60 * 1000);
		if(hours > 24L) {
			log.debug "time has expired" 
            return false
		}
		else{
			return username
		}
	}
	
	def isNetId(username){
			log.debug 'do LDAP search'
			Hashtable env = new Hashtable();
			env.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.SECURITY_PROTOCOL, "ssl");
			env.put(Context.PROVIDER_URL, CH.config.grails.plugins.springsecurity.ldap.context.server);
			env.put(Context.SECURITY_AUTHENTICATION,"simple");
			env.put("java.naming.ldap.factory.socket",SSLSocketFactory.class.getName());
			env.put(Context.SECURITY_PRINCIPAL,CH.config.grails.plugins.springsecurity.ldap.context.managerDn); 
			env.put(Context.SECURITY_CREDENTIALS,CH.config.grails.plugins.springsecurity.ldap.context.managerPassword); 
			DirContext ctx = new InitialDirContext(env);
			SearchControls ctls = new SearchControls();
			ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			String filter = "(&(uid="+username+"))";
			NamingEnumeration list = ctx.search(CH.config.grails.plugins.springsecurity.ldap.authorities.groupSearchBase, filter, ctls);
			if(list){
				log.debug "$username user found"
				return true
			}
			else{
				return false
			}
	}
	
	
	def validateNetId(netId, department){
		Hashtable env = new Hashtable();
		
		env.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.SECURITY_PROTOCOL, "ssl");
		env.put(Context.PROVIDER_URL, CH.config.grails.plugins.springsecurity.ldap.context.server);
		env.put(Context.SECURITY_AUTHENTICATION,"simple");
		env.put("java.naming.ldap.factory.socket",SSLSocketFactory.class.getName());
		env.put(Context.SECURITY_PRINCIPAL,CH.config.grails.plugins.springsecurity.ldap.context.managerDn); 
		env.put(Context.SECURITY_CREDENTIALS,CH.config.grails.plugins.springsecurity.ldap.context.managerPassword); 
		DirContext ctx = new InitialDirContext(env);
		SearchControls ctls = new SearchControls();
		ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);
		String filter = "(&(uid="+netId+"))";
		NamingEnumeration list = ctx.search(CH.config.grails.plugins.springsecurity.ldap.authorities.groupSearchBase, filter, ctls);
		
		if(list){
			log.debug "$netId user found, let's retrieve retrieve needed attributes to create a G-DOC account"
			BasicAttributes attr =  ctx.getAttributes("uid="+netId+","+CH.config.grails.plugins.springsecurity.ldap.authorities.groupSearchBase)
				if(attr){
					def username
					def password
					def firstName
					def lastName
					def email
					def organization
					def title = ""
					if(attr.get("uid")){
						log.debug "found user id " + attr.get("uid").get()
						username = attr.get("uid").get()
					}
					if(attr.get("givenname")){
						log.debug "found givenname " + attr.get("givenname").get()
						firstName = attr.get("givenname").get()
					}
					else{
						log.debug "didn't find first name, set to netid "
						firstName = attr.get("uid").get()
					}
					if(attr.get("sn")){
						log.debug "found sn " + attr.get("sn").get()
						lastName = attr.get("sn").get()
					}else{
						log.debug "didn't find last name, set to netid "
						lastName = attr.get("uid").get()
					}
					if(attr.get("ou")){
						log.debug "found ou " + attr.get("ou").get()
						organization = attr.get("ou").get()
					}else{
						log.debug "didn't find ou, set to GU or affiliate "
						organization = "Georgetown University"
					}
					if(attr.get("mail")){
						log.debug "found mail " + attr.get("mail").get()
						email = attr.get("mail").get()
					}
					if(department){
						log.debug "department set to $department"
						department = department
					}else{
						log.debug "no department sent"
						department = ""
					}
					if(title){
						log.debug "title set to $title"
						title = title
					}else{
						log.debug "title set to N/A"
						title = "N/A"
					}
					
					password = "gdocLCCC"
					return createNewUser(username, password, firstName,lastName,email,organization, title,department)
				}
				else{
					log.debug "no attributes found for $netId"
					return null
				}
		}
		else{
			log.debug "no user found for that id"
			return null
		}
		
	}

	
	def createNewUser(username, password, firstName,lastName,emailId,organization, title, department){
		def newUser = new GDOCUser()
		if(username && firstName &&
			lastName && organization && emailId && title){
			newUser.username = username
			def encodedPassword = springSecurityService.encodePassword(password)
			newUser.password = encodedPassword
			newUser.firstName = firstName
			newUser.lastName = lastName
			newUser.organization = organization
			newUser.email = emailId
			newUser.department = department
			newUser.title = title
			newUser.enabled = true
			newUser.accountExpired = false
			newUser.accountLocked = false
			newUser.passwordExpired = false
			if(!newUser.save(flush:true)){
				newUser.errors.each{
					log.debug it
				}
				log.debug "errors creating user"
			return false
			}else{
				log.debug "new user,  " + newUser.username + " created"
			}
		}
		else {
			throw new SecurityException("one or more required user attributes were not included");
		}
		return newUser
	}
	
	def changeUserPassword(userId, newPassword){
		if(userId && newPassword){
			log.debug "change user password "
			def encodedPassword = springSecurityService.encodePassword(newPassword)
			def user = GDOCUser.findByUsername(userId)
			user.password = encodedPassword
			if(!user.save(flush:true)){
				user.errors.each{
					log.debug it
				}
			}
			log.debug "change user password complete"
			return true
			
		}else{
			return false
		}
		
	}
	
	/**if deleting a user from using the UPT web app, remember to delete 
	any invitations associated with this user**/
	def removeUser(userId){
		def user = GDOCUser.get(userId)
		def managedGroups = []
		try{
			if(!user.lastLogin){
				log.debug "set lastLoginFor this user before deletion"
				setLastLogin(user.username)
			}
			if(user.memberships){
				log.debug "delete all groups $user.username is a member of..." + user.memberships
				user.memberships.each{
					if(it.collaborationGroup){
						if(isUserGroupManager(user.username, it.collaborationGroup.name)) {
							log.debug "user is manager of $it.collaborationGroup.name, mark it for deletion"
							managedGroups << it.collaborationGroup.name
						}
					}
				}		
			}
			Invitation.executeUpdate("delete Invitation invitation where invitation.invitee = :user", [user:user])
			log.debug "deleted requestee invitations of " + user.username
			managedGroups.each{ groupName ->
				deleteCollaborationGroup(user.username,groupName)
			}
			user.delete()
			log.debug "deleted all other objects held by $userId"
		}
		catch(Exception e){
			log.debug e
			return false
		}
		log.debug "deleted the user " + userId
		return true
	}
	
	/**
	* Share an item with collaboration group(s)
	*/
	def share(item, groups) {
		ProtectedArtifact protectedArtifact = ProtectedArtifact.findByObjectId(item.id)
		if(!protectedArtifact){
			def name =  item.class.name + '_' + item.id.toString()
			def objectId = item.id.toString()
			def type = item.class.name
			protectedArtifact = createProtectedArtifact(name,objectId,type)
		}
		if(protectedArtifact){
			log.debug "completed creating protected artifact, $protectedArtifact.name"
			groups.each{
				def group = CollaborationGroup.findByName(it.toUpperCase())
				if(group){
					protectedArtifact.addToGroups(group)
				}
			}
		}
		return true
	}
	
	def createProtectedArtifact(name, objectId, type){
		def protectedArtifact = new ProtectedArtifact()
		protectedArtifact.name =  name
		protectedArtifact.objectId = objectId
		protectedArtifact.type = type
		if(protectedArtifact.save(flush:true)){
			return protectedArtifact
		}else
		return null
	}
	
	
	/**
	Checks if the protection element has already been shared with any of the groups passed.
	If so, returns the groups it has been shared with
	**/
	def groupsShared(item){
			log.debug "is $item already shared?"
			def groupNames = []
		try{
				ProtectedArtifact protectedArtifact = ProtectedArtifact.findByObjectId(item.id)
				if(protectedArtifact){
					def groups = protectedArtifact.groups
					if(groups){
						log.debug "item $item hs already been shared to "
							groups.each{
								groupNames << it.name
							}
					}
				}
		}catch(Exception csoe){
			log.error("object not found", csoe)
			throw new SecurityException("object not found");
		}
			return groupNames
	}
	
	/**
	* Creates a new collaboration group
	**/
	def createCollaborationGroup(username, groupName, description) throws DuplicateCollaborationGroupException{
		def currentProtectionGroup = CollaborationGroup.findByName(groupName.toUpperCase())
		if(currentProtectionGroup)
			throw new DuplicateCollaborationGroupException()
		def collabGroup = new CollaborationGroup()
		collabGroup.name = groupName
		if(description){
			collabGroup.description = description
		}else{
			collabGroup.description = "Collaboration group created by $username"
		}
		if(collabGroup.save(flush:true)){
			createMembership(username, collabGroup.name, GROUP_MANAGER)
		}
		
		return collabGroup
	}
	
	
	def deleteCollaborationGroup(username, groupName) {
		def invites = []
		def cg = CollaborationGroup.findByName(groupName.toUpperCase())
		invites= cg.invitations
			if(isUserGroupManager(username, cg.name)) {
				removeUserFromCollaborationGroup(username,username,cg.name)
				cg.delete(flush:true)
				return true
			} else {
				throw new Exception("User $username does not have permission to delete this group")
			}

		return false
	}
	
	def isUserGroupManager(username, groupName) {
		def collabGroup = CollaborationGroup.findByName(groupName.toUpperCase())
		def isCollaborationManager
		if(!collabGroup)
			throw new Exception("Collaboration group does not exist.")
		def user = GDOCUser.findByUsername(username)
		def memberships = user.memberships
		def desiredMemberships = memberships.findAll {
			//log.debug "${it.collaborationGroup.name} and ${it.role.name}"
			it.collaborationGroup.name == groupName
		}
		if(!desiredMemberships){
			 log.debug "user, $username does is not member of $groupName"
			return false
		}
		else{
			isCollaborationManager = desiredMemberships.find {
				it.role.name == GROUP_MANAGER
			}
			if(isCollaborationManager){
				log.debug "user, $username is THE manager of $groupName"
				return true
			}
			else{
				log.debug "user, $username is not manager of $groupName"
				return false
			}
		}	
			
	}
	
	def createMembership(username, groupName, roleName){
		def membership
		def collabGroup = CollaborationGroup.findByName(groupName.toUpperCase())
		def role = Role.findByName(roleName)
		def user = GDOCUser.findByUsername(username)
		if(user && collabGroup && role){
			membership = new Membership(user:user,collaborationGroup:collabGroup,role:role)
			if(membership.save(flush:true)){
				log.debug "membership created $membership"
			}
		}
		return membership
	}
	
	/**
	* Adds a user to a collaboration group (including a study group)
	**/
	def addUserToCollaborationGroup(username, targetUser, groupName) {
		if(isUserGroupManager(username, groupName)) {
			def collabGroup = CollaborationGroup.findByName(groupName.toUpperCase())
			def role = Role.findByName(USER)
			def user = GDOCUser.findByUsername(targetUser)
			def membership = new Membership(user:user, collaborationGroup:collabGroup,role:role)
			if(membership.save(flush:true)){
				return true
			}
		} else {
			throw new Exception("User $username is not a Collaboration Group Manager.")
		}
	}
	
	def removeUserFromCollaborationGroup(username, targetUser, groupName) {
		if(isUserGroupManager(username, groupName)) {
			def user =  GDOCUser.findByUsername(targetUser)
			def collabGroup = CollaborationGroup.findByName(groupName.toUpperCase())
			log.debug "got collab group $collabGroup"
			def memberships = Membership.findAllByUserAndCollaborationGroup(user,collabGroup)
			log.debug "got memberships group $memberships"
			if(memberships){
				def ids = []
				memberships.each{
					ids << new Long(it.id)
					user.memberships.remove(it)
				}
				Membership.executeUpdate("delete Membership m WHERE m.id IN (:ids)", [ids: ids])
			}
			def membershipf = Membership.findAllByUserAndCollaborationGroup(user,collabGroup)
		} else {
			throw new Exception("User $username is not a Collaboration Group Manager.")
		}
	}
	
	
	
	
	def findCollaborationManager(groupName){
		def collabGroup = CollaborationGroup.findByName(groupName.toUpperCase())
		def memberships = []
		memberships = Membership.findAllByCollaborationGroup(collabGroup)
		if(!memberships)
			throw new Exception("Collaboration group does not exist.")
		def managerMem = memberships.find{ m ->
			m.role.name == GROUP_MANAGER
		}
		if(managerMem){
			return managerMem.user
		}else{
			log.debug "NO manager?"
		}
		
	}
	
	private isUserCollaborationManager(membership){
		if(membership.role){
			if(membership.role.name == GROUP_MANAGER){
				return true
			}
			else return false
		}
		return false
	}
	
	def isUserGDOCAdmin(userId){
		def isUserGDOCAdmin = false
		def user = GDOCUser.findByUsername(userId)
		def userMemberships = user.memberships
		userMemberships.each{ membership->
			if(membership.collaborationGroup &&
				 membership.collaborationGroup.name == 'PUBLIC' &&
					membership.role){
						if(membership.role.name == GDOC_ADMIN){
							//log.debug "$userId is a GDOC Administrator"
							isUserGDOCAdmin = true
						}
			}
			
		}
		return isUserGDOCAdmin
	}
	
	
	def getCollaborationGroups(username){
		def user = GDOCUser.findByUsername(username)
		def groups = new HashSet()
		def groupNames = new HashSet()
		if(user.memberships){
			groups = user.memberships.collect{it.collaborationGroup}
		}
		if(groups){
			groups.each{
						groupNames << it.name
			}
		}
		return groupNames
	}
	
	def doesMembershipExistByNames(username,groupName,roleName){
		def user = GDOCUser.findByUsername(username)
		if(user.memberships){
			def exists = user.memberships.find{ membership->
				(membership.collaborationGroup.name == groupName) && (membership.role.name == roleName)
			}
			if(exists){
				log.debug "$username found as " + exists.role.name + exists.collaborationGroup.name
				return exists
			}else {
				user.memberships.each{
					println it.role.name + " for " + it.collaborationGroup.name
				}
				return false
			}
		}	
		else{
			return false
		}
	}
	
	def doesMembershipExistByIds(userId,groupId,roleId){
		def user = GDOCUser.get(userId)
		if(user.memberships){
			def exists = user.memberships.find{ membership->
				(membership.collaborationGroup.id.toString() == groupId) && (membership.role.id.toString() == roleId)
			}
			if(exists){
				log.debug "$userId found as " + exists.role.name + exists.collaborationGroup.name
				return exists
			}else {
				user.memberships.each{
					println it.role.name + " for " + it.collaborationGroup.name
				}
				return false
			}
		}	
		else{
			return false
		}
	}
	
	def deleteAllGroupArtifacts(id, type){
		if(type == "CollaborationGroup"){
			def update = jdbcTemplate.update("delete from GROUP_ARTIFACT where COLLABORATION_GROUP_ID = $id")
		}else if (type == "ProtectedArtifact"){
			def update = jdbcTemplate.update("delete from GROUP_ARTIFACT where PROTECTED_ARTIFACT_ID = $id")
		}
		
	}
	
	def getSharedItemIds(username, itemType,refresh) {
			log.debug "find all artifacts for type $itemType, refresh=$refresh"
			if(sharedItems[itemType] != null && !refresh) {
				return sharedItems[itemType]
			}
			def user = GDOCUser.findByUsername(username)
			def groups = new HashSet()
			def groupIds = new HashSet()
			if(user.memberships){
				groups = user.memberships.collect{it.collaborationGroup}
				if(groups){
					groups.each{
						groupIds << new Long(it.id)
					}
				}
			}
			def artifacts = []
			if(!groups)
				return []
			def artifactHQL = "SELECT distinct artifact FROM ProtectedArtifact artifact JOIN artifact.groups groups " + 
			"WHERE artifact.type = :type " + 
			"AND groups IN (:groups) "
			log.debug "grabbed $itemType from " + groups
			artifacts = ProtectedArtifact.executeQuery(artifactHQL, [type: itemType, groups: groups])
			artifacts.flatten()
			def ids = []
			if(itemType == Study.class.name){
				artifacts.each {
					ids << it.objectId
				}
			}

			else{
				def aIds = []
				if(artifacts){
					aIds = artifacts.collect{new Long(it.objectId)}.unique()
				}
				def publicGroup = groups.findAll{
					it.name == 'PUBLIC'
				}
				ids = getAccessibleIds(user,itemType,aIds,publicGroup)
			}

			if(sharedItems[itemType] == null || refresh) {
				log.debug "CACHING ${itemType} $ids"
				sharedItems[itemType] = ids
			}

			return ids
		}
		
		private getStudyDetail(user,studyNames){
					def newStudies = []
					newStudies.addAll(studyNames)
					def existingStudyNames = studyNames
					existingStudyNames = existingStudyNames.sort()
					if(sharedItems["STUDY_DETAIL"] != null) {
						def currentNames = sharedItems["STUDY_DETAIL"].collect{it.shortName}.unique()
						currentNames = currentNames.sort()
						def esize = existingStudyNames.size()
						def csize = currentNames.size()
						//log.debug "existingStudyNames = $esize"
						//log.debug "current = $csize"
						if(!(existingStudyNames.retainAll(currentNames)) && (csize == esize)){
							//log.debug "looks like the studies haven't changed, existingStudyNames = $existingStudyNames, and current = $currentNames"
							return sharedItems["STUDY_DETAIL"]
						}else{
							//log.debug "looks like the studies HAVE changed, existingStudyNames = $existingStudyNames, and current = $currentNames"
						}

					}
					def studies = []
					if(newStudies){
						//log.debug "retrieve studies in $newStudies"
						def studyHQL = "SELECT distinct study FROM Study study " + 
						"WHERE study.shortName IN (:studyNames) "
						studies = Study.executeQuery(studyHQL, [studyNames: newStudies])
					}
					log.debug "grab latest studies and CACHING STUDY_DETAILs " //$studies"
					sharedItems["STUDY_DETAIL"] = studies
					//log.debug "return latest studies"
					return sharedItems["STUDY_DETAIL"]
				}
		

		private getAccessibleIds(user, type,ids,groups) {
				def accessibleIds = []
				def studyNames = []
				studyNames = this.getSharedItemIds(user.username, Study.class.name,false)
				/**def studyHQL = "SELECT distinct study FROM Study study " + 
				"WHERE study.shortName IN (:studyNames) "
				log.debug "grab studies"**/
				def studies = []
				studies = getStudyDetail(user,studyNames)//Study.executeQuery(studyHQL, [studyNames: studyNames])
				if(!studies)
					return accessibleIds
				log.debug "check types"
				if(type == UserList.class.name && ids !=null && !ids.isEmpty()){
					def artifactHQL = "SELECT distinct list.id FROM UserList list JOIN list.studies studies " + 
					"WHERE studies IN (:studies) "
					accessibleIds = UserList.executeQuery(artifactHQL, [studies: studies])
					def listsNoStudy = []
					def listHQL = "SELECT distinct list.id FROM UserList list WHERE list.id IN (:ids) and size(list.studies) = 0"
					log.debug "get the ids that have no study = $ids"
					listsNoStudy = UserList.executeQuery(listHQL, [ids:ids])
					if(listsNoStudy){ 
						listsNoStudy.each{ lnsId->
							accessibleIds << new Long(lnsId)
						}
					}
					log.debug "the following " + ids.size + " ids have no study " + listsNoStudy + "now add them"
				}
				if(type == SavedAnalysis.class.name){
					def artifactHQL = "SELECT distinct analysis.id FROM SavedAnalysis analysis JOIN analysis.studies studies " + 
					"WHERE studies IN (:studies) "
					accessibleIds = SavedAnalysis.executeQuery(artifactHQL, [studies: studies])
				}
				log.debug "grab all public ids and group of type $type in $groups"
				def publicHQL = "SELECT distinct artifact.objectId FROM ProtectedArtifact artifact JOIN artifact.groups groups " + 
				"WHERE artifact.type = :type AND groups IN (:groups) "
				def publicIds = ProtectedArtifact.executeQuery(publicHQL, [type: type, groups: groups])
				if(publicIds){
					publicIds.each{ pId->
						accessibleIds << new Long(pId)
					}
					
				}
				log.debug "retain only accesible ids and public ids $type $ids"
				//ids.retainAll(accessibleIds)
				accessibleIds.retainAll(ids)
				return accessibleIds
			}
	
}