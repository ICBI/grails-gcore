class DataAvailable {
	
	static mapping = {
		table 'DATA_AVAILABLE'
		version false
		id column:'ID'
		dataTypeCount column: 'COUNT'
	}

	String studyName
	String diseaseType
	String dataType
	Long dataTypeCount
}
