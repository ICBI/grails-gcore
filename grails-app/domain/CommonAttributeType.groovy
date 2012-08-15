class CommonAttributeType {

	static mapping = {
		table 'COMMON.ATTRIBUTE_TYPE'
		version false
		id column:'attribute_type_id', generator: 'native', params: [sequence: 'ATTRIBUTE_TYPE_SEQUENCE']
		vocabs column: 'attribute_type_id'
		value column: 'class'
		splitAttribute column: 'split_attribute'
	}
	static constraints = {
        upperRange(nullable: true)
        lowerRange(nullable: true)
		value(nullable: true)
		semanticGroup(nullable: true)
		gdocPreferred(nullable: true)
		qualitative(nullable: true)
		continuous(nullable: true)
		vocabulary(nullable: true)
		oracleDatatype(nullable: true)
		cadsrId(nullable: true)
		evsId(nullable: true)
		unit(nullable: true)
		splitAttribute(nullable: true)
		
    }
    
	static hasMany = [vocabs : AttributeVocabulary]
	
	String shortName
	String longName
	String definition
	String value
	String semanticGroup
	String gdocPreferred
	String cadsrId
	String evsId
	Boolean qualitative
	Boolean continuous
	Boolean vocabulary
	String oracleDatatype
	String unit
	Double upperRange
	Double lowerRange
	String insertUser
	Date insertDate
	String insertMethod
	Boolean splitAttribute
}
