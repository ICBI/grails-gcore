import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.apache.commons.dbcp.BasicDataSource
import javax.jms.Queue
import javax.jms.QueueConnectionFactory
import org.springframework.context.ApplicationContext
import org.apache.commons.logging.LogFactory
import org.apache.commons.lang.StringUtils
import grails.converters.*

class GcoreGrailsPlugin {
	
	static LOG = LogFactory.getLog("GcoreGrailsPlugin")
    // the plugin version
    def version = "0.1.3"
	// groupName
	def groupId = "edu.georgetown.gcore"
    // the version or versions of Grails the plugin is designed for
    def grailsVersion = "1.3.7 > *"
    // the other plugins this plugin depends on
    def dependsOn = [recaptcha:'0.5.2',searchable:'0.5.5', taggable:'0.6.1', jquery:'1.3.2.4', jms:'1.1', mail:'0.9',quartz:'0.4.1', springSecurityCore:'1.1.2',springSecurityLdap:'1.0.3']
    // resources that are excluded from plugin packaging
    def pluginExcludes = [
            "grails-app/views/error.gsp"
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
	
		config = getConfiguration(parentCtx, application)
		
		println "Configuring gcore ..."
		
		ldapUserDetailsMapper(CustomLdapUserDetailsMapper) {}
		
		userDetailsService(CustomUserDetailsService){
			securityService = ref("securityService")
		}
	
        entityInterceptor(StudyContextInterceptor)

		jndiTemplate(org.springframework.jndi.JndiTemplate) {
			environment = ["java.naming.factory.initial":"org.jnp.interfaces.NamingContextFactory",
								"java.naming.provider.url": CH.config.jmsserver,
								"java.naming.factory.url.pkgs":"org.jboss.naming:org.jnp.interfaces"]
		}

	 	jdbcTemplate(org.springframework.jdbc.core.JdbcTemplate) {
	        dataSource = ref('dataSource')
	    }

		jmsTemplate(org.springframework.jms.core.JmsTemplate) {
			connectionFactory = ref('jmsConnectionFactory')
			defaultDestination = ref('sendQueue')
			receiveTimeout = 30000
		}
		jmsConnectionFactory(org.springframework.jndi.JndiObjectFactoryBean) {
			jndiName = "ConnectionFactory"
			jndiTemplate = ref('jndiTemplate')
		}
		receiveQueue(org.springframework.jndi.JndiObjectFactoryBean) {
			jndiName = "queue/${CH.config.responseQueue}"
			jndiTemplate = ref('jndiTemplate')
		}
		sendQueue(org.springframework.jndi.JndiObjectFactoryBean) {
			jndiName = "queue/SharedAnalysisRequest"
			jndiTemplate = ref('jndiTemplate')
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
		// Initialize custom json converter
		println "register JSON object marshaller"
		JSON.registerObjectMarshaller(new ExpressionLookupResultMarshaller())
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
