import org.codehaus.groovy.grails.commons.GrailsApplication 

class AnalysisAnnotationTests extends GroovyTestCase {
	def extensionService
    void testRuntime() {
		println extensionService.getAnalysisLinks()
    }
}
