class Subject {

	static mapping = {
		table '__STUDY_SCHEMA__.SUBJECT'
		version false
		id column:'subject_id', generator: 'foreign', params: [property: 'idMapping']
		values column:'subject_id'
		biospecimens column: 'subject_id'
		idMapping column: 'subject_id', insertable: false, updateable: false
	}
	
	static constraints = {
		timepoint nullable: true
	}
	static hasMany = [values : AttributeValue, children: Subject, biospecimens: Biospecimen]
	static belongsTo = [parent: Subject]
	static fetchMode = [values:"eager"]
	static transients = ['clinicalData', 'clinicalDataValues', 'gdocId']
	
	String dataSourceInternalId
	String timepoint
	SubjectType type
	IdMapping idMapping
	Long gdocId
	Date insertDate
	Map clinicalData
	Map clinicalDataValues
	
	public Map getClinicalData() {
		if(!this.@clinicalData) {
			this.@clinicalData = [:]
			values.each { value ->
				if(value.type.vocabulary) {
					def vocab = value.type.vocabs.find { 
						it.term == value.value
					}
					if(vocab) {
						this.@clinicalData[value.type.shortName] = vocab.termMeaning
					}
				} else {
					this.@clinicalData[value.type.shortName] = value.value
				}
			}
		}
		return this.@clinicalData
	}
	
	public Map getClinicalDataValues() {
		if(!this.@clinicalDataValues) {
			this.@clinicalDataValues = [:]
			values.each { value ->
				this.@clinicalDataValues[value.type.shortName] = value.value
			}
		}
		return this.@clinicalDataValues
	}
	
	public Long getGdocId() {
		return this.@id
	}
}
