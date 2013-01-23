import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.apache.commons.dbcp.BasicDataSource
import javax.jms.Queue
import javax.jms.QueueConnectionFactory
import org.springframework.context.ApplicationContext
import org.apache.commons.logging.LogFactory
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils

class GcoreGrailsPlugin {
	
	static LOG = LogFactory.getLog("GcoreGrailsPlugin")
    // the plugin version
    def version = "2.0.3-SNAPSHOT"
	// groupName
	def groupId = "edu.georgetown.gcore"
    // the version or versions of Grails the plugin is designed for
    def grailsVersion = "1.3.7 > *"
    // the other plugins this plugin depends on
    def dependsOn = [:]
    // resources that are excluded from plugin packaging
    def pluginExcludes = [
            "grails-app/views/error.gsp",
			"scripts/_Events.groovy"
    ]

	def loadAfter = ['springSecurityCore', 'springSecurityLdap']

    // TODO Fill in these fields
    def author = "Your name"
    def authorEmail = ""
    def title = "gcore plugin"
    def description = '''\\
Brief description of the plugin.
'''

    // URL to the plugin's documentation
    def documentation = "http://grails.org/plugin/gcore"

    def doWithWebDescriptor = { xml ->
        // TODO Implement additions to web.xml (optional), this event occurs before 
    }

    def doWithSpring = {
	
		//config = getConfiguration(parentCtx, application)
		
		println "Configuring gcore resources ..."
		
		ldapUserDetailsMapper(CustomLdapUserDetailsMapper) {}
		
		userDetailsService(CustomUserDetailsService){
			securityService = ref("securityService")
		}
	
        entityInterceptor(StudyContextInterceptor)

	 	jdbcTemplate(org.springframework.jdbc.core.JdbcTemplate) {
	        dataSource = ref('dataSource')
	    }

		securityServiceProxy(SecurityService) {bean ->
			jdbcTemplate = ref('jdbcTemplate')
			springSecurityService = ref('springSecurityService')
		  	bean.scope = 'session'
		}
		securityService(org.springframework.aop.scope.ScopedProxyFactoryBean){
			targetBeanName="securityServiceProxy"
			proxyTargetClass=true
		} 
		
		authenticationSuccessHandler(AuthSuccessHandler) {
		        def conf = SpringSecurityUtils.securityConfig
		        requestCache = ref('requestCache')
		        defaultTargetUrl = conf.successHandler.defaultTargetUrl
		        alwaysUseDefaultTargetUrl = conf.successHandler.alwaysUseDefault
		        targetUrlParameter = conf.successHandler.targetUrlParameter
		        useReferer = conf.successHandler.useReferer
		        redirectStrategy = ref('redirectStrategy')
		}
    }

    def doWithDynamicMethods = { ctx ->
		// Setup metaclass methods for string 
		String.metaClass.decamelize = {
			def displayValue = StringUtils.capitalize(delegate)
			displayValue = displayValue.replaceAll(/([^A-Z])([A-Z])/, '$1 $2').trim()
			return displayValue
		}
    }

    def doWithApplicationContext = { applicationContext ->
        // TODO Implement post initialization spring config (optional)
    }

    def onChange = { event ->
        // TODO Implement code that is executed when any artefact that this plugin is
        // watching is modified and reloaded. The event contains: event.source,
        // event.application, event.manager, event.ctx, and event.plugin.
    }

    def onConfigChange = { event ->
        // TODO Implement code that is executed when the project configuration changes.
        // The event is the same as for 'onChange'.
    }

	// Get a configuration instance
    private getConfiguration(ApplicationContext applicationContext, GrailsApplication application) {
	
        def config = application.config

        // load it from class file and merge in to GrailsApplication#config
        try {
            Class gcoreConfigClass = application.getClassLoader().loadClass("GcoreConfig")
            ConfigSlurper configSlurper = new ConfigSlurper(GrailsUtil.getEnvironment())
            config.merge(configSlurper.parse(gcoreConfigClass))
            return config
        } catch (ClassNotFoundException e) {
            LOG.debug("Not found: ${e.message}")
        }
	}
}
