class Biospecimen {

	static mapping = {
		table '__STUDY_SCHEMA__.BIOSPECIMEN'
		version false
		id column:'biospecimen_id', generator: 'native', params: [sequence: '__STUDY_SCHEMA__.BIOSPECIMEN_SEQUENCE']
		subject column: 'subject_id'
		values column:'biospecimen_id'
		insertDate column: 'INSERT_DATE'
	}
	static transients = ['biospecimenData']
	
	static hasMany = [reductionAnalyses: ReductionAnalysis]
	
	String name
	Date insertDate
	Subject subject
}
