class Evidence {
	static mapping = {
		table 'COMMON.FINDING_EVIDENCE'
		version false
		id column:'EVIDENCE_ID'
	}

	static searchable = {
     supportUnmarshall false
		alias "evidence"
	    finding component: true
		userList component: true
		relatedFinding component: true
	}


	Finding finding
	UserList userList
	SavedAnalysis savedAnalysis
	Finding relatedFinding
	String url

	String description
	Date dateCreated
	Date lastUpdated


}
