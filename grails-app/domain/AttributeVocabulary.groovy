class AttributeVocabulary {
	static mapping = {
		table 'COMMON.ATTRIBUTE_VOCABULARY'
		version false
		id column:'attribute_vocabulary_id', generator: 'native', params: [sequence: 'ATTRIBUTE_VOCAB_SEQUENCE']
		type column:'attribute_type_id', insertable: false, updateable: false
		commonType column:'attribute_type_id'

	}
	
	static constraints = {
		definition(nullable: true)
		insertUser(nullable: true)
		insertDate(nullable: true)
		insertMethod(nullable: true)
		evsId(nullable: true)
	}
	
	AttributeType type
	CommonAttributeType commonType
	String term
	String termMeaning
	String evsId
	String definition
	String insertUser
	Date insertDate
	String insertMethod
}
