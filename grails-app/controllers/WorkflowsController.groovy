import groovy.time.*

class WorkflowsController {
	def securityService
	def savedAnalysisService
	def userListService
	def middlewareService
	def dataAvailableService
	def cleanupService
	def invitationService
	def springSecurityService
	
    def index = { 
		if(springSecurityService.isLoggedIn()){
		 def currentUser = springSecurityService.getPrincipal() 
		 def thisUser = GDOCUser.findByUsername(currentUser.username)
		 session.userId = currentUser.username
		
		//last login
		Date lastLogin = thisUser.lastLogin
		if(!session.profileLoaded){
			//set last login
			securityService.setLastLogin(session.userId)
			
			//set admin options
			def isGdocAdmin = securityService.isUserGDOCAdmin(session.userId)
			session.isGdocAdmin = isGdocAdmin
			log.debug "show $session.userId admin options? $session.isGdocAdmin"
			
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
		
		    //cleanup any temporary artifacts left from last session
			cleanup(session.userId)
			session.tempLists = new HashSet()
			session.tempAnalyses = new HashSet()
			
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

			
			if(lastLogin){
				def formattedDate = lastLogin.format('EEE MMM d, yyyy')
				log.debug "users last login was $formattedDate"
				flash.message =  "Welcome back, your last login was $formattedDate. You can check if you have been granted access to new <a href='/${appName()}/userList?listFilter=all'>lists</a> or <a href='/${appName()}/savedAnalysis?analysisFilter=all'>analyses</a> since your last login"
				
			}
			if(params.firstLogin){
				log.debug "this is the user's first login"
				flash.message = "Welcome ... your account has been created in G-DOC! " +  
				"Your current permissions allow you to view public data sets. Once logged in you may gain access to " +
				"other data sets requesting " + 
				"access to the study group via the 'Collaboration Groups' page."
			}
			
			session.profileLoaded = true
			
		}
		def pendingInvites = invitationService.getInvitesThatRequireAction(session.userId,lastLogin)
		if(params.desiredPage){
			log.debug "done with profile loading, user has requested another view"
			redirect(controller:params.desiredPage)
		}
		
		[inviteMessage:pendingInvites["inviteMessage"],requestMessage:pendingInvites["requestMessage"]]
	}
	}
	
	
	def cleanup(userId){
		def user = GDOCUser.findByUsername(userId)
		def myLists = []
		def listsTBD = []
		def analysesTBD = []
		listsTBD = userListService.getTempListIds(userId)
		analysesTBD = savedAnalysisService.getTempAnalysisIds(userId)
		if(listsTBD || analysesTBD){
			cleanupService.cleanupAtLogin(user,listsTBD,analysesTBD)
		}
		
	}
	
	def gatherTempArtifacts(artifactList){
		def artifactsTBD = []
		if(artifactList){
			artifactList.each{ artifact ->
				if(artifact.tags?.contains(Constants.TEMPORARY)){
					log.debug "found $artifact marked as temporary"
					artifactsTBD << artifact.id
				}
			}
		}
		return artifactsTBD
	}
	
}
