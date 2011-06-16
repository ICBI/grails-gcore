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
					log.debug "find data available for $study.shortName"
					def studyDA = []
					studyDA = DataAvailable.findAllByStudyName(study.shortName)
					studyDA.each{ da->
						result[da.dataType] = da.count
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
													def da = new DataAvailable(studyName:result["STUDY"],diseaseType:result["DISEASE"],dataType:key,count:value)
													if(da.save(flush:true)){
														log.debug "saved $key data for " + result["STUDY"]
													}
												}else{
													exists.count = value
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
		log.debug "find data for $study.shortName -> total patients in study: " + patients.size()
		result['CLINICAL'] = patients.size()
		
		
		
		allDataTypes.each{ type ->
			if(type != 'CLINICAL'){
				//log.debug "find if $type data in $study.shortName"
				//get specimens
				def samples = []
				samples = Sample.findAllByDesignType(type)
				//get biospecs
				def pw = []
				if(samples){
					def bsWith = []
					def sids = []
					sids = samples.collect{it.id}
					def sidsString = sids.toString().replace("[","")
					sidsString = sidsString.replace("]","")
					def query = "select s.biospecimen_id from " + study.schemaName + ".HT_FILE_CONTENTS s where s.id in ("+sidsString+")"
					bsWith = jdbcTemplate.queryForList(query)
					//log.debug "biospecimens after $bsWith"
					def bsIds = bsWith.collect { id ->
						return id["BIOSPECIMEN_ID"]
					}
					//log.debug bsIds
					def biospecimens = []
					//biospecimens = Biospecimen.getAll(bsIds)
					//get patients
					def patientWith = []
					def bidsString = bsIds.toString().replace("[","")
					bidsString = bidsString.replace("]","")
					def query2 = "select b.patient_id from " + study.schemaName + ".BIOSPECIMEN b where b.biospecimen_id in ("+bidsString+")"
					patientWith = jdbcTemplate.queryForList(query2);//biospecimens.collect{it.patient.id}
					def patIds = patientWith.collect { id ->
						return id["PATIENT_ID"]
					}
					//log.debug "returned patient ids=" + patIds
					if(patIds){
						pw = Subject.getAll(patIds) as Set
						//log.debug "all patients with $type: " + pw.size() + " " + pw
					}
				}
				
				def stats = [:]
				result[type] = pw.size()
			}
		}
		return result
	}
	
}