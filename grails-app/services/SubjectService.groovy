class SubjectService {
	
	def createSubjectsForStudy(studyName, subjects) {
		def studyDataSource = Study.findByShortName(studyName)
		if(!studyDataSource)
			return
		StudyContext.setStudy(studyDataSource.schemaName)
		subjects.each {
			def subjectId = new IdMapping()
			subjectId.studyDataSource = studyDataSource
			if(!subjectId.save(flush: true)) 
				log.debug subjectId.errors
				
			def subject = new Subject(it)
			subject.type = SubjectType.fromValue(it.type)
			subject.idMapping = subjectId
			if(it.parentId) {
				def parent = Subject.findByDataSourceInternalId(it.parentId)
				if(!parent)
					throw new Exception ("Parent ID: ${it.parentId} not found")
				subject.parent = parent
			}
			if(!subject.save(flush: true)) 
				log.debug subject.errors
		}
	}
	
	def addValuesToSubject(projectName, originalDataSourceId, values, auditInfo) {
		def studyDataSource = Study.findByShortName(projectName)
		if(!studyDataSource)
			return
		StudyContext.setStudy(studyDataSource.schemaName)
		def subject = Subject.findByDataSourceInternalId(originalDataSourceId)
		if(!subject)
			return
		values.each { name, value ->
			if(value){
				println "Attempting to load $name $value"
				def type = CommonAttributeType.findByShortName(name)
				if(!type)
					throw new Exception("Attribute Type ${name} not found.  Unable to load data.")
				def attValue = new AttributeValue()
				attValue.commonType = type
				attValue.value = value
				attValue.insertDate = auditInfo.insertDate
				attValue.subject = subject
				subject.addToValues(attValue)
				if(!attValue.save(flush:true))
					log.debug attValue.errors
			}else{
				log.debug "no value found for attribute ${name}"
			}
		}
		subject.merge()
	}
}