class CollaborationGroupsController {
	def collaborationGroupService
	def securityService
	def invitationService
	def userListService
	def quickStartService
	def savedAnalysisService
	
	def reloadMembershipAndStudyData(){
			def studyNames = securityService.getSharedItemIds(session.userId, StudyDataSource.class.name)
			def myStudies = []
		
			studyNames.each{
				def foundStudy = StudyDataSource.findByShortName(it)
				if(foundStudy){
					myStudies << foundStudy
				}
			}
			session.myStudies = []
			session.myStudies = myStudies
			def myCollaborationGroups = []
			myCollaborationGroups = securityService.getCollaborationGroups(session.userId)
			def sharedListIds = []
			sharedListIds = userListService.getSharedListIds(session.userId)
			session.sharedListIds = sharedListIds
			//get shared anaylysis and places them in session scope
			def sharedAnalysisIds = []
			sharedAnalysisIds = savedAnalysisService.getSharedAnalysisIds(session.userId)
			session.sharedAnalysisIds = sharedAnalysisIds
			session.dataAvailability = quickStartService.getMyDataAvailability(session.myStudies)
			session.myCollaborationGroups = myCollaborationGroups
			log.debug "reloaded all membership data"
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
					it.loginName == session.userId
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
		log.debug otherMem
		[gdocUsers:gdocUsers,managedMemberships:manMem,otherMemberships:otherMem,allMemberships:allMem]
	}
	
	def createCollaborationGroup = {CreateCollabCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			redirect(action:'index')
		} else{
			flash['cmd'] = cmd
			try{
				def pg = securityService.createCollaborationGroup(session.userId, cmd.collaborationGroupName, cmd.description)
				if(pg){
					flash.message = cmd.collaborationGroupName + " has been created. To invite users, select the invite users tab."
					session.myCollaborationGroups << cmd.collaborationGroupName
					redirect(action:"index")
				}
			}catch(DuplicateCollaborationGroupException de){
				log.debug "DUPLICATE! " + de
				flash.message = cmd.collaborationGroupName + " already exists as a collaboration group."
				redirect(action:"index")
			}
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
			redirect(action:'index')
		} else{
			flash['cmd'] = cmd
			def existingUsers = []
			existingUsers = collaborationGroupService.getExistingUsers(cmd.users,cmd.collaborationGroupName)
			if(existingUsers){
				def exUserString = ""
				existingUsers.each{ u ->
					exUserString += u + " ,"
				}
				log.debug "$exUserString already exist(s) in the group" + cmd.collaborationGroupName 
				flash.message = "$exUserString already exists in the " + cmd.collaborationGroupName  + " group. No users added to group."
				redirect(uri:"/collaborationGroups/index")
			}
			else{
				def manager = securityService.findCollaborationManager(cmd.collaborationGroupName)
				if(manager && (manager.loginName == session.userId)){
					cmd.users.each{ user ->
						if(invitationService.requestAccess(manager.loginName,user,cmd.collaborationGroupName))
							log.debug session.userId + " invited user $user to " + cmd.collaborationGroupName 
						}
				}
				flash.message = "An invitation has been sent to join the " + cmd.collaborationGroupName + " collaboration group."
				redirect(action:"index")
			}
		}
	}
	
	/**requests access to a collaboration group**/
	def requestAccess = {
		if(params.collaborationGroupName){
			def manager = securityService.findCollaborationManager(params.collaborationGroupName)
			if(invitationService.requestAccess(session.userId,manager.loginName,params.collaborationGroupName)){
				log.debug session.userId + " is requesting access to " + params.collaborationGroupName 
				flash.message = "An access request has been sent to join the " + params.collaborationGroupName + " collaboration group."
				redirect(action:"index")
			}
		}else{
			flash.message = "No collaboration group specified. Try again."
			redirect(action:"index")
		}
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
					invitationService.revokeAccess(manager.loginName, user, cmd.collaborationGroupName)
					log.debug "$user has been removed from " + cmd.collaborationGroupName 
					delString += user + ", "
				}
				flash.message = delString + " has been marked for removal from " + cmd.collaborationGroupName + ". Subsequent logins will prevent user from accessing this group"
				reloadMembershipAndStudyData()
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
				flash.message = "$params.user user has been added to the $params.group"
			else
				flash.message = "$params.user user has NOT been added to the $params.group"
		}
		redirect(action:index)
	}
	
	//accepts an invitation to join a group
	def addUser = {
		log.debug params.id
		if(params.user && params.id && params.group){
			if(invitationService.acceptAccess(params.user,params.id))
				flash.message = "$params.user user has been added to the $params.group"
			else
				flash.message = "$params.user user has NOT been added to the $params.group"
		}
		redirect(action:index)
	}
	
	//either rejects some user access to a group, or rejects an invitation to join a group
	def rejectInvite = {
		log.debug params.id
		if(params.user && params.id && params.group){
			if(invitationService.rejectAccess(params.id))
				flash.message = "$params.user user will not be joining the $params.group group at this time"
			else
				flash.message = "$params.user user has NOT been rejected access to the $params.group"
		}
		redirect(action:index)
	}
	
}