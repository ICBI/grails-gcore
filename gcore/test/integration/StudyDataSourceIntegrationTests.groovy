class StudyDataSourceIntegrationTests extends GroovyTestCase {


	void setUp() {
	}
	
	void testFindAll() { 
		def sources = Study.findAll([max:10])
		assert sources.size >= 1
	} 
	void testPi() {
		def sources = Study.findAll([max:10])
		sources.pis
	}
	
	void testPocs() {
		def sources = Study.findAll([max:10])
		sources.pocs
	}
}