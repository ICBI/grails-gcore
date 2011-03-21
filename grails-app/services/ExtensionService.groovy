import org.codehaus.groovy.grails.commons.GrailsApplication 
import org.springframework.beans.factory.InitializingBean
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware

class ExtensionService implements InitializingBean, ApplicationContextAware {
	def grailsApplication
	def extensionMap
	def dataExtensionMap
	def analysisTypeMap
	ApplicationContext applicationContext
	
	void afterPropertiesSet() {
		extensionMap = [:]
		dataExtensionMap = [:]
		analysisTypeMap = [:]
		// Find all extension annotations on the controllers
		grailsApplication.controllerClasses.each{ controller ->
			if(controller.clazz.getAnnotation(Extension.class)) {
				def annotation = controller.clazz.getAnnotation(Extension.class)
				extensionMap[controller.logicalPropertyName] = annotation
				
				// Load up analysis services, looking at requestType on the command and matching it with a service of the same name
				if(annotation.type() == ExtensionType.ANALYSIS) {
					def commandClass = Thread.currentThread().contextClassLoader.loadClass(controller.name + 'Command')
					analysisTypeMap[commandClass.requestType] = controller.logicalPropertyName
				}
			}
		}
		println "In extension service"
		// Find all extension annotations on the services
		grailsApplication.serviceClasses.each{ service ->
			println "Scanning ${service} for annotations"
			if(service.clazz.getAnnotation(DataExtension.class)) {
				println "found DataExtension for ${service}"
				def annotation = service.clazz.getAnnotation(DataExtension.class)
				dataExtensionMap[annotation.label()] = applicationContext.getBean(service.logicalPropertyName + 'Service')
			}
		}
	}
	
	def getAnalysisLinks() {
		return buildLinks(ExtensionType.ANALYSIS)
	}
	
	def getSearchLinks() {
		return buildLinks(ExtensionType.SEARCH)
	}
	
	def getDataExtensionLabels() {
		return dataExtensionMap.collect {key, value -> return key}
	}
	
	def createLinkForLabel(label, item) {
		return dataExtensionMap[label].createLink(item)
	}
	
	def buildRequest(userId, cmd) {
		def name = analysisTypeMap[cmd.requestType]
		def analysisService = applicationContext.getBean(name + 'Service')
		return analysisService.handle(userId, cmd)
	}
	
	def getAnalysisView(analysisType) {
		return analysisTypeMap[analysisType]
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