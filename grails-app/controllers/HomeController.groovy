import grails.converters.*

import javax.servlet.http.HttpServletResponse

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.security.authentication.AccountExpiredException
import org.springframework.security.authentication.CredentialsExpiredException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.web.WebAttributes

import org.springframework.context.*
class HomeController implements ApplicationContextAware{
	ApplicationContext applicationContext 
	def feedService
	def dataAvailableService
	def findingService
	
	/**
	 * Dependency injection for the springSecurityService.
	 */
	def springSecurityService
	
    def index = { 
		def sconfig = SpringSecurityUtils.securityConfig

		if (springSecurityService.isLoggedIn()) {
				redirect uri: sconfig.successHandler.defaultTargetUrl
				return
		}
		
		//get LCCC feed
		log.debug "get feeds"
		def newsFeedMap = feedService.getFeed(CH.config.grails.newsFeedURL)
		def pubFeedMap = feedService.getFeed(CH.config.grails.pubFeedURL)
		//get patient counts for each study
		def studies = Study.list();
		def findings = findingService.getAllFindings()
		def da = dataAvailableService.getMyDataAvailability(studies)
		def breakdowns = dataAvailableService.getBreakdowns(da)
		log.debug "retrieved breakdowns"
		String postUrl = "${request.contextPath}${sconfig.apf.filterProcessesUrl}"
		
		[postUrl: postUrl,diseaseBreakdown:breakdowns["disease"], dataBreakdown:breakdowns["data"], newsFeedMap:newsFeedMap,pubFeedMap:pubFeedMap, findings:findings]
	}
	
	def workflows = {
		
		
	}
	
	def requirementCheck = {
		
	}
	
	def team = {
		
	}
	def releaseNotes = {
		
	}
}
