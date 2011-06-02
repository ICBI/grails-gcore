import grails.converters.*

@Mixin(ControllerMixin)
@Extension(type=ExtensionType.SEARCH, menu="Clinical Data")
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
		}
		[diseases:getDiseases(),myStudies:session.myStudies]
		
	}
	
	def test = {
		def results = middlewareService.sparqlQuery()
		log.debug results
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
			def criteria = QueryBuilder.build(params, "clinical_", session.dataTypes)
			def biospecimenIds
			if(session.dataTypes.collect { it.target }.contains("BIOSPECIMEN")) {
				def biospecimenCriteria = QueryBuilder.build(params, "biospecimen_", session.dataTypes)
				if(biospecimenCriteria && biospecimenCriteria.size() > 0) {
					biospecimenIds = biospecimenService.queryByCriteria(biospecimenCriteria).collect { it.id }
					log.debug "GOT IDS ${biospecimenIds.size()}"
					if(!biospecimenIds){
						log.debug "no biospecimens found for criteria, return no results"
						searchResults = []
						return processResults(searchResults)
					}
				}
			}
			//log.debug criteria
			searchResults = clinicalService.queryByCriteria(criteria, biospecimenIds)
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
			//cells << patient.dataSourceInternalId
			columns.each { item ->
				if(item != "GDOC ID" && item != "PATIENT ID")
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
		def patient = Patient.findByGdocId(patientId)
		if(!patient.biospecimens)
			return

		def specimens = [:]
		def rows = []
		patient.biospecimens.each { specimen ->
			if(specimen.values) {
				def cells = []
				cells << specimen.name
				session.specimenColumns.each {
					if(it != "SPECIMEN ID") {
						cells << specimen.biospecimenData[it]
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
			log.debug "set study to $shortName"
			def study = Study.findByShortName(shortName)
			StudyContext.setStudy(study.schemaName)
		}
		log.debug "PATIENT IDS: $patientIds"
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
			log.debug "set study to $shortName"
			def study = Study.findByShortName(shortName)
			session.study = study
			StudyContext.setStudy(study.schemaName)
		}
		log.debug "PATIENT IDS: $patientIds"
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
		def values = AttributeType.findAllByTarget("BIOSPECIMEN")
		if(!values) 
			return
		def columns = ["SPECIMEN ID"]
		def headers = values.collect { it.shortName }.sort()
		headers.each {
			columns << it
		}
		session.specimenColumns = columns
		def widths = [70, 70, 70, 70, 70, 70]
		def data = [[name: columns, width: widths]]
		session.subgridModel = data as JSON
	}
	
	private processResults(searchResults) {
		//log.debug searchResults
		def columns = []
		columns << [index: "id", name: "GDOC ID", sortable: true, width: '90']
		//columns << [index: "dataSourceInternalId", name: "PATIENT ID", sortable: true, width: '70']
		def columnNames = []
		log.debug searchResults
		searchResults.each { patient ->
			patient.clinicalData.each { key, value ->
				if(!columnNames.contains(key)) {
					columnNames << key
				}
			}
		}
		columnNames.sort()
		columnNames.each {
			def column = [:]
			column["index"] = it
			column["name"] = it
			column["width"] = '80'
			column["sortable"] = true
			columns << column
		}
		session.columnJson = columns as JSON
		def sortedColumns = ["GDOC ID"]//, "PATIENT ID"]
		columnNames.sort()
		sortedColumns.addAll(columnNames)
		session.results = searchResults
		session.columns = sortedColumns
		session.columnNames = sortedColumns as JSON
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
