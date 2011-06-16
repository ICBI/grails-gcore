class SubjectTests extends GroovyTestCase {
	
	void setUp() {
	}
	
	def testFindSubjects() {
		StudyContext.setStudy("BRC_CLARKE_LIU_9999_01")
		def subjects = Subject.findAll([max:10])
		subjects.each {
			println it.clinicalData
			println it.children
			println it.biospecimens
		}
	}
}