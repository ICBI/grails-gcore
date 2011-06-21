class Study {

	static mapping = {
		table 'COMMON.DATA_SOURCE'
		version false
		id column:'data_source_id', generator: 'native', params: [sequence: 'DATA_SOURCE_SEQUENCE']
		abstractText column: 'abstract'
		pis joinTable: [name:'data_source_pis', key:'data_source_id', column:'contact_id']
		pocs joinTable: [name:'data_source_pocs', key:'data_source_id', column:'contact_id']
	}
	
	static searchable = {
			mapping {
					alias "studies"
			        abstractText index: 'not analyzed'
					abstractText index: 'analyzed'
					schemaName index: 'no'
					pis component: true
					pocs component: true
			        spellCheck "include"
			}
	}

	
	static hasMany = [pis: Contact, pocs: Contact, content: DataSourceContent, patients: CommonPatient]
	static fetchMode = [content:"eager", pis: "eager", pocs: "eager"]
	static transients = [ "genomicData","subjectType"]
	
	String shortName
	String longName
	String abstractText
	String disease
	String subjectType
	String schemaName
	String patientIdName
	String integrated
	String overallAccess
	String useInGui
	String insertUser
	Date insertDate
	String insertMethod
	Boolean genomicData
	
	def hasGenomicData() {
		return content.find {
			it.type == "MICROARRAY"
		}
	}
	
	def hasClinicalData() {
		return content.find {
			it.type == "CLINIC"
		}
	}
	
	def hasCopyNumberData() {
		return content.find {
			it.type == "COPY_NUMBER"
		}
	}
	
	def hasMetabolomicsData() {
		return content.find {
			it.type == "METABOLOMICS"
		}
	}
	
	def hasMicroRNAData() {
		return content.find {
			it.type == "MICRORNA"
		}
	}
	
	public String getSubjectType(){
		if(this.@shortName){
			def subjectType = "N/A"
			def da = DataAvailable.findAllByStudyName(this.@shortName)
			da.each{ 
				if(it.dataType == SubjectType.PATIENT.value() && it.count >0){
					subjectType = SubjectType.PATIENT.value()
				}
				else if((it.dataType == SubjectType.CELL_LINE.value() && it.count >0) || (it.dataType == SubjectType.REPLICATE.value() && it.count >0)){
					subjectType = SubjectType.CELL_LINE.value()
				}
				else if(it.dataType == SubjectType.ANIMAL_MODEL.value() && it.count >0){
					subjectType = SubjectType.ANIMAL_MODEL.value()
				}
			}
			return subjectType
		}
		
	}
}
