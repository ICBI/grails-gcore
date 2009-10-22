import gov.nih.nci.security.SecurityServiceProvider;
import gov.nih.nci.security.AuthenticationManager;
import gov.nih.nci.security.AuthorizationManager;
import gov.nih.nci.security.exceptions.CSException
import gov.nih.nci.security.exceptions.CSObjectNotFoundException
import gov.nih.nci.security.authorization.domainobjects.ProtectionElement
import gov.nih.nci.security.authorization.domainobjects.ProtectionGroup

import LoginException

class SecurityService {
	static scope = "session"
	public static String GROUP_MANAGER = 'COLLABORATION_GROUP_MANAGER'
	public static String USER = 'USER'
	
	def jdbcTemplate
	
	AuthenticationManager authenticationManager
	AuthorizationManager authorizationManager
	
	def login(params) throws LoginException{
		def user = GDOCUser.findByLoginName(params.loginName)
		try{
			//print authenticationManager.getApplicationContextName();
			boolean loginOK = this.getAuthenticationManager().login(params.loginName, params.password);
			if (loginOK){
				System.out.println("SUCESSFUL LOGIN");
			}
			else {
				System.out.println("ERROR IN LOGIN");
				throw new LoginException("error in authentication");
			}
			}catch (CSException cse){
				System.out.println("ERROR IN LOGIN -- CS Exception");
				cse.printStackTrace(System.out);
				throw new LoginException("error in authentication");
		}
		
		try {
			print "got user " + this.getAuthorizationManager() + " from csm, ready to authorize "
			Set memberships = user.getGroups();
			memberships.each{ membership ->
				println membership.group.groupName
			}
		}catch ( CSException cse){
			System.out.println("ERROR IN AUTHORIZATION ");
			cse.printStackTrace(System.out);
			throw new LoginException("error in authorization");
		}
		
		return user
		
	}
	
	def logout(session){
		session.invalidate()
	}
	
	/**
	* Share an item with a collaboration groups
	*/
	def share(item, groups) {
		def authManager = this.getAuthorizationManager()
		
		ProtectionElement pe = authManager.getProtectionElement(item.id.toString(), item.class.name)
		if(!pe) {
			pe = new ProtectionElement()
			pe.protectionElementName = item.class.name + '_' + item.id.toString()
			
			pe.objectId = item.id.toString()
			pe.attribute = item.class.name
			authManager.createProtectionElement(pe)
		}
		groups.each{
			authManager.assignProtectionElement(it, item.id.toString(), item.class.name)
		}
	}
	
	/**
	Checks if the protection element has already been shared with any of the groups passed.
	If so, returns the groups it has been shared with
	**/
	def groupsShared(item){
			println "is $item already shared?"
			def authManager = this.getAuthorizationManager()
			def groupNames = []
		try{
				ProtectionElement pe = authManager.getProtectionElement(item.id.toString(), item.class.name)
				if(pe){
					def groups = authManager.getProtectionGroups(pe.protectionElementId.toString())
					if(groups){
						println "item $item hs already been shared to "
							groups.each{
								groupNames << it.getProtectionGroupName()
							}
					}
				}
		}catch(CSObjectNotFoundException csoe){
			csoe.printStackTrace(System.out);
			throw new SecurityException("object not found");
		}
			return groupNames
	}
	
	/**
	* Creates a new collaboration group
	**/
	def createCollaborationGroup(loginName, groupName) {
		groupName = groupName.toUpperCase()
		def authManager = this.getAuthorizationManager()
		def groups = authManager.getProtectionGroups()
		def currentProtectionGroup = findProtectionGroup(groupName)
		if(currentProtectionGroup != null)
			throw new DuplicateCollaborationGroupException()
		def pg = new ProtectionGroup()
		pg.protectionGroupName = groupName
		pg.protectionGroupDescription = "Protection group created by $loginName"
		authManager.createProtectionGroup(pg)
		addUserRoleToProtectionGroup(loginName, pg, GROUP_MANAGER)
		return pg
	}
	
	/**
	* Adds a user to a collaboration group (including a study group)
	**/
	def addUserToCollaborationGroup(loginName, targetUser, groupName) {
		groupName = groupName.toUpperCase()
		if(isUserGroupManager(loginName, groupName)) {
			def pg = findProtectionGroup(groupName)
			addUserRoleToProtectionGroup(targetUser, pg, USER)
		} else {
			throw new Exception("User $loginName is not a Collaboration Group Manager.")
		}
	}
	
	def removeUserFromCollaborationGroup(loginName, targetUser, groupName) {
		groupName = groupName.toUpperCase()
		if(isUserGroupManager(loginName, groupName)) {
			def pg = findProtectionGroup(groupName)
			def user = this.getAuthorizationManager().getUser(targetUser)
			this.getAuthorizationManager().removeUserFromProtectionGroup(pg.protectionGroupId.toString(), user.userId.toString())
		} else {
			throw new Exception("User $loginName is not a Collaboration Group Manager.")
		}
	}
	
	def deleteCollaborationGroup(loginName, groupName) {
		groupName = groupName.toUpperCase()
		if(isUserGroupManager(loginName, groupName)) {
			def pg = findProtectionGroup(groupName)
			this.getAuthorizationManager().removeProtectionGroup(pg.protectionGroupId.toString())
		} else {
			throw new Exception("User $loginName does not have permission to delete this group")
		}
	}
	
	private addUserRoleToProtectionGroup(loginName, protectionGroup, roleName) {
		String[] roles = new String[1]
		roles[0] = getRoleIdForName(roleName).toString()
		def user = this.getAuthorizationManager().getUser(loginName)
		this.getAuthorizationManager().addUserRoleToProtectionGroup(user.userId.toString(), roles, protectionGroup.protectionGroupId.toString())
		
	}
	
	private isUserGroupManager(loginName, groupName) {
		def pg = findProtectionGroup(groupName)
		if(!pg)
			throw new Exception("Collaboration group does not exist.")
		def authManager = this.getAuthorizationManager()
		def user = authManager.getUser(loginName)
		def groups = authManager.getProtectionGroupRoleContextForUser(user.userId.toString())
		def toDelete = groups.find {
			println "${it.protectionGroup.protectionGroupName} and ${groupName}"
			it.protectionGroup.protectionGroupName == groupName
		}
		if(!toDelete)
			throw new Exception("User1 $loginName does not have permission to delete this group")
		def isCollaborationManager = toDelete.roles.find {
			it.name == GROUP_MANAGER
		}
		return isCollaborationManager
	}
	
	private findProtectionGroup(groupName) {
		def authManager = this.getAuthorizationManager()
		def groups = authManager.getProtectionGroups()
		def currentProtectionGroup = groups.find {
			it.protectionGroupName == groupName
		}
		return currentProtectionGroup
	}
	
	def getCollaborationGroups(loginName){
		def authManager = this.getAuthorizationManager()
		def user = authManager.getUser(loginName)
		def groups = authManager.getProtectionGroupRoleContextForUser(user.userId.toString()).collect { it.protectionGroup }
		def groupNames = []
		groups.each{
			groupNames << it.getProtectionGroupName()
		}
		return groupNames
	}
	
	def getSharedItemIds(loginName, itemType) {
		def sharedItems = [:]
		/**commented out for 'session' inconsistencies if(!sharedItems) {
			sharedItems = [:]
		}
		if(sharedItems[itemType]) {
			return sharedItems[itemType]
		} else {**/
			def authManager = this.getAuthorizationManager()
			def user = authManager.getUser(loginName)
			def groups = authManager.getProtectionGroupRoleContextForUser(user.userId.toString()).collect { it.protectionGroup }
			def elements = groups.collect {
				return authManager.getProtectionElements(it.protectionGroupId.toString())
			
			}
			elements = elements.flatten()
			def ids = []
			elements.each {
				if (itemType.equals(it.attribute))
					if(ids!=null && !ids.contains(it.objectId)){
						ids << it.objectId
					}
			}
			sharedItems[itemType] = ids
			return ids
		//}
	}
	
	private getRoleIdForName(roleName) {
		return jdbcTemplate.queryForLong("select ROLE_ID from CSM.CSM_ROLE where ROLE_NAME = '$roleName'")
	}
	
	public AuthenticationManager getAuthenticationManager() {
		if(!this.@authenticationManager) {
			this.@authenticationManager = SecurityServiceProvider.getAuthenticationManager("gdoc")
		} 
		return this.@authenticationManager 
	}
	
	public AuthorizationManager getAuthorizationManager() {
		if(!this.@authorizationManager) {
			this.@authorizationManager = SecurityServiceProvider.getAuthorizationManager("gdoc");
		} 
		return this.@authorizationManager 
	}
}