class PatientService {
	static PAGE_SIZE = 1000
    boolean transactional = true

    def patientsForGdocIds(gdocIds) {
		log.debug "GDOC: $gdocIds"
		def allPatients
		gdocIds = gdocIds.collect {
			it.toLong()
		}
		def patients = []
		def index = 0;
		while(index < gdocIds.size()) {
			def c = Subject.createCriteria()
			def patientsLeft = gdocIds.size() - index
			def tempPatients
			if(patientsLeft > PAGE_SIZE) {
				def tempIds = (gdocIds.getAt(index..<(index + PAGE_SIZE)))
				tempPatients = c.listDistinct {
					'in'("id", tempIds)
				}
				patients.addAll(tempPatients)
				index += PAGE_SIZE
			} else {
				def tempIds = (gdocIds.getAt(index..<gdocIds.size()))
				tempPatients = c.listDistinct {
					'in'("id", tempIds)
				}
				patients.addAll(tempPatients)
				index += patientsLeft
			}
		}
		return patients
		
    }

	def patientsForSampleIds(sampleIds) {
		def queryClosure = { tempIds -> 
			def c = Subject.createCriteria()
			return c.listDistinct {
				biospecimens {
					'in'("name", tempIds)
				}
			}
		}
		return QueryUtils.paginateResults(sampleIds, queryClosure)
	}
	
	def createPatientsForStudy(studyName, patients, values) {
		def studyDataSource = Study.findByShortName(studyName)
		if(!studyDataSource)
			return
		StudyContext.setStudy(studyDataSource.schemaName)
		patients.each {
			def patient = new CommonPatient(it)
			def studyPatient = new StudyPatient(it)
			patient.studyDataSource = studyDataSource
			if(!studyPatient.save(flush: true)) 
				log.debug studyPatient.errors
			patient.patient = studyPatient
			if(!patient.save(flush: true)) 
				log.debug patient.errors
		}
	}
	
	def addClinicalValuesToPatient(projectName, originalDataSourceId, values, auditInfo) {
		def studyDataSource = Study.findByShortName(projectName)
		if(!studyDataSource)
			return
		StudyContext.setStudy(studyDataSource.schemaName)
		def patient = StudyPatient.findByDataSourceInternalId(originalDataSourceId)
		if(!patient)
			return
		values.each { name, value ->
			if(value){
				def type = CommonAttributeType.findByShortName(name)
				if(!type)
					throw new Exception("Attribute Type ${name} not found.  Unable to load data.")
				def attValue = new AttributeValue()
				attValue.commonType = type
				attValue.value = value
				attValue.insertUser = auditInfo.insertUser
				attValue.insertMethod = auditInfo.insertMethod
				attValue.insertDate = auditInfo.insertDate
				attValue.studyPatient = patient
				patient.addToValues(attValue)
				if(!attValue.save(flush:true))
					log.debug attValue.errors
			}else{
				log.debug "no value found for attribute ${name}"
			}
		}
		patient.merge()
	}
	
}
