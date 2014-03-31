class Finding {
	static mapping = {
		table 'COMMON.FINDING'
		version false
		id column:'FINDING_ID'
	}

    static searchable = true

	String title
	String description
	GDOCUser author
	Evidence principalEvidence
	Date dateCreated
	Date lastUpdated
	
	static hasMany = [supportingEvidence: Evidence]
	static fetchMode = [supportingEvidence:'eager']
	
}
