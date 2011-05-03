import org.codehaus.groovy.grails.commons.GrailsApplication 
import org.springframework.beans.factory.InitializingBean
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware

class ExtensionService implements InitializingBean, ApplicationContextAware {
	def grailsApplication
	def extensionMap
	def dataExtensionMap
	def analysisTypeMap
	def workflowExtensionMap
	def pluginManager
	ApplicationContext applicationContext
	
	void afterPropertiesSet() {
		extensionMap = [:]
		dataExtensionMap = [:]
		analysisTypeMap = [:]
		workflowExtensionMap = [:]
		// Find all extension annotations on the controllers
		grailsApplication.controllerClasses.each{ controller ->
			if(controller.clazz.getAnnotation(Extension.class)) {
				def annotation = controller.clazz.getAnnotation(Extension.class)
				extensionMap[controller.logicalPropertyName] = annotation
				
				// Load up analysis services, looking at requestType on the command and matching it with a service of the same name
				if((annotation.type() == ExtensionType.ANALYSIS) || (annotation.type() == ExtensionType.SEARCH && annotation.menu() == "Gene Expression")) {
					def commandClass = Thread.currentThread().contextClassLoader.loadClass(controller.name + 'Command')
					analysisTypeMap[commandClass.requestType] = controller.logicalPropertyName
				} 
				
				// Look at all methods and look for WorkflowExtensions
				controller.clazz.declaredFields.each { field ->
					def workflowAnnotation = field.getAnnotation(WorkflowExtension.class)
					if(workflowAnnotation) {
						if(!workflowExtensionMap[workflowAnnotation.type()])
							workflowExtensionMap[workflowAnnotation.type()] = []
						workflowExtensionMap[workflowAnnotation.type()] << [label: workflowAnnotation.label(), controller: controller.logicalPropertyName, action: field.name]
					}
				}
			}
		}
		// Find all extension annotations on the services
		grailsApplication.serviceClasses.each{ service ->
			if(service.clazz.getAnnotation(DataExtension.class)) {
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
	
	def getCytoscapeLinks() {
		return buildLinks(ExtensionType.CYTOSCAPE)
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
	
	def getWorkflowsForType(workflowType) {
		if(!workflowExtensionMap[workflowType])
			return []
		return workflowExtensionMap[workflowType]
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
	
	def addListItemMetadata(list){
		def metaData = [:]
		extensionMap.each { key, value ->
			if(value.hasListMetadata()) {
				grailsApplication.serviceClasses.each{ service ->
					if(service.logicalPropertyName == key){
						log.debug "adding metatdata from $key"
						def listMetadataService = applicationContext.getBean(service.logicalPropertyName + 'Service')
						def label = listMetadataService.getListMetadataLabel()
						metaData[label] = listMetadataService.addListMetadata(list)
					}
				}
			}
		}
		return metaData
	}
}