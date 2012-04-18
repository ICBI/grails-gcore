import grails.converters.*
import java.net.URLEncoder
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CollaborationGroupsController {
	def collaborationGroupService
	def securityService
	def invitationService
	def userListService
	def dataAvailableService
	def savedAnalysisService
	def searchResults
	def mailService
	
	def reloadMembershipAndStudyData(){
			//set studies
			def studyNames = securityService.getSharedItemIds(session.userId, Study.class.name,true)
			def myStudies = []
			studyNames.each{
				def foundStudy = Study.findByShortName(it)
				if(foundStudy){
					myStudies << foundStudy
				}
			}
			
			if(myStudies){
				myStudies.sort{it.shortName}
			}
			session.myStudies = myStudies
		
			//set groups
			def myCollaborationGroups = []
			myCollaborationGroups = securityService.getCollaborationGroups(session.userId)
			session.myCollaborationGroups = myCollaborationGroups
			
			//set lists
			def sharedListIds = []
			sharedListIds = userListService.getSharedListIds(session.userId,true)
			session.sharedListIds = sharedListIds
			
			//set shared anaylysis 
			def sharedAnalysisIds = []
			sharedAnalysisIds = savedAnalysisService.getSharedAnalysisIds(session.userId,true)
			session.sharedAnalysisIds = sharedAnalysisIds
			
			//set data available
			session.dataAvailability = dataAvailableService.getMyDataAvailability(session.myStudies)
			
			log.debug "reloaded all membership and study data"
	}
	
	def index = {
		def memberships = []
		def managedMemberships =  []
		def otherMemberships =  []
		def allMemberships = []
		def gdocUsers = []
		gdocUsers = GDOCUser.list()
		if (gdocUsers){
			def myself = gdocUsers.find{
					it.username == session.userId
			}
			if(myself){
					//log.debug "remove $myself"
					gdocUsers.remove(myself)
			}
		gdocUsers = gdocUsers.sort{it.lastName}
		}
			
		
		memberships = collaborationGroupService.getUserMemberships(session.userId)
		managedMemberships = memberships[0]
		
		otherMemberships = memberships[1]
		
		allMemberships = memberships[2]
		def toDelete = []
		otherMemberships.each{ memGroup ->
			def isAlreadyListed = managedMemberships.find {
				it.collaborationGroup.name == memGroup.collaborationGroup.name
			}
			if(isAlreadyListed){
				toDelete << memGroup
			}
		}
		
		otherMemberships.removeAll(toDelete)
		def invitations = []
		invitations = invitationService.findAllInvitationsForUser(session.userId)
		session.invitations = invitations
		def manMem = []
		manMem = managedMemberships.collect{it.collaborationGroup}
		if(manMem){
			manMem = manMem as Set
			manMem = manMem as List
			manMem.sort{it.name}
			session.managedMemberships	= manMem
		}
			
		def otherMem = []
		otherMem = otherMemberships.collect{it.collaborationGroup}
		if(otherMem){
			otherMem = otherMem as Set
			otherMem = otherMem as List
			otherMem.sort{it.name}	
		}
			
		def allMem = []
		allMem = allMemberships.collect{it.collaborationGroup}
		if(allMem){
			allMem = allMem as Set
			allMem = allMem as List
			allMem.sort{it.name}	
		}
			
		otherMem.sort{it.name}
		[gdocUsers:gdocUsers,managedMemberships:manMem,otherMemberships:otherMem,allMemberships:allMem]
	}
	
	def createCollaborationGroup = {CreateCollabCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			redirect(action:'index')
		} else{
			flash['cmd'] = cmd
			try{
				if(!collaborationGroupService.validName(cmd.collaborationGroupName)){
					log.debug "Group $cmd.collaborationGroupName contains invalid characters"
					flash["error"]= message(code:"collaborationGroup.invalidChars",args: [cmd.collaborationGroupName])
					redirect(action:index)
					return
				}
				def pg = securityService.createCollaborationGroup(session.userId, cmd.collaborationGroupName, cmd.description)
				if(pg){
					flash.message = message(code:"collaborationGroups.created",args: [cmd.collaborationGroupName])
					session.myCollaborationGroups << pg.name
					if(session.managedMemberships)
					 	session.managedMemberships << pg.name
					else{
						session.managedMemberships = []
						session.managedMemberships << pg.name
					}
						
					redirect(action:"index")
				}
			}catch(DuplicateCollaborationGroupException de){
				log.debug "DUPLICATE! " + de
				flash.error =  message(code:"collaborationGroups.duplicate",args: [cmd.collaborationGroupName])
				redirect(action:"index")
			}
		}
	}
	
	def deleteGroup = {
				if(params.group){
					log.debug "requesting deletion of group $params.group"
					def id = params.group.toLong()
					def group = CollaborationGroup.get(id)
					def groupName = group?.name
					def manager
					if (groupName) 
						manager = securityService.findCollaborationManager(groupName)
					if(manager && (manager.username == session.userId)){
						if(securityService.deleteCollaborationGroup(session.userId,groupName)){
							log.debug "collaboration group, $groupName has been deleted"
							flash.message =  message(code:"collaborationGroup.deleted",args: [groupName])
							reloadMembershipAndStudyData()
							redirect(action:index)
							return
						}
						else{
							log.debug "collaboration group, $groupName has NOT been deleted"
							flash.error = message(code:"collaborationGroup.notDeleted",args: [groupName])
							redirect(action:index)
							return
						}
					}
					else{
						log.debug "user is NOT permitted to delete list"
						redirect(controller:'policies',action:'deniedAccess')
						return
					}
					
				}
	}
	
	def buildUserNameForInvite(user){
		if(user.firstName && user.lastName){
			return user.firstName + " " + user.lastName
		}
		else{
			return user.username
		}
	}
	
	/**
	A collab manager invites users to join a group, thus making him the requestor and they the invitees. They
	would then act as the the invitee in confirm access to a group. Works opposite if they 'wish' to be added
	to a group.
	**/
	def inviteUsers = {InviteCollabCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			redirect(action:'showUsers')
			return
		} else{
			flash['cmd'] = cmd
			def usrs = []
			if(cmd.users == 'allUsers'){
				log.debug "$session.userId attempted to invite all users, return false"
				flash.error = message(code:"collaborationGroup.inviteAllError")
				redirect(uri:"/collaborationGroups/showUsers")
				return;
			}
			else{
				usrs = cmd.users.tokenize(",")
				if(usrs.size() == 0 ){
					log.debug "$session.userId attempted to invite 0 users, return false"
					flash.error = message(code:"collaborationGroups.inviteOneError")
					redirect(uri:"/collaborationGroups/showUsers")
					return;
				}
				if(usrs.size() > 10){
					log.debug "$session.userId attempted to invite more than 10 users, return false"
					flash.error = message(code:"collaborationGroups.inviteOverTenError")
					redirect(uri:"/collaborationGroups/showUsers")
					return;
				}
				log.debug "$session.userId attempting to invite $usrs"
				def gdocUsers = []
				def usernames = []
				usrs.each{ 
					def id = it.toLong()
					def gu = GDOCUser.get(id)
					gdocUsers << gu
					usernames << gu.username
				}
				def existingUsers = []
				existingUsers = collaborationGroupService.getExistingUsers(usernames,cmd.collaborationGroupName)
				if(existingUsers){
					def exUserString = ""
					existingUsers.each{ u ->
						exUserString += u + " ,"
					}
					log.debug "$exUserString already exist(s) in the group" + cmd.collaborationGroupName 
					flash.error = message(code:"collaborationGroups.userAlreadyInGroup",args: [exUserString,cmd.collaborationGroupName])
					redirect(uri:"/collaborationGroups/showUsers")
					return;
				}
				else{
					def manager = securityService.findCollaborationManager(cmd.collaborationGroupName)
					def inv
					def exists = false
					if(manager && (manager.username == session.userId)){
						usernames.each{ u ->
							inv = invitationService.findSimilarRequest(manager.username,u,cmd.collaborationGroupName)
							if(inv){
								flash.error = message(code:"collaborationGroups.similarInvite",args: [u,cmd.collaborationGroupName])
								log.debug "A similar invitation exists for $u invited, do not send invites."
								exists = true
							}
						}
						if(!exists){
							gdocUsers.each{ user ->
								if(invitationService.requestAccess(manager.username,user.username,cmd.collaborationGroupName))
								log.debug session.userId + " invited user $user.username to " + cmd.collaborationGroupName
								flash.message =  message(code:"collaborationGroups.inviteConfirmation",args: [session.userId,cmd.collaborationGroupName])
								def managerName = buildUserNameForInvite(manager)
								if(user.email){
											def subject = message(code:"collaborationGroups.inviteEmailSubject",args: [managerName,cmd.collaborationGroupName])
											sendEmail(user,subject)
											return
								}
								else{
											log.debug "no email address was listed for $user.email account, invitation will only be seen on login."
											redirect(action:"showUsers")
											return
								}

							}
						}
						else{
							redirect(action:"showUsers")
							return;
						}
					}
					redirect(action:"showUsers")
					return;
				}
			}
			redirect(action:"showUsers")
			return;
		}
	}
	
	
	def showUsers = {
		def users
		if(params.userId){
			 users = GDOCUser.createCriteria().list()
				{
					projections{
						property('id')
						property('lastName')
						property('firstName')
						property('organization')
					}
					and{
						'order'("username", "asc")
						ne("username","CSM")
					}
					or {
						ilike("username", "%"+params.userId+"%")
						ilike("lastName", params.userId)
					}
				}
		}else{
			users = GDOCUser.createCriteria().list()
				{
					projections{
						property('id')
						property('lastName')
						property('firstName')
						property('organization')
					}
					and{
						'order'("lastName", "asc")
						ne("username","CSM")
					}
				}
		}
		def columns = []
		columns << [index: "id", name: "User ID", sortable: true, width:'0',resizable:false]
		def columnNames = ["lastName","firstName","organization"]
		def userListings = []
		users.each{
			def userMap = [:]
			userMap["id"] = it[0]
			userMap["lastName"] = it[1]
			userMap["firstName"] = it[2]
			userMap["organization"] = it[3]
			userListings << userMap
		}
		columnNames.each {
			def column = [:]
			column["index"] = it
			column["name"] = it
			column["width"] = '170'
			column["sortable"] = true
			columns << column
		}
		session.ucolumnJson = columns as JSON
		def sortedColumns = ["User ID"]//, "PATIENT ID"]
		sortedColumns.addAll(columnNames)
		session.uresults = userListings
		session.ucolumns = sortedColumns
		session.ucolumnNames = sortedColumns as JSON
	}
	
	def viewUsers = {
		searchResults = session.uresults
		def columns = session.ucolumns
		def results = []
		def rows = params.rows.toInteger()
		def currPage = params.page.toInteger()
		def startIndex = ((currPage - 1) * rows)
		def endIndex = (currPage * rows)
		def sortColumn = params.sidx
		if(endIndex > searchResults.size()) {
			endIndex = searchResults.size()
		}
		def sortedResults = searchResults.sort { r1, r2 ->
			def val1 
			def val2
			val1 = r1[sortColumn]
			val2 = r2[sortColumn]
			def comparison
			if(val1 == val2) {
				return 0
			}
			if(params.sord != 'asc') {
				if(val2 == null) {
					return -1
				} else if (val1 == null) {
					return 1
				}
				comparison =  val2.compareTo(val1)
			} else {
				if(val1 == null) {
					return -1
				} else if(val2 == null) {
					return 1
				}
				comparison =  val1.compareTo(val2)
			}
			return comparison
		}
		session.uresults = sortedResults
		sortedResults.getAt(startIndex..<endIndex).each { user ->
			def cells = []
			cells << user.id
			cells << user.lastName
			cells << user.firstName
			cells << user.organization
			results << [id: user.id, cell: cells]
		}
		//log.debug "results rows:" + results
		def jsonObject = [
			page: currPage,
			total: Math.ceil(searchResults.size() / rows),
			records: searchResults.size(),
			rows:results
		]
		render jsonObject as JSON
	}
	
	/**requests access to a collaboration group**/
	def requestAccess = {
		if(params.collaborationGroupName){
			def manager = securityService.findCollaborationManager(params.collaborationGroupName)
			if(manager && invitationService.requestAccess(session.userId,manager.username,params.collaborationGroupName)){
				log.debug session.userId + " is requesting access to " + params.collaborationGroupName 
				def sessUser = GDOCUser.findByUsername(session.userId)
				def userName = buildUserNameForInvite(sessUser)
				if(manager.email){
					def subject = message(code:"collaborationGroups.requestEmailSubject",args: [userName,params.collaborationGroupName])
					sendEmail(manager,subject)
				}
				flash.message = message(code:"collaborationGroups.requestEmailMessage",args: [params.collaborationGroupName])
				redirect(action:"index")
			}
			else{
				flash.error = message(code:"collaborationGroups.noManagerFound")
				redirect(action:"index")
			}
		}else{
			flash.message = message(code:"collaborationGroups.noGroupSpecified")
			redirect(action:"index")
		}
	}
	
	def sendEmail(sendTo,subjectText){
		def baseUrl = CH.config.grails.serverURL
		log.debug "my base is " + baseUrl
		def token = sendTo.username + "||" + System.currentTimeMillis()
		def collabUrl = baseUrl+"/collaborationGroups?token=" + URLEncoder.encode(EncryptionUtil.encrypt(token), "UTF-8")
		//log.debug collabUrl
		mailService.sendMail{
			to sendTo.email
			from appContactEmail()
			subject "$subjectText"
			body message(code:"collaborationGroups.emailBody",args:[collabUrl])
		}
		log.debug "email has been sent to $sendTo.email account"	
	}
	
	/*
	deletes a user or users from a collaboration group
	*/
	def deleteUsersFromGroup = {DeleteCollabUserCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			redirect(action:'index')
		} else{
			flash['cmd'] = cmd
			log.debug("request deletion of $cmd.users from $cmd.collaborationGroupName")
			def permitted = false
			if(securityService.isUserGroupManager(session.userId, cmd.collaborationGroupName)){
				permitted = true
			}
			if(cmd.users.size() == 1 && cmd.users[0] == session.userId){
				permitted = true
			}
			
			if(permitted){
				log.debug("permission granted to delete $cmd.users from $cmd.collaborationGroupName")
				def manager = securityService.findCollaborationManager(cmd.collaborationGroupName)
				def delString = ""
				cmd.users.each{ user ->
					invitationService.revokeAccess(manager.username, user, cmd.collaborationGroupName)
					log.debug "$user has been removed from " + cmd.collaborationGroupName 
					delString += user + ", "
				}
				flash.message = message(code:"collaborationGroups.deletedUsers",args:[delString, cmd.collaborationGroupName])
				redirect(action:'index')
			}
			else{
				log.debug "user CANNOT delete users from the $cmd.collaborationGroupName"
				redirect(controller:'policies', action:'deniedAccess')
			}
		}
	}
	
	
	//grants some user access to a group
	def grantAccess = { 
		if(params.id && params.user && params.group){
			if(invitationService.confirmAccess(session.userId, params.id))
				flash.message = message(code:"collaborationGroups.userAdded",args:[params.user, params.group])
			else
				flash.message =  message(code:"collaborationGroups.userNotAdded",args:[params.user, params.group])
		}
		reloadMembershipAndStudyData()
		redirect(action:index)
	}
	
	//accepts an invitation to join a group
	def addUser = {
		log.debug params.id
		if(params.user && params.id && params.group){
			if(invitationService.acceptAccess(params.user,params.id))
				flash.message =  message(code:"collaborationGroups.userAdded",args:[params.user, params.group])
			else
				flash.message =  message(code:"collaborationGroups.userNotAdded",args:[params.user, params.group])
		}
		reloadMembershipAndStudyData()
		redirect(action:index)
	}
	
	//either rejects some user access to a group, or rejects an invitation to join a group
	def rejectInvite = {
		log.debug params.id
		if(params.user && params.id && params.group){
			if(invitationService.rejectAccess(params.id))
				flash.message =  message(code:"collaborationGroups.userRejected",args:[params.user, params.group])
			else
				flash.message = message(code:"collaborationGroups.userNotRejected",args:[params.user, params.group])
		}
		redirect(action:index)
	}
	
}