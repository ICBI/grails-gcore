class AttributeValue {
	static mapping = {
		table '__STUDY_SCHEMA__.SUBJECT_ATTRIBUTE_VALUE'
		version false
		id column:'SUBJECT_ATTRIBUTE_VALUE_ID', generator: 'native', params: [sequence: '__STUDY_SCHEMA__.PATIENT_ATTRIB_VAL_SEQUENCE']
		subject column:'subject_id'
		type column:'attribute_type_id', insertable: false, updateable: false
		commonType column:'attribute_type_id'
	}

	String value
	Subject subject
	AttributeType type
	CommonAttributeType commonType
	Date insertDate
}
