class AnnotationData {
	static mapping = {
		table 'ANNOTATION_DATA'
		version false
		id column:'annotation_data_id'
		type column: 'annotation_data_type'
		value column: 'annotation_data_value'
	}
	
	static belongsTo = [annotation: Annotation]
	String type
	String value
}