class Annotation {
	static mapping = {
		table 'ANNOTATION'
		version false
		id column:'annotation_id'
		name column: 'annotation_name'
		type column: 'annotation_type'
	}
	static hasMany = [data: AnnotationData]
	
	String name
	AnnotationType type
}