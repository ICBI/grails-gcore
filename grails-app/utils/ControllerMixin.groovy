import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH
import org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes as GA

class ControllerMixin {
	
	static isAccessible(self, id){
		def accessible = false
		def analysisId = new Long(id)
		def allAnalysisIds = self.savedAnalysisService.getAllAnalysesIds(self.session.sharedAnalysisIds,self.session.userId)
		if (allAnalysisIds && allAnalysisIds.contains(analysisId))
			accessible = true
		return accessible
	}
	
	static isListAccessible(self, id){
		def accessible = false
		def listId = new Long(id)
		def allListIds = self.userListService.getAllListIds(self.session.sharedListIds,self.session.userId)
		if (allListIds && allListIds.contains(listId))
			accessible = true
		return accessible
	}
	
	static isAnalysisAuthor(self, id){
		def isAuthor = false
		self.log.debug "LOOKING UP author of analysis $id"
		def item = SavedAnalysis.get(id)
		if(self.session.userId == item?.author?.username){
			isAuthor = true
		}
		return isAuthor
	}
	
	static isListAuthor(self, id){
		def isAuthor = false
		self.log.debug "LOOKING UP author of list $id"
		def item = UserList.get(id)
		if(self.session.userId == item?.author?.username){
			isAuthor = true
		}
		return isAuthor
	}
	
    static getDiseases(self) {
		def diseases = self.session.myStudies.collect{it.disease}.unique().sort()
		diseases.remove("N/A")
		return diseases
    }

	static getSubjectTypes(self){
		def subjectTypes = [(SubjectType.PATIENT.value()):"PATIENT",(SubjectType.ANIMAL_MODEL.value()):'ANIMAL MODEL',(SubjectType.CELL_LINE.value()):'CELL LINE']
		return subjectTypes
	}	

	static loadPatientLists(self) {
		if(self.session.study){
			StudyContext.setStudy(self.session.study.schemaName)
			def lists = []
			lists = self.userListService.getListsByTagAndStudy(Constants.SUBJECT_LIST,self.session.study,self.session.sharedListIds, self.session.userId)
			self.session.patientLists = lists
		}
	}
	
	static loadReporterLists(self) {
		if(self.session.study) {
			def reporterLists = []
			reporterLists = self.userListService.getListsByTag(Constants.REPORTER_LIST,self.session.sharedListIds,self.session.userId)
			self.session.reporterLists = reporterLists
		}
	}
	
	static loadGeneLists(self) {
		if(self.session.study) {
			def geneLists = []
			geneLists = self.userListService.getListsByTag(Constants.GENE_LIST,self.session.sharedListIds,self.session.userId)
			self.session.geneLists = geneLists
		}
	}
	
	static loadCurrentStudy(self) {
		def currStudy = Study.findBySchemaName(StudyContext.getStudy())
		if(!self.session.study || (currStudy.schemaName != self.session.study.schemaName)){
			self.session.study = currStudy
			self.session.dataTypes = AttributeType.findAll().sort { it.longName }
			loadPatientLists(self)
			loadReporterLists(self)
			loadGeneLists(self)
			loadSubjectTypes(self)
			loadAttributeRanges(self)
			self.session.endpoints = KmAttribute.findAll()
			self.session.files = self.htDataService.getHTDataMap()
			self.session.dataSetType = self.session.files.keySet()
		}
			
	}
	
	static loadAttributeRanges(self){
		def schemaName = StudyContext.getStudy()
		self.session.attributeRanges = [:]
		def rangeAtts = []
		rangeAtts = AttributeType.findAllWhere(vocabulary: false)
		def rangeAttsMap = [:]
		def ctx = SCH.servletContext.getAttribute(GA.APPLICATION_CONTEXT)
		def attributeValueService = ctx.attributeValueService
		//log.debug "get attributeValueService="+attributeValueService
		rangeAtts.each {
			if(it.upperRange!=null && it.lowerRange!=null){
				def rangeName = it.shortName
				def rangeId = it.id
				rangeAttsMap[rangeName] = [:]
				def upperVal = attributeValueService.findUpperRange(rangeId,schemaName)
				def lowerVal = attributeValueService.findLowerRange(rangeId,schemaName)
				rangeAttsMap[rangeName]["upperRange"] = upperVal
				rangeAttsMap[rangeName]["lowerRange"] = lowerVal
			}
		}
		self.session.attributeRanges = rangeAttsMap
	}
	
	static loadUsedVocabs(self) {
		def criteria = AttributeValue.createCriteria()
		def results = criteria {
			projections {
				distinct(["type.id", "value"])
				property("type")
			}
		}
		
		def attNamesMap = [:]
		def attTypeMap = [:]
		def usedVocabMap = [:]
		def vocabList = new HashSet()
		results.each {
			if(it[2].vocabulary){
				vocabList << it[2]
			}
			if(!attNamesMap[it[2].shortName])
				attNamesMap[it[2].shortName] = it[2].longName
			if(it[2].attributeGroup){
				if(!(attTypeMap[it[2].attributeGroup])){
					attTypeMap[it[2].attributeGroup] = new HashSet()
					attTypeMap[it[2].attributeGroup] << it[2]
				}
				else{
					attTypeMap[it[2].attributeGroup] << it[2]
				}
			}	
			if(!usedVocabMap[it[0]])
				usedVocabMap[it[0]] = []
			usedVocabMap[it[0]] << it[1]
				
		}
		self.session.vocabList = vocabList?.sort{it.shortName}
		self.session.attNamesMap = attNamesMap
		self.session.attTypeMap = attTypeMap
		self.session.usedVocabs = usedVocabMap
	}
	
	static loadSubjectTypes(self) {
		def criteria = Subject.createCriteria()
		def results = criteria {
			projections {
				distinct(["type", "parent.id"])
			}
		}
		def subjectTypes = [:]
		results.each {
			if(!it[1])
				subjectTypes["parent"] = it[0]
			else 
				subjectTypes["child"] = it[0]
		}
		criteria = Subject.createCriteria()
		results = criteria {
			projections {
				distinct("timepoint")
			}
		}
		results.removeAll([null])
		if(results) {
			results.sort(new TimepointComparator())
			subjectTypes["timepoints"] = results
		}
		self.session.subjectTypes = subjectTypes
	}
	
	static lookupListIds(self, ids, params) {
		def listIds = []
		for(def listId : ids) {
			println "IDDDD: $listId CLASS: ${listId.class}"
			// check if list is old, identified by string name
			// if so, attempt to lookup by name and author
			if (listId && ((listId instanceof Integer) || (listId instanceof Long) || (listId.isLong() && listId.toLong()))) {
				println "is long and to long"
				//make sure lists have not been deleted
				if(listId && !listId.equals(null)){
					def list = UserList.get(listId)
					if(!list) {
						self.log.debug "one or more lists used in this analysis has been deleted"
						self.flash.analysisQuery = params
						self.redirect(controller:'savedAnalysis', action:'insufficientData')
						return
					}
					listId = list.id
					listIds << listId
				}
			} else if(listId && !listId.equals(null)){
				self.log.debug "list is legacy and is not identified by numeric id -- Attempting to lookup by name"
				listId = self.userListService.findByNameAndUserId(listId, self.session.userId)
			}

		}
		return (listIds.size == 1) ? listIds[0] : listIds 
	}
}
