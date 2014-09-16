import grails.converters.*
@Mixin(ControllerMixin)
//@Extension(type=ExtensionType.SEARCH, menu="Studies")
class StudyDataSourceController {
    def jdbcTemplate
	def myStudies
    def myHistory
	def otherStudies
	def clinicalElements
	def securityService
	def savedAnalysisService
	def userListService
	def middlewareService
	def htDataService
	def attributeValueService
	def studyDataSourceService
    def dataAvailableService
	
    def index = {

		def studyNames = securityService.getSharedItemIds(session.userId, Study.class.name,false)
		log.debug studyNames
		myStudies = []
		studyNames.each{
			def foundStudy = Study.findByShortName(it)
			if(foundStudy){
				myStudies << foundStudy
			}
		}
		myStudies = myStudies.sort{ it.shortName }

        otherStudies = Study.findAll()
		otherStudies.sort { it.shortName }
		log.debug myStudies
		if(myStudies.metaClass.respondsTo(myStudies, "size")) {
			otherStudies.removeAll(myStudies)
		} else {
			otherStudies.remove(myStudies)
		}
		
		loadHistory()

	}
	
	
	def loadHistory() {
		/*
			This loads the previously selected studies by the user
		
		*/
		
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
        if(size>=10) myHistory = myHistory.reverse(true)[0..9]
        else myHistory = myHistory.reverse(true)[0..size-1]
        }
        log.debug myHistory
	}
	
	def justSetStudy = {
	
        if(params.study && session.myStudies){
			session["workflowMode"] = params.workflowMode
			def studyid = new Long(params.study)
			def allowedStudyAccess = session.myStudies.find{it.id == studyid}
			
			if(allowedStudyAccess){
				
				def currStudy = Study.get(params.study)
				session.study = currStudy
				StudyContext.setStudy(session.study.schemaName)
				session.dataTypes = AttributeType.findAll().sort { it.longName }
				loadPatientLists()
				loadReporterLists()
				loadGeneLists()
				loadUsedVocabs()
				loadSubjectTypes()
				loadAttributeRanges()
				session.endpoints = KmAttribute.findAll()
				log.debug("endpoints are: "+session.endpoints)
				session.files = htDataService.getHTDataMap()
				session.dataSetType = session.files.keySet()
				session.supportedOperations = studyDataSourceService.findOperationsSupportedByStudy(session.study)
				addStudyToHistory(session.study)
			}
		}
	}
/*
    def setStudyNoHistory = {

        if(params.study && session.myStudies){
            session["workflowMode"] = params.workflowMode
            def studyid = new Long(params.study)
            def allowedStudyAccess = session.myStudies.find{it.id == studyid}

            if(allowedStudyAccess){

                def currStudy = Study.get(params.study)
                session.study = currStudy
                StudyContext.setStudy(session.study.schemaName)
                session.dataTypes = AttributeType.findAll().sort { it.longName }
                loadPatientLists()
                loadReporterLists()
                loadGeneLists()
                loadUsedVocabs()
                loadSubjectTypes()
                loadAttributeRanges()
                session.endpoints = KmAttribute.findAll()
                log.debug("endpoints are: "+session.endpoints)
                session.files = htDataService.getHTDataMap()
                session.dataSetType = session.files.keySet()
                session.supportedOperations = studyDataSourceService.findOperationsSupportedByStudy(session.study)

            }
        }
    }*/


	
	def setStudy = {
		log.debug("entering");
		log.debug(session.myStudies);
        log.debug "study selected: "+params.study;


        if(params.study && session.myStudies){
			session["workflowMode"] = params.workflowMode
			def studyid = new Long(params.study)
			def allowedStudyAccess = session.myStudies.find{it.id == studyid}
			if(allowedStudyAccess){
				log.debug "set study to $params.study"
				def currStudy = Study.get(params.study)
				session.study = currStudy
				StudyContext.setStudy(session.study.schemaName)
				session.dataTypes = AttributeType.findAll().sort { it.longName }
				loadPatientLists()
				loadReporterLists()
				loadGeneLists()
				loadUsedVocabs()
				loadSubjectTypes()
				loadAttributeRanges()
				session.endpoints = KmAttribute.findAll()
				log.debug("endpoints are: "+session.endpoints)
				session.files = htDataService.getHTDataMap()
				session.dataSetType = session.files.keySet()
				//render session.study.shortName
				session.supportedOperations = studyDataSourceService.findOperationsSupportedByStudy(session.study)
				if(params.operation) {
					redirect(controller: params.operation, action:'index')
					log.debug("redirected to controller: "+params.operation)
				}
				else {
					redirect (controller:'workflows', action: 'studySpecificTools')
					log.debug("redirected to studySpecificTools")
				}

				addStudyToHistory(currStudy)
				
			}else{
				log.debug "user is NOT permitted to access this study"
				redirect(controller:'policies',action:'deniedAccess')
			}
		}
		else render ""
	}
	
	
	def addStudyToHistory(study) {
		/*
			Adds study to history section. This allows users to see studies
			they've recently accessed.
		
		*/
		
		def user = GDOCUser.findByUsername(session.userId)
		def UserHistory = History.findAllByUserAndStudy(user, study)
		def today = new Date()
		log.debug "Today's date :" +today
		def UserHistoryFlag = UserHistory.study.contains(study)
		if(UserHistoryFlag){
			UserHistory.each{
				def historyInstance = History.get(it.id)
				historyInstance.dateCreated = today
				historyInstance.save(flush: true)
			}
		}
		else{
			def historyInstance = new History()
			historyInstance.user = user
			historyInstance.study = study
			historyInstance.save(flush: true)
		}
	}
	
	
	def selectDataType = {
		if(!session.files[params.dataType])
			render g.select(optionKey: 'name', optionValue: 'description', noSelection: ['': 'Select Data Type First'], id: 'dataFile', name: "dataFile")
		else
			render g.select(optionKey: 'name', optionValue: 'description', from: session.files[params.dataType].sort{it.name}, id: 'dataFile', name: "dataFile")
	}
	
	def getWorkflowStudiesAsListOfDict(result) {
		'''
			Returns a list of studies where each study is a dictionary
			
			@param result    - A two element array which contains as the first
							   element the list of studies, and the second element,
							   the list of applicable operations for that study
							   The two lists are guaranteed to have the same length
		'''
	
		// The list of studies specific to a workflow
		def filtered_studies = result[0]
		
		// The list of valid operations for each study
		def valid_operations = result[1]
		
		def list_of_dict = []

		for (int i = 0; i < filtered_studies.size(); i++) {
			def study = filtered_studies[i]
			def ops   = valid_operations[i]
            def patients = studyDataSourceService.getSubjectCount(study)
            def biospecimen = studyDataSourceService.getBiospecimenCount(study)


			def study_dict = [:]
			study_dict["abstract"]       = study.abstractText
			study_dict["studyLongName"] = study.longName
			study_dict["studyName"]     = study.shortName
			study_dict["studyId"]       = study.id
			study_dict["subjectType"]   = study.subjectType
			study_dict["disease"]       = study.disease
            study_dict["content"]       = study.content.type
            study_dict["patients"]      = patients
            study_dict["biospecimen"]      = biospecimen



			def tools = []
			
			
			for (op in ops) {
				def tool = [:]
				tool["name"] = op.name
				tool["type"] = op.type
                tool["description"] = op.description
				tool["link"] = createLink(action:op.action, controller: op.controller)
				tools << tool
			}
			
			study_dict["tools"] = tools
			list_of_dict << study_dict
		}
		
		return list_of_dict
	}
	
	
	def findStudiesForTranslationalResearch = {
		def myStudies = session.myStudies
		render getWorkflowStudiesAsListOfDict(studyDataSourceService.filterByTranslationalResearch(myStudies)) as JSON 
	}
	
	def findStudiesForPersonalizedMedicine = {
		def myStudies = session.myStudies
		render getWorkflowStudiesAsListOfDict(studyDataSourceService.filterByPersonalizedMedicine(myStudies)) as JSON 
	}
	
	def findStudiesForPopulationGenetics = {
		def myStudies = session.myStudies
		render getWorkflowStudiesAsListOfDict(studyDataSourceService.filterByPopulationGenetics(myStudies)) as JSON  
	}
		
	def findStudiesForDisease = {
		def myStudies = []
		def studiesJSON = []
		def operation = params.operation ?: "none"

		if(params.disease && params.subjectType){
			log.debug "grab all studies that have data for $params.disease with type $params.subjectType"
			myStudies = session.myStudies.findAll{it.disease == params.disease}

			myStudies.each{
				//if(it.shortName!="DRUG"){
					def dataAvailability =  session['dataAvailability']
					def hasSubjectMatter =dataAvailability['dataAvailability'].find{elm ->
						if((elm["STUDY"] == it.shortName) && (elm["subjectType"] == params.subjectType) && studyDataSourceService.doesStudySupportOperation(operation, it)){
							def studies = [:]
							studies["studyLongName"] = it.longName
							studies["studyName"] = it.shortName
							studies["studyId"] = it.id
							studies["disease"] = it.disease
							studiesJSON << studies
						}
					}
			//	}
			}
		}

		studiesJSON.sort { it.studyName }
		render studiesJSON as JSON 
	}


	def show = {
		def currStudy = Study.get(params.id)
		def allowAccess = false
		if(currStudy?.hasClinicalData()){
			StudyContext.setStudy(currStudy.schemaName)
			clinicalElements = AttributeType.findAll()
			//log.debug clinicalElements
		}
		if(session.myStudies){
			def mysid = session.myStudies.find{
				 it.id == params.id.toLong()
			}
			if(mysid){
				//session.study = currStudy
				allowAccess = true
			}
		}
		if (!allowAccess){
			log.debug "user is NOT permitted to access this study"
			redirect(controller:'policies',action:'deniedAccess')
		}
		[currStudy:currStudy,clinicalElements:clinicalElements,allowAccess:allowAccess]
	}
	
	def loadRemoteSources() {
		def middlewareSources = middlewareService.loadResource("Datasource", null, session.userId)
		def dataSourceMap = [:]
		log.debug middlewareSources
		if(middlewareSources instanceof Map) {
			middlewareSources.each { key, value ->
				value.resources.each {
					if(!dataSourceMap[it]) {
						dataSourceMap[it] = []
					}
					dataSourceMap[it] << key
				}
			}
		}
		log.debug dataSourceMap
		session.dataSourceMap = dataSourceMap
	}

}
