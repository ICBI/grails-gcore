import org.springframework.beans.factory.InitializingBean
import org.codehaus.groovy.grails.web.context.ServletContextHolder as SCH

class DataAvailableService implements InitializingBean {
	def htDataService
	
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
		log.debug "sorted studies and getting snapshot for data for all $studies.size studies " + studies.collect{it.shortName}
		def vocabList = [:]
		def attList = [""]
		def results = []
		if(studies) {
			//get all diseases
			def diseases = []
			diseases = studies.collect{it.cancerSite}.sort{it}.unique()
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
					result['CANCER'] = study.cancerSite
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
			diseases = studies.collect{it.cancerSite}.sort{it}.unique()
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
								if(result["STUDY"] && result["CANCER"]){
										result.each{ key,value ->
											if(key != "STUDY" && key != "CANCER"){
												def exists = DataAvailable.findByStudyNameAndDataType(result["STUDY"],key)
												if(!exists){
													def da = new DataAvailable(studyName:result["STUDY"],diseaseType:result["CANCER"],dataType:key,count:value)
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
	
}