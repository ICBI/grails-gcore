class Outcome {
	static mapping = {
		table 'COMMON.OUTCOME_DATA'
		version false
		id column:'ID', generator: 'native', params: [sequence: 'OUTCOME_DATA_SEQUENCE']
		subjectId column:'PATIENT_ID'
		studyDataSource column: 'data_source_id'
		outcomeType column:'OUTCOME_TYPE'
		outcomeDescription column:'OUTCOME_DESCRIPTION'
	}
	static fetchMode = [studyDataSource:"eager"]
	
	Long subjectId
	Study studyDataSource
	String outcomeType
	String outcomeDescription
	Long outcomeGroup
	
}
