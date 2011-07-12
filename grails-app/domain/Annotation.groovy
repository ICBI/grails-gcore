class Annotation {
	static mapping = {
		table 'ANNOTATION'
		version false
		id column:'annotation_id'
		name column: 'annotation_name'
		type column: 'annotation_type'
	}
	static hasMany = [data: AnnotationData]
	static fetchMode = [data:'eager']
	
	String name
	AnnotationType type
	
	public Map organizedData() {
		def temp = [:]
		data.each {
			if(temp[it.type]) {
				def values = []
				values.addAll(temp[it.type])
				values.addAll(it.value)
				temp[it.type] = values
			} else {
				temp[it.type] = it.value
			}
		}
		return temp
	}
}