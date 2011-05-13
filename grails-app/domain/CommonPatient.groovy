class CommonPatient {

	static mapping = {
		table 'COMMON.PATIENT_DATA_SOURCE'
		version false
		id column:'gdoc_id', generator: 'native', params: [sequence: 'PATIENT_SEQUENCE']
		studyDataSource column: 'data_source_id'
		patient column: 'patient_id'
	}
	
	
	Long id
	StudyPatient patient
	Study studyDataSource
	String insertUser
	String insertMethod
	Date insertDate
}
