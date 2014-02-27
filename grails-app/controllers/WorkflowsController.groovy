import groovy.time.*
import org.codehaus.groovy.grails.plugins.PluginManagerHolder

@Mixin(ControllerMixin)
class WorkflowsController {
    def myHistory
	def securityService
	def savedAnalysisService
	def userListService
	def middlewareService
	def dataAvailableService
	def cleanupService
	def invitationService
	def springSecurityService
	def htDataService
	def studyDataSourceService
	
	def chooseStudy() {
		
		def responseMap = [:]
		
		if(!session.study) {
			flash.chooseStudy = "Ok then, simply select any one of the following studies...."
		}
		
		else {
			if("study" == session.workflowMode) flash.chooseStudy = "Switching to another study is easy...."
			
			else if("operation" == session.workflowMode) flash.chooseStudy = "Ok, here is a list we have custom made for what you want to do. Just pick any..."
			//if(params.showAll) flash.chooseStudy = "Ok then, simply select any one of the following studies...."
			//else flash.chooseStudy = "Ok, here is a list we have custom made for what you want to do. Just pick any..."
		}
		
		if(params.operation) {
			log.debug("filter studies")
			responseMap['filteredStudies'] = studyDataSourceService.findStudiesWhichSupportOperation(session.myStudies, params.operation)
		}
		responseMap["availableSubjectTypes"] = getSubjectTypes()
		responseMap["diseases"] = getDiseases()
		
		render(view: 'chooseStudy', model: responseMap)
	}
	
	def choosePath() {
		if(session.study) {
			flash.choosePath = "Your current study is ${session.study.shortName} <sup>*&nbsp;&dagger;&nbsp;&Dagger;</sup>"
		}
		
		 else {
			 flash.choosePath = "No problem, tell us what you are interested in..."
		 }
	}

	
	def studySpecificTools() {

        if(session.study) {
            render (view: 'studySpecificTools')
			return
		}
		else {
			redirect (view: "index")
			return
		}
	}
	
	def home() {
		if(springSecurityService.isLoggedIn()){
			log.debug("workflowMode is: "+session.workflowMode)
			
			if("study" == session.workflowMode ) {
				redirect (action: 'studySpecificTools')
				return
			}

			else if("operation" == session.workflowMode){
				redirect (action: 'choosePath')
				return
			}

			else {
				redirect (action: 'index')
				return
			}
		}
	}
	
    def index = {
		if(springSecurityService.isLoggedIn()){
		 
		 def currentUser = springSecurityService.getPrincipal() 
		 def thisUser = GDOCUser.findByUsername(currentUser.username)
		 session.userId = currentUser.username

        //Adding History
        def user = GDOCUser.findByUsername(session.userId)
        def historyStudyNames = History.findAllByUser(user)
        myHistory = []
        log.debug "History ids:"+ historyStudyNames;
        historyStudyNames.sort{it.dateCreated}
        historyStudyNames.each{
            def foundStudyHistory = Study.findById(it.studyId)
            if(foundStudyHistory){
                myHistory << foundStudyHistory
            }
        }
        myHistory = myHistory.unique()
        def size = myHistory.size()
        if(size>0)
        {
            if(size>=3) {myHistory = myHistory.reverse(true)[0..2]}
            else {myHistory = myHistory.reverse(true)[0..size-1]}
        }
        log.debug "My History : "+ myHistory


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
			
			//next gen available
			
			session.nextGenPlugin = false
			if (PluginManagerHolder.pluginManager.hasGrailsPlugin('nextGen')) {
			   session.nextGenPlugin = true
			}
			
			if(lastLogin){
				def formattedDate = lastLogin.format('EEE MMM d, yyyy')
				log.debug "users last login was $formattedDate"
				flash.message =  message(code: "workflows.welcomeBack", args: [formattedDate, g.appName()])
				
			}
			if(params.firstLogin){
				log.debug "this is the user's first login"
				flash.message = message(code: "workflows.firstLogin", args: [g.appName()])
			}
			
			session.profileLoaded = true
			
		}
		def pendingInvites = invitationService.getInvitesThatRequireAction(session.userId,lastLogin)
		if(params.desiredPage){
			log.debug "profile loaded, send user to requested url, $params.desiredPage"
			redirect(uri:params.desiredPage)
		}
		
		[inviteMessage:pendingInvites["inviteMessage"],requestMessage:pendingInvites["requestMessage"],myHistory:myHistory]
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
	
	def research = {
		[availableSubjectTypes:getSubjectTypes(),diseases:getDiseases()]
	}
	
	def popgen = {
		StudyContext.setStudy("THE_1000_GENOMES_PROJECT")
		loadCurrentStudy()
		redirect(controller:'phenotypeSearch')
		return 
	}
	
}
