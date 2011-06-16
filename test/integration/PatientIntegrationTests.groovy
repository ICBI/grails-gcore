class PatientIntegrationTests extends GroovyTestCase {


	void setUp() {
	}
	
	void testFindAll() { 
		
		StudyContext.setStudy("BRC_CLARKE_LIU_9999_01")
		
		def patients = Patient.findAll([max:10])
		assert patients.size() > 0
		println patients[0]
		println patients[0].values.size()
		patients[0].values.each() {
			assertNotNull it.value
		}
	} 
	

	
}