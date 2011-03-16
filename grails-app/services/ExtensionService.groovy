import org.codehaus.groovy.grails.commons.GrailsApplication 
import org.springframework.beans.factory.InitializingBean
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware

class ExtensionService implements InitializingBean, ApplicationContextAware {
	def grailsApplication
	def extensionMap
	def analysisServices
	ApplicationContext applicationContext
	
	void afterPropertiesSet() {
		extensionMap = [:]
		analysisServices = [:]
		// Find all extension annotations on the controllers
		grailsApplication.controllerClasses.each{ controller ->
			if(controller.clazz.getAnnotation(Extension.class)) {
				def annotation = controller.clazz.getAnnotation(Extension.class)
				extensionMap[controller.logicalPropertyName] = annotation
				
				// Load up analysis services, looking at requestType on the command and matching it with a service of the same name
				if(annotation.type() == ExtensionType.ANALYSIS) {
					def commandClass = Thread.currentThread().contextClassLoader.loadClass(controller.name + 'Command')
					def analysisService = applicationContext.getBean(controller.logicalPropertyName + 'Service')
					analysisServices[commandClass.requestType] = analysisService
				}
			}
		}
	}
	
	def getAnalysisLinks() {
		return buildLinks(ExtensionType.ANALYSIS)
	}
	
	def getSearchLinks() {
		return buildLinks(ExtensionType.SEARCH)
	}
	
	def buildRequest(userId, cmd) {
		return analysisServices[cmd.requestType].handle(userId, cmd)
	}
	
	private def buildLinks(type) {
		def links = [:]
		extensionMap.each { key, value ->
			if(value.type() == type) {
				links[key] = value.menu()
			}
		}
		return links
	}
}