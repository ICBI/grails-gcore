import org.codehaus.groovy.grails.commons.GrailsApplication 
import org.springframework.beans.factory.InitializingBean

class ExtensionService implements InitializingBean {
	def grailsApplication
	def extensionMap
	
	void afterPropertiesSet() {
		extensionMap = [:]
		// Find all extension annotations on the controllers
		grailsApplication.controllerClasses.each{ 
			if(it.clazz.getAnnotation(Extension.class)) {
				extensionMap[it] = it.clazz.getAnnotation(Extension.class)
			}
		}
	}
	
	def getAnalysisLinks() {
		def links = [:]
		extensionMap.each { key, value ->
			if(value.type() == ExtensionType.ANALYSIS) {
				links[key.logicalPropertyName] = value.menu()
			}
		}
		return links
	}
}