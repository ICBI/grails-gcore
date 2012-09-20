import org.springframework.beans.factory.InitializingBean
import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH

class DataAvailableService implements InitializingBean {
	def htDataService
	def jdbcTemplate
	
	void afterPropertiesSet() {
		def da = getDataAvailability()
		SCH.getServletContext().setAttribute("dataAvailability", da)
	}

	
	def getDataAvailability(){
		log.debug "get all study data availability"
		def studies = []
		studies = Study.list();
		if(studies){
			studies.sort{it.shortName}
		}
		log.debug "sorted studies and getting snapshot for data for all $studies.size studies " 
		def vocabList = [:]
		def attList = [""]
		def results = []
		if(studies) {
			//get all diseases
			def diseases = []
			diseases = studies.collect{it.disease}.sort{it}.unique()
			diseases.remove("N/A")
			log.debug "diseases are $diseases"
			vocabList["diseases"] = diseases
			//get all datatypes
			def allDataTypes = []
			allDataTypes = htDataService.getAllHTDataTypes()
			vocabList["allDataTypes"] = allDataTypes as Set
			vocabList["dataAvailability"] = results
			studies.each{ study ->
				if(study.shortName != 'DRUG'){
					def result = [:]
					result['STUDY'] = study.shortName
					result['DISEASE'] = study.disease
					result["subjectType"] = study.subjectType
					log.debug "find data available for $study.shortName"
					def studyDA = []
					studyDA = DataAvailable.findAllByStudyName(study.shortName)
					studyDA.each{ da->
						result[da.dataType] = da.dataTypeCount
					}
					results << result
				}
			}
			vocabList["dataAvailability"] = results
		}
		log.debug "data available " + vocabList
		
		return vocabList
	}
	
	def loadDataAvailability(){
		log.debug "load all study availability"
		def studies = []
		studies = Study.list();
		if(studies){
			studies.sort{it.shortName}
		}
		def vocabList = [:]
		def attList = [""]
		def results = []
		if(studies) {
			//get all diseases
			def diseases = []
			diseases = studies.collect{it.disease}.sort{it}.unique()
			diseases.remove("N/A")
			vocabList["diseases"] = diseases
			//get all datatypes
			def allDataTypes = []
			allDataTypes = htDataService.getAllHTDataTypes()
			vocabList["allDataTypes"] = allDataTypes as Set
			studies.each{ study ->
				//log.debug "gather atts for $study"
					if(study.shortName != 'TEST-DATA'){
						StudyContext.setStudy(study.schemaName)
						if(study.content){
							StudyContext.setStudy(study.schemaName)
							def result = queryStudyData(study,allDataTypes)
							if(result){	
								results << result
								if(result["STUDY"] && result["DISEASE"]){
										result.each{ key,value ->
											if(key != "STUDY" && key != "DISEASE"){
												def exists = DataAvailable.findByStudyNameAndDataType(result["STUDY"],key)
												if(!exists){
													def da = new DataAvailable(studyName:result["STUDY"],diseaseType:result["DISEASE"],dataType:key,dataTypeCount:value)
													if(da.save(flush:true)){
														log.debug "saved $key data for " + result["STUDY"]
													}
												}else{
													exists.dataTypeCount = value
													if(exists.save(flush:true)){
														log.debug "updated $key data for " + result["STUDY"]
													}
												}
											}
										}			
								}
									
							}
						}
					}
				
			}
			vocabList["dataAvailability"] = results
		}
		//log.debug "DA: $vocabList"
		return vocabList
	}
	
	def getMyDataAvailability(studies){
		def myDa = [:]
		def appDa
		def servletContext = SCH.servletContext
		if(servletContext){
			appDa = servletContext.getAttribute("dataAvailability")
		}
		else appDa = getDataAvailability()
		myDa["dataAvailability"] = []
		myDa["diseases"] = appDa["diseases"]
		myDa["allDataTypes"] = appDa["allDataTypes"]
		appDa['dataAvailability'].each{elm ->
			def studyName = elm.find{ key, value ->
				if(key == 'STUDY'){
					return value
				}
			}
			studies.each{ myStudy ->
				if(myStudy.shortName == elm['STUDY']){
					myDa["dataAvailability"] << elm
				}
			}
		}
		log.debug "retrieved my data availability"
		return myDa
	}
	
	def queryStudyData(study, allDataTypes){
		StudyContext.setStudy(study.schemaName)
		def result = [:]
		def studyName = [:]
	
		
		//find all patients (clnicalData)
		def patients = []
		patients = Subject.findAll()
		result['STUDY'] = study.shortName
		result['DISEASE'] = study.disease
		
		/**remove this and jump into each block below
		log.debug "find data for $study.shortName -> total patients in study: " + patients.size()
		result['CLINICAL'] = patients.size()**/
		
		
		
		allDataTypes.each{ type ->
			//if Patient, Sample, Cell-Line or animal model
			//get size on findAllBy for Subject, if not, continue with this method
			if(type != SubjectType.PATIENT.value() && type!= Constants.BIOSPECIMEN &&
				type != SubjectType.CELL_LINE.value() && type != SubjectType.ANIMAL_MODEL.value() && type != SubjectType.REPLICATE.value()){
				//log.debug "find if $type data in $study.shortName"
				//get specimens
				def samples = []
				def patIds = []
				samples = Sample.findAllByDesignType(type)
				//get biospecs
				if(samples){
					def bsWith = []
					def sids = []
					sids = samples.collect{it.id}
					//def query = "select s.biospecimen_id from " + study.schemaName + ".HT_FILE_CONTENTS s where s.id in ("+sidsString+")"
					def query = "select s.biospecimen_id from " + study.schemaName + ".HT_FILE_CONTENTS s where s.id in ("
					def subquery = "select hc.ID from "+ study.schemaName +".HT_FILE_CONTENTS hc where hc.design_type='"+type+"')"
					
					query += subquery
					
					log.debug "the select statement is now: "
					log.debug query
					
					
					bsWith = jdbcTemplate.queryForList(query)
					//log.debug "biospecimens after $bsWith"
					def bsIds = bsWith.collect { id ->
						return id["BIOSPECIMEN_ID"]
					}
					//log.debug "got bi ids"+bsIds
					def biospecimens = []
					//biospecimens = Biospecimen.getAll(bsIds)
					//get patients
					def patientWith = []
					def bidsString = bsIds.toString().replace("[","")
					bidsString = bidsString.replace("]","")
					//def query2 = "select b.subject_id from " + study.schemaName + ".BIOSPECIMEN b where b.biospecimen_id in ("+bidsString+")"
					def query2 = "select distinct sb.subject_id from " + study.schemaName + ".BIOSPECIMEN sb where sb.biospecimen_id in ("+query+")"
					log.debug "the FULL select statement is now: "
					log.debug query2
					patientWith = jdbcTemplate.queryForList(query2);//biospecimens.collect{it.patient.id}
					patIds = patientWith.collect { id ->
						return id["SUBJECT_ID"]
					}
					//log.debug "returned patient ids=" + patIds + " for $type"
					if(patIds){
						log.debug "all subjects with $type: " + patIds.size()
					}
				}	
				def stats = [:]
				result[type] = patIds.size()
			}
			else if (type == Constants.BIOSPECIMEN){
				def biospecCount = Biospecimen.count()
				result[type] = biospecCount
			}
			else{
				def subjects = []
				subjects = Subject.findAllByType(type)
				result[type] = subjects.size()
			}
		}
		return result
	}
	
	def getBreakdowns(da){
		def diseaseBreakdown = [:]
		def dataBreakdown = [:]
		def totalPatient = 0
		def totalBiospecimen = 0
		def totalStudies = 0
		def totalData = new HashSet()
		if(da["dataAvailability"]){
			totalStudies = da["dataAvailability"].size()
		da["dataAvailability"].each{ study ->
			def disease = study["DISEASE"]
			//log.debug "disease: " + disease
			study.each{ key,value ->
				if(!diseaseBreakdown[disease]){
					diseaseBreakdown[disease] = [:]
					diseaseBreakdown[disease]["availableData"] = new HashSet()
				}
					if(key == 'DISEASE'){
					if(diseaseBreakdown[disease]["studyNumber"]){
						diseaseBreakdown[disease]["studyNumber"] += 1
						//log.debug "add another $disease study: $study.STUDY"
					}else{
						diseaseBreakdown[disease]["studyNumber"] = 1
					}
					}
					if(key == 'PATIENT'){
						if(diseaseBreakdown[disease]["patientNumber"]){
								diseaseBreakdown[disease]["patientNumber"] += value
						}else{
								diseaseBreakdown[disease]["patientNumber"] = value
						}
						totalPatient += value
					}
					if(key == 'BIOSPECIMEN'){
						if(diseaseBreakdown[disease]["biospecimenNumber"]){
								diseaseBreakdown[disease]["biospecimenNumber"] += value
						}else{
								diseaseBreakdown[disease]["biospecimenNumber"] = value
						}
						totalBiospecimen += value
					}
					//add map values below
					
				
				if(key != "STUDY" &&  key != "DISEASE" && key != "subjectType"){
					if(value > 0){
						//log.debug  "$disease has $key available"
						def nameAndImage = [:]
						def image = key.replace(" ","_")+"_icon.gif" 
						def k  = key.replace("_"," ")
						nameAndImage[k] = image
						diseaseBreakdown[disease]["availableData"] << nameAndImage
						if(dataBreakdown[k]){
							dataBreakdown[k] += 1
						}
						else dataBreakdown[k] = 1
						totalData << nameAndImage
					}
				}
			}
		}
	}
		log.debug "got all data and diseases"
		diseaseBreakdown['<i>Total</i>'] = [:]
		diseaseBreakdown['<i>Total</i>']['patientNumber'] = totalPatient
		diseaseBreakdown['<i>Total</i>']['biospecimenNumber'] = totalBiospecimen
		diseaseBreakdown['<i>Total</i>']['studyNumber'] = totalStudies
		diseaseBreakdown['<i>Total</i>']['availableData'] = totalData
		def breakdowns = [:]
		breakdowns["disease"] = diseaseBreakdown
		breakdowns["data"] = dataBreakdown
		return breakdowns
	}
	
}