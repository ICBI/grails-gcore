import grails.converters.*
@Mixin(ControllerMixin)
@Extension(type=ExtensionType.SEARCH, menu="Studies")
class ClinicalController {

	def clinicalService
	def biospecimenService
	def searchResults
	def middlewareService
	def dataAvailableService
	def patientService
	def extensionService
	def attributeValueService
	
    def index = { 
		session.biospecimenIds = null
		def outcome = ""
		session.splitAttribute = ""
		def da = dataAvailableService.getMyDataAvailability(session.myStudies)
		def breakdowns = dataAvailableService.getBreakdowns(da)
		if(session.study) {
			StudyContext.setStudy(session.study.schemaName)
			session.dataTypes = AttributeType.findAll().sort { it.longName }
			session.groups = [:]
			session.dataTypes.each{ type->
				if(type.attributeGroup){
					if(session.groups[type.attributeGroup]){
						session.groups[type.attributeGroup] << type
					}else{
						session.groups[type.attributeGroup] = []
						session.groups[type.attributeGroup] << type
					}
				}else{
					session.groups["NONE"] = []
					session.groups["NONE"] << type
				}
			}
			loadUsedVocabs()
			loadSubjectTypes()
			loadAttributeRanges()
			if(params.splitAttribute){
				log.debug "got split attr $params.splitAttribute"
				session.splitAttribute = params.splitAttribute
			}
			else if(!params.splitAttribute){
				def splitAtts = []
				splitAtts = AttributeType.findAllWhere(splitAttribute: true,target:"PATIENT")
				log.debug "got splitAtts "+splitAtts.collect{it.target}
				if(splitAtts)
					session.splitAttribute = splitAtts[0].shortName
			}
			session.vocabList = session.vocabList.findAll{
				it.target == session.subjectTypes.parent.value()	
			}
		}
		[diseases:getDiseases(),myStudies:session.myStudies,availableSubjectTypes:getSubjectTypes(),diseaseBreakdown:breakdowns["disease"], dataBreakdown:breakdowns["data"]]
		
	}
	
	def advanced = {
		session.biospecimenIds = null
		if(session.study) {
			StudyContext.setStudy(session.study.schemaName)
			session.dataTypes = AttributeType.findAll().sort { it.longName }
			session.groups = [:]
			session.dataTypes.each{ type->
				if(type.attributeGroup){
					if(session.groups[type.attributeGroup]){
						session.groups[type.attributeGroup] << type
					}else{
						session.groups[type.attributeGroup] = []
						session.groups[type.attributeGroup] << type
					}
				}else{
					session.groups["NONE"] = []
					session.groups["NONE"] << type
				}
			}
			loadUsedVocabs()
			loadSubjectTypes()
			loadAttributeRanges()
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
			def criteria = QueryBuilder.build(params, "parent_", session.dataTypes,session.attributeRanges,true)
			def biospecimenIds
			if(session.subjectTypes["child"]) {
				def biospecimenCriteria = QueryBuilder.build(params, "child_", session.dataTypes,session.attributeRanges,true)
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
			processResults(searchResults, biospecimenIds)
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
				if(item != "GDOC ID" && item != "PATIENT ID" && item != "TIMEPOINT") {
					if(patient.clinicalData[item] && patient.clinicalData[item].metaClass.respondsTo(patient.clinicalData[item], "max"))
						cells << patient.clinicalData[item].join(",</br>")
					else
						cells << patient.clinicalData[item]
				}
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
			if(session.biospecimenIds && !session.biospecimenIds.contains(specimen.id))
				return
			if(specimen.values) {
				def cells = []
				cells << specimen.dataSourceInternalId
				session.specimenColumns.each {
					if(it != "ID") {
						if(specimen.clinicalData[it] && specimen.clinicalData[it].metaClass.respondsTo(specimen.clinicalData[it], "max"))
							cells << specimen.clinicalData[it].join(",</br>")
						else
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
		def patientIds
		def idType
		def cleanedIds = []
		
		if(request.JSON){
			patientIds = request.JSON['ids'] as Set
			cleanedIds = patientIds.collect {
				def temp = it.toString().replace("\"", "")
				temp.trim()
				return temp
			}		
			idType = request.JSON['idType']
			session.query = request.JSON
		}
		else if(params.ids){
			params['ids'].tokenize(",").each{
				it = it.replace('[','');
				it = it.replace(']','');
				if(!cleanedIds.contains(it.trim()))
					cleanedIds << it.trim()
			}
			idType = params['idType']
			session.query = params
			log.debug "flattened ids"+ cleanedIds
		}
		log.debug "CLEANED SUBJECT IDZ: $cleanedIds"
		if(request.JSON['study'] || session.study || params.study){
			def shortName
			if(request.JSON['study'])
				shortName = request.JSON['study']
			if(session.study)
				shortName = session.study.shortName
			if(params.study)
				shortName = session.study.shortName
			def study = Study.findByShortName(shortName)
			StudyContext.setStudy(study.schemaName)
			loadSubjectTypes()
			log.debug "set study to $shortName"
		}
		
		log.debug "Are these patients or samples?"
		def results
		if(idType && idType == "biospecimen") {
			results = patientService.patientsForSampleIds(cleanedIds)
		} else {
			def parentsId = clinicalService.getExistingSubjectsIdsForChildIds(cleanedIds)
			if(parentsId){
				log.debug "these are samples ids, lets get subjects"
				results = clinicalService.getPatientsForGdocIds(parentsId)
			}else{
				log.debug "these are patient ids"
				results = clinicalService.getPatientsForGdocIds(cleanedIds)
			}
		}
		log.debug "RESULTS: $results"
		processResults(results)
		render(view:"search")
		
	}
	
	def qsPatientReport = {
		def returnVal = [:]
		log.debug "GOT REQUEST (QS): " + request.JSON
		log.debug "GOT PARAMS: " + params
		
		def patientIds = request.JSON['ids']
		if(request.JSON['study'] || session.study){
			def shortName
			if(session.study)
				shortName = session.study.shortName
			if(request.JSON['study']){
				shortName = request.JSON['study']
			}
			def study = Study.findByShortName(shortName)
			session.study = study
			StudyContext.setStudy(study.schemaName)
			loadSubjectTypes()
			log.debug "setting study to $shortName"
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
		processResults(searchResults, [])
	}
	
	private processResults(searchResults, childIds) {
		//log.debug searchResults
		def allParentIds = [:]
		def allChildIds = [:]
		def parentChildMap = [:]
		def columns = []
		def annotations = [:]
		def fromVariant = session.query['fromVariant']
		
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
				if(childIds && childIds.contains(child.id)) {
					allChildIds[child.id] = child.id
					if(!parentChildMap[patient.id]) {
						parentChildMap[patient.id] = []
					}
					parentChildMap[patient.id] << child.id
				}
			}
		}
		session.biospecimenIds = allChildIds.keySet()
		
		columnNames.sort()
		columnNames.each {
			//println it
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
		
		def sortedColumns = ["GDOC ID"]//, "PATIENT ID"]
		if(session.subjectTypes.timepoints)
			sortedColumns << "TIMEPOINT"
		columnNames.sort()
		sortedColumns.addAll(columnNames)
		
		//add in variant data
		if(fromVariant) {
			def dataExtensions = extensionService.getDataExtensionLabelsForType(DataExtensionType.CLINICAL)
			dataExtensions.each {
				def data = extensionService.getDataFromExtension(it, session.query)
				def returnedData = extensionService.addDataToTable(it, [columns: columns, columnNames: sortedColumns, results: searchResults, data: data])
				print returnedData
				columns = returnedData['columns']
				sortedColumns = returnedData['columnNames']
				searchResults = returnedData['results']
			}
		}
		
		session.columnJson = columns as JSON

		session.results = searchResults
		session.columns = sortedColumns
		session.columnNames = sortedColumns as JSON
		session.allParentIds = allParentIds as JSON
		session.allChildIds = allChildIds as JSON
		session.annotations = annotations
		session.parentChildMap = parentChildMap as JSON
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
	
	
	
	def filter = {
			if(!("XMLHttpRequest".equals(request.getHeader("X-Requested-With")))){
				log.debug "this is NOT an ajax request, so forward to index action with " + params
				redirect(action:index,params:params)
				return
			}else{		
				log.debug "-----------BEGIN AJAX REQUEST--------------"		
				def errors = validateQuery(params, session.dataTypes)
				//log.debug "Clinical Validation?: " + errors
				def queryParams = [:]
				def medians = [:]
				def paramMap = buildQueryParams(params)
				queryParams = paramMap["queryParams"]
				medians = paramMap["medians"]
				
				//addd tags
				def tags = [Constants.SUBJECT_LIST,Constants.PATIENT_LIST]
				def tagsString = tags.toString()
				tagsString = tagsString.replace("[","")
				tagsString = tagsString.replace("]","")
				
				
				log.debug "query Params: " + queryParams
				if(errors && (errors != [:])) {
					flash['errors'] = errors
					flash['params'] = params
					redirect(action:'index',id:session.study.id)
					return
				}
				//println "PARAMS: " + queryParams

				def criteria = QueryBuilder.build(queryParams, "parent_", session.dataTypes,session.attributeRanges,false)
				log.debug "crteria="+criteria
				def biospecimenIds
				def biospecimenCriteria
				if(session.subjectTypes["child"]) {
					biospecimenCriteria = QueryBuilder.build(queryParams, "child_", session.dataTypes,session.attributeRanges,false)
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



				def breakdowns = [:]
				//define columns
				def columns = []
				def columnResults = []



				criteria.keySet().each{
					columns << it
				}

				//NEW for sample
				biospecimenCriteria?.keySet().each{
					columns << it
				}
				//END NEW for sample

				def toDeleteCriteria = [:]
				def toAddCriteria = [:]
				def aggMap = [:]
				if(queryParams.splitAttribute && queryParams.splitAttribute != "NONE"){
					def splitAttParam = queryParams.splitAttribute
					if(splitAttParam.contains("#"))
						splitAttParam = splitAttParam.replace("#","")
					log.debug "split attribute is "+splitAttParam
					session.splitAttribute = splitAttParam
					log.debug "set session split attribute"
					def splitAttribute = AttributeType.findByShortName(splitAttParam)
					def splitAttributeVocabs1 = []
					splitAttributeVocabs1 = AttributeVocabulary.findAllByType(splitAttribute)
					def splitAttributeVocabs = splitAttributeVocabs1.findAll{item -> session.usedVocabs[splitAttribute.id]?.contains(item.term)}
					log.debug "vocabs="+splitAttributeVocabs.collect{it.term}
					splitAttributeVocabs.each{ splitVocab ->
						log.debug splitVocab.term
						//create criteria
						def splitCriteria = [:]
						criteria.each{ key,val->
							splitCriteria[key] = val
						}
						splitCriteria[splitAttribute.shortName] = splitVocab.term
						def atttributeLabel = splitAttribute.shortName+"_"+splitVocab.term
						def filterSubjects = []
						//query on split criteria value (e.g. RECURRENCE-YES)
						log.debug "get summary from group"
						filterSubjects = clinicalService.getSummary(splitCriteria, session.subjectTypes["parent"], biospecimenIds)
						def filterSizeMap = [:]
						filterSizeMap[atttributeLabel] = filterSubjects.size()
						breakdowns[atttributeLabel] = [:]
						columns << atttributeLabel
						filterSubjects = filterSubjects.unique{it.id}
						//cycle through criteria and start intersecting groups
						log.debug "cycle through $filterSubjects"

						aggMap = clinicalService.handleCriteria(breakdowns,criteria,filterSubjects,toAddCriteria,toDeleteCriteria,medians,atttributeLabel)

						//NEW for sample
						if(biospecimenIds)
							aggMap = clinicalService.handleCriteria(aggMap["breakdowns"],biospecimenCriteria,filterSubjects,aggMap["toAddCriteria"],aggMap["toDeleteCriteria"],medians,atttributeLabel)
						//END NEW for sample
						//log.debug "-------------------------------------"
					}
				}
				//split each ends
				else{
					def filterSubjects = []
					def atttributeLabel = "All Subjects"
					//query on split criteria value (e.g. RECURRENCE-YES)
					log.debug "get summary from all"
					filterSubjects = clinicalService.getSummary(criteria, session.subjectTypes["parent"], biospecimenIds)
					def filterSizeMap = [:]
					filterSizeMap[atttributeLabel] = filterSubjects.size()
					breakdowns[atttributeLabel] = [:]
					columns << atttributeLabel
					log.debug "found "+filterSubjects.size() + " subjects before doing criteria"
					if(!criteria){
						breakdowns[atttributeLabel] = filterSubjects.size()
						breakdowns[atttributeLabel+"_ids"] = filterSubjects.collect{it.id}
						breakdowns["resultId"] = "All Subjects"
						def resultList = []
						resultList << breakdowns
						def totalCountMap = [:]
						def comboCounts = [:]
						comboCounts["All_Subjects"]=1
						columns = []
						columns << "All Subjects"
						resultList.each{ result->
							result.each{ res->
								if(res.key.contains("_ids")){
									if(!totalCountMap[res.key]){
										totalCountMap[res.key] = new HashSet()
										res.value.each{
											totalCountMap[res.key] << it
										}	
									}
									else{
										res.value.each{
											totalCountMap[res.key] << it
										}
									}
								}	
								if(res.value.class == Integer){
									if(totalCountMap[res.key]){
										totalCountMap[res.key] += res.value
									}else{
										totalCountMap[res.key] = res.value
									}
								}
							}
						}
						log.debug "total count Searched for ALL with no criteria="+totalCountMap+" others "+columns+"-- "+comboCounts+"-- "+resultList+"-- "+tags
						render(template:"summary",model:[comboCounts:comboCounts,columns:columns,columnResults:resultList,countMap:totalCountMap,tags:tagsString])
						return
					}
					else{
						//cycle through criteria and start intersecting groups
						aggMap = clinicalService.handleCriteria(breakdowns,criteria,filterSubjects,toAddCriteria,toDeleteCriteria,medians,atttributeLabel)
						//NEW for sample
						if(biospecimenIds)
							aggMap = clinicalService.handleCriteria(aggMap["breakdowns"],biospecimenCriteria,filterSubjects,aggMap["toAddCriteria"],aggMap["toDeleteCriteria"],medians,atttributeLabel)
						// END NEW for sample	
					}
				
				}


				//NEW for sample
				biospecimenCriteria.each{key, value->
					criteria[key] = value
				}	
				//END NEW for sample

				criteria = criteria.plus(aggMap["toDeleteCriteria"])
				criteria = criteria.plus(aggMap["toAddCriteria"])

				log.debug "criteria="+criteria


				//recurse
				List<Map<String,String>> list = new LinkedList<Map<String,String>>();
				clinicalService.combinations( criteria, list );
				log.debug list
				def resultList = []
				def someMap = [:]
				for( Map<String,String> combination : list ) {
					def newCombo = [:]
					criteria.keySet().each{ c->
						combination.each{
							if(it.key == c)
							 	newCombo[it.key] = it.value
						}
					}

					def initial = newCombo.keySet() as List
					def entry = initial[0]+":"+newCombo[initial[0]]
					def initialIds = []
					def countMap = [:]
					aggMap["breakdowns"].eachWithIndex{ bdAttributeLabel, breakdownMap, indexx ->
						breakdownMap[entry].each{
							initialIds << it
						}
						//log.debug "initial ids="+initialIds
					    def counts = new HashSet()
						def resultId = ""
						def separates = []
						newCombo.eachWithIndex{ comboKey,comboValue,index->
							def breakdownKey = "$comboKey:$comboValue"
							log.debug "breakdown "+breakdownKey
							def ids = []
							def idsNorm = []
							separates = []
							if(breakdownMap[breakdownKey]){
								ids = breakdownMap[breakdownKey]
								if(!ids)
									ids = []
							}

							else{
								ids = breakdownMap[comboKey]
								if(!ids)
									ids = []
							}
							log.debug "intersect! "+initialIds+" with "+ids
							initialIds = initialIds.intersect(ids)

							initialIds.each{
								separates << it
							}
							countMap[comboKey] = comboValue
							if(newCombo.size()==1){
								resultId += comboKey+"_"+comboValue
							}
							if(index+1<newCombo.size()){
									if(index+2==newCombo.size())
										resultId += comboKey+"_"+comboValue
									else
										resultId += comboKey+"_"+comboValue+"--"

							}

						}
						//log.debug "separates=$separates"
						countMap[bdAttributeLabel+"_ids"] = separates
						countMap[bdAttributeLabel] = initialIds.size()
						countMap["resultId"] = resultId

					}
					resultList << countMap
					//log.debug "count map "+countMap
				 }

				def totalCountMap = [:]
				resultList.each{ result->
					result.each{ res->
						if(res.key.contains("_ids")){
							if(!totalCountMap[res.key]){
								totalCountMap[res.key] = new HashSet()
								res.value.each{
									totalCountMap[res.key] << it
								}	
							}
							else{
								res.value.each{
									totalCountMap[res.key] << it
								}
							}
						}	
						if(res.value.class == Integer){
							if(totalCountMap[res.key]){
								totalCountMap[res.key] += res.value
							}else{
								totalCountMap[res.key] = res.value
							}
						}
					}
				}

				log.debug "totalCountMap="+totalCountMap
				resultList.each{
					log.debug it
				}
				def comboCounts = [:]
				criteria.keySet().each{crit ->
					comboCounts[crit] = 0
					def count = breakdowns.keySet().findAll{
						if(it.contains(crit+":"))
							return it
					}
					comboCounts[crit] = count.size()
				}
				//log.debug "CRITERIA: " + criteria
				//log.debug "CRITERIA COUNT: " + comboCounts
				
				log.debug "this is ajax request and return add"
				log.debug "------------END RETURN---------------------"
				render(template:"summary",model:[comboCounts:comboCounts,columns:columns,columnResults:resultList,countMap:totalCountMap,tags:tagsString])
				return
			}
	}
	
	private Map buildQueryParams(params){
		def medians = [:]
		def queryParams = [:]
		log.debug params
		params.each{ key,value ->
			if(!key.contains("category") && !(key.contains("_parent") && !(key.contains("_child")))){
				key = key.replace("_child","child")
				key = key.replace("_parent","parent")
				if(value?.metaClass.respondsTo(value, 'join')){
					if(key.contains("_range")){
							log.debug "deal with range arrays for $key,$value"
							def sortedValues = []
							value.each{ v->
								log.debug "$v"
								if(v && !"".equals(v)){
									sortedValues << v.split(" - ")[0].toDouble()
									sortedValues << v.split(" - ")[1].toDouble()
								}	
							}
							log.debug "sorted values="+sortedValues.size()
							if(sortedValues && sortedValues.size() == 4){
								log.debug "dealing with medians...sort this "+sortedValues.sort()
								queryParams[key] = sortedValues.first().toString() + " - " + sortedValues.last().toString()
								log.debug "new criteria as strings " + queryParams[key]
								def median = (sortedValues.first() + sortedValues.last())/2
								def medianString = median.toString()
								log.debug "median for $key is $median"
								if(key.contains("child_"))
									key = key.replace("child_range_", "")
								if(key.contains("parent_"))
									key = key.replace("parent_range_", "")
								medians[key] = median 
								log.debug "medians "+ medians
								
							}
							
					}
					else{
						def valueArray = []
						value.each{ v ->
							if(v && !"".equals(v)){
								valueArray << v
							}
						}
						if(valueArray){
							queryParams[key] = valueArray
						}
					}
				}else{
					log.debug "no respond to join, $key"
					if(key.contains("_range")){
							log.debug "deal with one array for $key,$value"
							def sortedValues = []
							sortedValues << value.split(" - ")[0].toDouble()
							sortedValues << value.split(" - ")[1].toDouble()
							log.debug "sorted values="+sortedValues.size()
							
							if(sortedValues && sortedValues.size() == 2){
								log.debug "dealing with medians...sort this "+sortedValues.sort()
								queryParams[key] = sortedValues.first().toString() + " - " + sortedValues.last().toString()
								if(key.contains("child_"))
									key = key.replace("child_range_", "")
								if(key.contains("parent_"))
									key = key.replace("parent_range_", "")
								log.debug "new criteria as strings " + queryParams[key]
								
								def median =  (session.attributeRanges[key]["lowerRange"]+session.attributeRanges[key]["upperRange"])/2
								log.debug "median for $key is $median"
								medians[key] = median
								log.debug "medians "+ medians
								
							}
							
					}
					else{
						if(value!=""){
							queryParams[key]=value
						}
					}

				}
			}
			
				
	
		}
		def splitAttr = queryParams["splitAttribute"]
		log.debug "verify split attribute "+splitAttr+ " is  not in "+queryParams
		if(splitAttr){
			def matchingKey
			queryParams.keySet().each{key ->
				if(key.contains("parent_vocab_"))
					key = key.replace("parent_vocab_", "")
				if(key.contains("child_vocab_"))
					key = key.replace("child_vocab_", "")
				if(key == splitAttr)
					matchingKey = key
			}
			if(matchingKey){
				log.debug "remove "+splitAttr+" from "+queryParams
				queryParams.remove("splitAttribute")
			}
		}
		return [queryParams:queryParams,medians:medians]
	}
	
}
