// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }
grails.naming.entries = 0 
grails.json.legacy.builder = false
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text-plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
// The default codec used to encode data with ${}
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.converters.encoding="UTF-8"

// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true

// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'GDOCUser'
//grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'com.gdoc.demo.UserRole'
grails.plugins.springsecurity.authority.className = 'Role'
grails.plugins.springsecurity.successHandler.defaultTargetUrl = "/workflows"

grails.exceptionresolver.params.exclude = ['password']
//grails.plugins.springsecurity.providerNames=['ldapAuthProvider','myAuthenticationProvider','anonymousAuthenticationProvider']

grails.plugins.springsecurity.ldap.context.managerDn = 'uid=gdocdevUIDWebMapping,ou=Specials,dc=georgetown,dc=edu'
grails.plugins.springsecurity.ldap.context.managerPassword = 'gTQ8me5dGjjJ783guu'
grails.plugins.springsecurity.ldap.context.server = 'ldaps://directory.georgetown.edu:636'
grails.plugins.springsecurity.ldap.authorities.groupSearchBase = 'ou=People,dc=georgetown,dc=edu'
grails.plugins.springsecurity.ldap.search.base = 'dc=georgetown,dc=edu'

// Jquery configuration
jquery.sources="jquery" 
jquery.version="1.3.2"

// set per-environment serverURL stem for creating absolute links
environments {
    devserver {
        grails.serverURL = "https://dev.gdoc.georgetown.edu"
		jmsserver = "jnp://localhost:1099"
		responseQueue = "AnalysisResponse"
		genePatternUrl = "https://devcomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://dev.gdoc.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://dev.gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://dev.gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://dev.gdoc.georgetown.edu/content/documents"
		videosPath = "https://dev.gdoc.georgetown.edu/content/video"
    }
    demo {
        grails.serverURL = "https://demo.gdoc.georgetown.edu"
		jmsserver = "jnp://localhost:1099"
		responseQueue = "AnalysisResponse"
		genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://demo.gdoc.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://demo.gdoc.georgetown.edu/content/documents"
		videosPath = "https://demo.gdoc.georgetown.edu/content/video"
		grails {
		   mail {
		     host = "nitrogen.uis.georgetown.edu"
		     port = 25
		   }
		}
    }
	development {
		grails.serverURL = "http://localhost:8080"
	//	jmsserver = "jnp://141.161.30.205:1099"
		jmsserver = "jnp://localhost:1099"
 		responseQueue = "AnalysisResponseKevin"
		genePatternUrl = "https://devcomp.gdoc.georgetown.edu"
		tempDir = "/local/content/gdoc"
		middlewareUrl = "http://localhost:9090/gdoc-middleware"
		molecule3DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://demo.gdoc.georgetown.edu/content/documents"
		videosPath = "https://demo.gdoc.georgetown.edu/content/video"
	}
	sandbox {
		jmsserver = "jnp://localhost:1099"
 		responseQueue = "AnalysisResponseKevin"
		genePatternUrl = "https://devcomp.gdoc.georgetown.edu"
		tempDir = "/local/content/gdoc"
		middlewareUrl = "http://localhost:9090/gdoc-middleware"
		molecule3DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://demo.gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://demo.gdoc.georgetown.edu/content/documents"
		videosPath = "https://demo.gdoc.georgetown.edu/content/video"
	}
	stage {
        grails.serverURL = "https://gdoc-stage.georgetown.edu"
		jmsserver = "jnp://gdoc-stage.georgetown.edu:1099"
		responseQueue = "AnalysisResponse"
		//genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://gdoc-stage.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://gdoc-stage.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://gdoc-stage.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://gdoc-stage.georgetown.edu/content/documents"
		videosPath = "https://gdoc-stage.georgetown.edu/content/video"
		grails {
		   mail {
		     host = "nitrogen.uis.georgetown.edu"
		     port = 25
		   }
		}
    }
	stage_load {
        grails.serverURL = "https://gdoc-stage.georgetown.edu"
		jmsserver = "jnp://gdoc-stage.georgetown.edu:1099"
		responseQueue = "AnalysisResponse"
		//genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://gdoc-stage.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://gdoc-stage.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://gdoc-stage.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://gdoc-stage.georgetown.edu/content/documents"
		videosPath = "https://gdoc-stage.georgetown.edu/content/video"
    }
	production {
        grails.serverURL = "https://gdoc.georgetown.edu"
		jmsserver = "jnp://gdoc.georgetown.edu:1099"
		responseQueue = "AnalysisResponse"
		//genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://gdoc.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://gdoc.georgetown.edu/content/documents"
		videosPath = "https://gdoc.georgetown.edu/content/video"
		grails {
		   mail {
		     host = "neon.uis.georgetown.edu"
		     port = 25
		   }
		}
    }
	prod_load {
        grails.serverURL = "https://gdoc.georgetown.edu"
		jmsserver = "jnp://gdoc.georgetown.edu:1099"
		responseQueue = "AnalysisResponse"
		//genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/opt/gdoc-temp"
		middlewareUrl = "https://neon.uis.georgetown.edu/gdoc-middleware"
		molecule3DstructuresPath = "https://gdoc.georgetown.edu/content/targets/molecule3D"
		molecule2DstructuresPath = "https://gdoc.georgetown.edu/content/targets/molecule2D"
		documentsPath = "https://gdoc.georgetown.edu/content/documents"
		videosPath = "https://gdoc.georgetown.edu/content/video"
    }
	test {
		jmsserver = "jnp://localhost:1099"
 		responseQueue = "AnalysisResponseKevin"
		genePatternUrl = "https://democomp.gdoc.georgetown.edu"
		tempDir = "/local/content/gdoc"
		middlewareUrl = "http://localhost:9090/gdoc-middleware"
		structuresPath = "/opt/gdoc-data/"
	}
}




