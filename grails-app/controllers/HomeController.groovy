import grails.converters.*

import javax.servlet.http.HttpServletResponse

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.web.WebAttributes

class HomeController {
	def feedService
	def dataAvailableService
	def findingService
	
	/**
	 * Dependency injection for the springSecurityService.
	 */
	def springSecurityService
	
    def index = { 
	    if(params.register){
		
	     }
		def config = SpringSecurityUtils.securityConfig

		if (springSecurityService.isLoggedIn()) {
				redirect uri: config.successHandler.defaultTargetUrl
				return
		}
		if(session.userId){
			redirect(controller:'workflows')
			return
		}
		//get LCCC feed
		def feedMap = feedService.getFeed()
		
		//get patient counts for each study
		def studies = Study.list();
		def findings = findingService.getAllFindings()
		def da = dataAvailableService.getMyDataAvailability(studies)
		def diseaseBreakdown = [:]
		def dataBreakdown = [:]
		def totalPatient = 0
		def totalStudies = 0
		def totalData = new HashSet()
		if(da["dataAvailability"]){
			totalStudies = da["dataAvailability"].size()
		da["dataAvailability"].each{ study ->
			def disease = study["CANCER"]
			//log.debug "disease: " + disease
			study.each{ key,value ->
				if(!diseaseBreakdown[disease]){
					diseaseBreakdown[disease] = [:]
					diseaseBreakdown[disease]["availableData"] = new HashSet()
				}
					if(key == 'CANCER'){
					if(diseaseBreakdown[disease]["studyNumber"]){
						diseaseBreakdown[disease]["studyNumber"] += 1
						//log.debug "add another $disease study: $study.STUDY"
					}else{
						diseaseBreakdown[disease]["studyNumber"] = 1
					}
					}
					if(key == 'CLINICAL'){
						if(diseaseBreakdown[disease]["patientNumber"]){
								diseaseBreakdown[disease]["patientNumber"] += value
						}else{
								diseaseBreakdown[disease]["patientNumber"] = value
						}
						totalPatient += value
					}
					
				
				if(key != "STUDY" &&  key != "CANCER"){
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
		
	

		String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"
		
		[postUrl: postUrl,diseaseBreakdown:diseaseBreakdown, dataBreakdown:dataBreakdown, feedMap:feedMap, findings:findings]
	}
	
	def workflows = {
		
		
	}
	
	def requirementCheck = {
		
	}
	
	def team = {
		
	}
}
