class IdMapping {
	static mapping = {
		table 'COMMON.ID_MAPPING'
		version false
		id column:'gdoc_id', generator: 'native', params: [sequence: 'PATIENT_SEQUENCE']
		studyDataSource column: 'data_source_id'
		subject column: 'gdoc_id'
	}
	
	static constraints = {
		subject nullable: true
	}
	
	static hasOne = [subject:Subject]
	
	Long id
	Study studyDataSource
}