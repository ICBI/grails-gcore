class DataSourceContent {
	
	static mapping = {
		table 'COMMON.DATA_SOURCE_CONTENT'
		version false
		id column:'DATA_SOURCE_CONTENT_ID', generator: 'native', params: [sequence: 'DSC_SEQUENCE']
		type column: 'CONTENT_TYPE'
		showInGui column: 'SHOW_IN_GUI'
		studyDataSource column: 'data_source_id'
	}

    static constraints = {
    }

	Study studyDataSource
	String type
	Integer showInGui
}
