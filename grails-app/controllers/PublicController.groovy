import grails.converters.*

class PublicController {
	
	def dataAvailableService
	def findingService
	
    def findings = { 
	    log.debug "accessing findings"
		def findings = findingService.getAllFindings()
		def abbrFindings = []
		findings.each{finding ->
			def findingInfo = [:]
			findingInfo["title"] = finding.title
			findingInfo["date"] = finding.dateCreated.getDateString()
			findingInfo["description"] = finding.description
			findingInfo["curator"] = finding.author.firstName + " " + finding.author.lastName
			findingInfo["evidence"] = ""
			if(finding.principalEvidence){
				if(finding.principalEvidence.userList){
				  def listItems = finding.principalEvidence.userList.listItems.collect{it.value}
				  findingInfo["evidence"] = listItems
				}
			}
			abbrFindings << findingInfo
		}
		render abbrFindings as JSON
	}
	
	def dataAvailable = {
		log.debug "accessing da"
		def diseaseBreakdown = [:]
		def dataBreakdown = [:]
		def totalPatient = 0
		def totalStudies = 0
		def totalBiospecimen = 0
		def totalData = new HashSet()
		def studies = Study.list();
		def da = dataAvailableService.getMyDataAvailability(studies)
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
		diseaseBreakdown['<i>TOTAL</i>'] = [:]
		diseaseBreakdown['<i>TOTAL</i>']['patientNumber'] = totalPatient
		diseaseBreakdown['<i>TOTAL</i>']['studyNumber'] = totalStudies
		diseaseBreakdown['<i>TOTAL</i>']['availableData'] = totalData
		log.debug diseaseBreakdown
		log.debug dataBreakdown
		
		render diseaseBreakdown as JSON
	}
	
}