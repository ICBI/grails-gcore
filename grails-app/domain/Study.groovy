class Study {

	static mapping = {
		table 'COMMON.DATA_SOURCE'
		version false
		id column:'data_source_id', generator: 'native', params: [sequence: 'DATA_SOURCE_SEQUENCE']
		abstractText column: 'abstract'
		// isPrecisionMedicine column: 'is_precision_medicine', type: 'yes_no', defaultValue: false
		//isTranslationalResearch column: 'is_translational_research', type: 'yes_no',  defaultValue: false
		//isPopulationGenetics column: 'is_population_genetics', type: 'yes_no',  defaultValue: false
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
	static transients = [ "genomicData","subjectType","dynamicData"]
	
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
	Boolean dynamicData
	Boolean isPrecisionMedicine
	Boolean isTranslationalResearch
	Boolean isPopulationGenetics
	
	def hasDynamicData() {
		dynamicData = content.find {
			if(it.type == "MICROARRAY" || it.type == "COPY_NUMBER" || it.type == "METABOLOMICS" || it.type == "MICRORNA")
			 return true
			else
			 return false
		}
		return dynamicData
	}
	
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
	
	def hasWgsData() {
		return content.find {
			it.type == "WGS"
		}
	}

    def hasWgsForPopGenData() {
        return content.find {
            it.type == "WGS for POPGEN"
        }
    }

    def hasImagingData() {
        return content.find {
            it.type == "IMAGING"
        }
    }
	
	public String getSubjectType(){
		if(this.@shortName){
			def subjectType = "N/A"
			def da = DataAvailable.findAllByStudyName(this.@shortName)
			da.each{ 
				if(it.dataType == SubjectType.PATIENT.value() && it.dataTypeCount >0){
					subjectType = SubjectType.PATIENT.value()
				}
				else if((it.dataType == SubjectType.CELL_LINE.value() && it.dataTypeCount >0) || (it.dataType == SubjectType.REPLICATE.value() && it.dataTypeCount >0)){
					subjectType = SubjectType.CELL_LINE.value()
				}
				else if(it.dataType == SubjectType.ANIMAL_MODEL.value() && it.dataTypeCount >0){
					subjectType = SubjectType.ANIMAL_MODEL.value()
				}
			}
			return subjectType
		}
		
	}
}
