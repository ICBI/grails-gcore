import grails.converters.*

@Mixin(ControllerMixin)
@Extension(type=ExtensionType.SEARCH, menu="Studies")
class ClinicalController {

	def clinicalService
	def biospecimenService
	def searchResults
	def middlewareService
	
    def index = { 
		if(session.study) {
			StudyContext.setStudy(session.study.schemaName)
			session.dataTypes = AttributeType.findAll().sort { it.longName }
			loadUsedVocabs()
			loadSubjectTypes()
		}
		[diseases:getDiseases(),myStudies:session.myStudies,availableSubjectTypes:getSubjectTypes()]
		
	}
	
	def search = {
			def errors = validateQuery(params, session.dataTypes)
			log.debug "Clinical Validation?: " + errors
			log.debug "Params: " + params
			if(errors && (errors != [:])) {
				flash['errors'] = errors
				flash['params'] = params
				redirect(action:'index',id:session.study.id)
				return
			}
			println "PARAMS: " + params
			def criteria = QueryBuilder.build(params, "parent_", session.dataTypes)
			def biospecimenIds
			if(session.subjectTypes["child"]) {
				def biospecimenCriteria = QueryBuilder.build(params, "child_", session.dataTypes)
				if(biospecimenCriteria && biospecimenCriteria.size() > 0) {
					biospecimenIds = clinicalService.queryByCriteria(biospecimenCriteria, session.subjectTypes["child"], biospecimenIds).collect { it.id }
					log.debug "GOT IDS ${biospecimenIds.size()}"
					if(!biospecimenIds){
						log.debug "no biospecimens found for criteria, return no results"
						searchResults = []
						return processResults(searchResults)
					}
				}
			}
			log.debug "CRITERIA: " + criteria
			searchResults = clinicalService.queryByCriteria(criteria, session.subjectTypes["parent"], biospecimenIds)
			processResults(searchResults)
	}
	
	def searchFromAnalysis = {
		
	}
	
	def viewPatientReport = {
		render(view:"search")
	}
	
	def view = {
		searchResults = session.results
		def columns = session.columns
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
			if(sortColumn == "id" || sortColumn == "dataSourceInternalId") {
				val1 = r1[sortColumn]
				val2 = r2[sortColumn]
			} else if(sortColumn == "timepoint") {
				def comparator = new TimepointComparator()
				if(params.sord != 'asc') {
					return comparator.compare(r1[sortColumn], r2[sortColumn])
				} else {
					return comparator.compare(r2[sortColumn], r1[sortColumn])
				}
			} else {
				val1 = r1.clinicalData[sortColumn]
				val2 = r2.clinicalData[sortColumn]
				if(val1 && val1.isDouble()) {
					val1 = r1.clinicalData[sortColumn].toDouble()
				} 
				if(val2 && val2.isDouble()) {
					val2 = r2.clinicalData[sortColumn].toDouble()
				}
				
			}
			
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
		session.results = sortedResults
		sortedResults.getAt(startIndex..<endIndex).each { patient ->
			def cells = []
			cells << patient.gdocId
			if(session.subjectTypes.timepoints)
				cells << patient.timepoint
			columns.each { item ->
				if(item != "GDOC ID" && item != "PATIENT ID" && item != "TIMEPOINT")
					cells << patient.clinicalData[item]
			}
			results << [id: patient.gdocId, cell: cells]
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
	
	def biospecimen = {
		def patientId = params["id"]
		if(!patientId)
			return
		def patient = Subject.get(patientId)
		if(!patient.children)
			return

		def specimens = [:]
		def rows = []
		patient.children.each { specimen ->
			if(specimen.values) {
				def cells = []
				cells << specimen.dataSourceInternalId
				session.specimenColumns.each {
					if(it != "ID") {
						cells << specimen.clinicalData[it]
					}
				}
				rows << ["id": specimen.id, cell: cells]
			}
		}
		specimens["rows"] =  rows
		render specimens as JSON
	}
	
	def patientReport = {
		def returnVal = [:]
		log.debug "GOT REQUEST: " + request.JSON
		log.debug "GOT PARAMS: " + params
		
		def patientIds = request.JSON['ids']
		if(request.JSON['study']){
			def shortName = request.JSON['study']
			def study = Study.findByShortName(shortName)
			StudyContext.setStudy(study.schemaName)
			loadSubjectTypes()
			log.debug "set study to $shortName"
		}
		log.debug "SUBJECT IDS: $patientIds"
		def cleanedIds = patientIds.collect {
			def temp = it.toString().replace("\"", "")
			temp.trim()
			return temp
		}
		log.debug "CLEANED : $cleanedIds"
		def results = clinicalService.getPatientsForGdocIds(cleanedIds)
		log.debug "RESULTS: $results"
		processResults(results)
		render(view:"search")
		
	}
	
	def qsPatientReport = {
		def returnVal = [:]
		log.debug "GOT REQUEST: " + request.JSON
		log.debug "GOT PARAMS: " + params
		
		def patientIds = request.JSON['ids']
		if(request.JSON['study']){
			def shortName = request.JSON['study']
			def study = Study.findByShortName(shortName)
			session.study = study
			StudyContext.setStudy(study.schemaName)
			loadSubjectTypes()
			log.debug "set study to $shortName"
		}
		log.debug "SUBJECT IDS: $patientIds"
		def cleanedIds = patientIds.collect {
			def temp = it.toString().replace("\"", "")
			temp.trim()
			return temp
		}
		log.debug "CLEANED : $cleanedIds"
		def results = clinicalService.getPatientsForGdocIds(cleanedIds)
		log.debug "RESULTS: $results"
		processResults(results)
		def timestamp = System.currentTimeMillis()
		returnVal['url'] = "/${g.appName()}/clinical/viewPatientReport?timestamp=${timestamp}"
		//render(view:"search")
		render returnVal as JSON
		
	}
	
	private void setupBiospecimens() {
		session.subgridModel = [:]
		if(session.subjectTypes["child"]) {
			def values = AttributeType.findAllByTarget(session.subjectTypes["child"].value())
			if(!values) 
				return
			def columns = ["ID"]
			def headers = values.collect { it.shortName }.sort()
			def widths = [200]
			headers.each {
				columns << it
				widths << 200
			}
			session.specimenColumns = columns
			def data = [[name: columns, width: widths]]
			session.subgridModel = data as JSON
		}
	}
	
	private processResults(searchResults) {
		//log.debug searchResults
		def allParentIds = [:]
		def allChildIds = [:]
		def columns = []
		def annotations = [:]
		columns << [index: "id", name: "GDOC ID", sortable: true, width: '100']
		if(session.subjectTypes.timepoints)
			columns << [index: "timepoint", name: "TIMEPOINT", sortable: true, width: '100']
		def columnNames = []
		log.debug searchResults
		searchResults.each { patient ->
			patient.clinicalData.each { key, value ->
				if(!columnNames.contains(key)) {
					columnNames << key
				}
				if(key == "PARENT_CELL_LINE") {
					def annotation = Annotation.findByName(value)
					annotations[value] = annotation
				}
			}
			allParentIds[patient.id] = patient.id
			patient.children.each { child ->
				allChildIds[child.id] = child.id
			}
		}
		columnNames.sort()
		columnNames.each {
			println it
			def column = [:]
			column["index"] = it
			column["name"] = it
			column["width"] = '80'
			column["sortable"] = true
			if(it == "PARENT_CELL_LINE") {
				def formatOptions = [baseLinkUrl: 'annotationLink', idName: 'id', ]
				column["formatter"] = 'showlink'
				column["formatoptions"] = formatOptions
			}
			columns << column
		}
		session.columnJson = columns as JSON
		def sortedColumns = ["GDOC ID"]//, "PATIENT ID"]
		if(session.subjectTypes.timepoints)
			sortedColumns << "TIMEPOINT"
		columnNames.sort()
		sortedColumns.addAll(columnNames)
		session.results = searchResults
		session.columns = sortedColumns
		session.columnNames = sortedColumns as JSON
		session.allParentIds = allParentIds as JSON
		session.allChildIds = allChildIds as JSON
		session.annotations = annotations
		setupBiospecimens()
	}
	
	private Map validateQuery(params, dataTypes) {
		def errors = [:]
		dataTypes.each {
			if(!it.vocabulary && !it.qualitative && it.lowerRange == null) {
				def input = params.find { param ->
					param.key.contains(it.shortName)
				}
				if(input.value[0] && !input.value[0].isDouble()) {
					errors[input.key] = [message: "clinical.range.number", field: [it.longName]]
				}
				if(input.value[1] && !input.value[1].isDouble()) {
					errors[input.key] = [message: "clinical.range.number", field: [it.longName]]
				}
				if(input.value[0] && input.value[1] && input.value[0].isDouble() && input.value[0].isDouble()) {
					def min = input.value[0].toDouble()
					def max = input.value[1].toDouble()
					if(min >= max) {
						errors[input.key] = [message: "clinical.range.invalid", field: [it.longName]]
					}
				}
				log.debug "VALUES: " + input.value[0] + input.value[1]
			}
		}
		return errors
	}
	
	def download = {
		response.setHeader("Content-disposition", "attachment; filename=data_export.csv")
		response.contentType = "application/octet-stream" 

		def outs = response.outputStream 
		def cols = [:] 
		def columns = session.columns
		
		outs << columns.join(",") + "\n"
		session.results.each { data ->
			def tempData = []
			columns.each {
				if(it == 'GDOC ID')
					tempData << data.id
				else {
					if(!data.clinicalData[it])
						tempData << ''
					else
						tempData << data.clinicalData[it]
				}
			}
			outs << tempData.join(",")
		    outs << "\n"
		}
		outs.flush()
		outs.close()
	}
	
}
