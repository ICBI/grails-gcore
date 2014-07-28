import org.hibernate.FetchMode as FM

class StudyDataSourceService {

    boolean transactional = true
	def htDataService;
    def jdbcTemplate

    def create(data) {
		def dataSource = new Study(data)
		if (!dataSource.save(flush: true)) 
			log.error dataSource.errors
		return dataSource
    }

	def createWithContent(studyData, contentData) {
		def dataSource = create(studyData)
		contentData.each {
			def content = new DataSourceContent(it)
			dataSource.addToContent(content)
			if(!content.save(flush: true)) 
				log.error content.errors
			
		}
		return dataSource
	}
	
	def addPi(dataSourceId, contactData) {
		def criteria = Study.createCriteria()
		def dataSource = criteria.list{
			eq("id", dataSourceId)
		    fetchMode('patients', FM.EAGER)
		}.get(0)
		def contact = addContact('PI', contactData)
		dataSource.addToPis(contact)
		dataSource.merge()
		return contact
	}
	
	def addPoc(dataSourceId, contactData) {
		def criteria = Study.createCriteria()
		def dataSource = criteria.list{
			eq("id", dataSourceId)
		    fetchMode('patients', FM.EAGER)
		}.get(0)
		def contact = addContact('POINT_OF_CONTACT', contactData)
		dataSource.addToPocs(contact)
		dataSource.merge()
		return contact
	}
	
	private def addContact(contactType, contactData) {
		def contact = Contact.findByLastNameAndFirstName(contactData.lastName, contactData.firstName)
		if(!contact) {
			contact = new Contact(contactData)
			if(!contact.save(flush:true)) 
				log.error contact.errors
		}
		return contact
	}
	
	def getTranslationalResearchOperations() {
		[Operation.PCA, Operation.KM, Operation.HEAT_MAP, Operation.KM_GENE_EXP, Operation.GENE_EXPRESSION, Operation.CLINICAL, Operation.GROUP_COMPARISON, Operation.CIN]
	}
	
	def getPersonalizedMedicineOperations() {
		[Operation.VARIANT_SEARCH, Operation.DICOM]
	}
	
	def getPopulationGeneticsOperations() {
		[Operation.PHENOTYPE_SEARCH]
	}
	
	def filterByTranslationalResearch(List<Study> studies) {
			
		def filtered = []
		def operations_by_study = []
		def valid_operations = getTranslationalResearchOperations()
		
		studies.each { study ->
			if (study.subjectType != "N/A") { 
				def intersection_of_operations = valid_operations.intersect(findOperationsSupportedByStudy(study))
			
				if (intersection_of_operations.size() > 0 && study.isTranslationalResearch) {
					filtered << study
					operations_by_study << intersection_of_operations
				}
			}
		}
		return [filtered,operations_by_study]
		
		
	}
	
	def filterByPersonalizedMedicine(List<Study> studies) {
		
		def filtered = []
		def operations_by_study = []
		def valid_operations = getPersonalizedMedicineOperations()
		
		for (study in studies) {
		
			def intersection_of_operations = valid_operations.intersect(findOperationsSupportedByStudy(study))
		
			if (intersection_of_operations.size() > 0 && study.isPrecisionMedicine) {
				filtered << study
				operations_by_study << intersection_of_operations
			}
		}
		
		return [filtered, operations_by_study]
	}
	
	def filterByPopulationGenetics(List<Study> studies) {
		
		def filtered = []
		def operations_by_study = []
		def valid_operations = getPopulationGeneticsOperations()
		
		for (study in studies) {
			
			def intersection_of_operations = valid_operations.intersect(findOperationsSupportedByStudy(study))
			
			if (intersection_of_operations.size() > 0 && study.isPopulationGenetics) {
				filtered << study
				operations_by_study << intersection_of_operations
			}
		}
		
		return [filtered, operations_by_study]
	}
	
	
	def findStudiesWhichSupportOperation(List<Study> studies, String operation) {
		def filtered = []
		studies.each {
			if(doesStudySupportOperation(operation, it)) filtered << it
		}
		//log.debug(filtered.groupBy {it.disease})
		return filtered.groupBy {it.disease}
	}

    def getSubjectCount(Study study) {
        def subjectCount= 0
        def query = "select count(*) as count from " + study.schemaName + ".SUBJECT"
         log.debug "The select statement is : " +query+""
         subjectCount = jdbcTemplate.queryForInt(query);
         log.debug "The count : " +subjectCount
         return subjectCount
    }

    def getBiospecimenCount(Study study) {
        def BiospecimenCount= 0
        def query = "select count(*) as count from " + study.schemaName + ".BIOSPECIMEN"
        log.debug "The select statement is : " +query
        BiospecimenCount = jdbcTemplate.queryForInt(query);
        log.debug "The count : " +BiospecimenCount
        return BiospecimenCount
    }


	def findOperationsSupportedByStudy(Study study) {
		
		def operations = []
		StudyContext.setStudy(study.schemaName)
		def endpoints = KmAttribute.findAll()
		def files = htDataService.getHTDataMap()
		def dataSetType = files.keySet()
		
		operations << Operation.GENOME_BROWSER
        operations << Operation.TARGET
        operations << Operation.FINDING

        if(files && study.hasDynamicData()) operations << Operation.GROUP_COMPARISON
        if(study.hasClinicalData()) operations << Operation.CLINICAL
        if(study.hasImagingData()) operations << Operation.DICOM
        if(study.hasWgsData()) 	operations << Operation.VARIANT_SEARCH
        if(study.hasWgsForPopGenData()) operations << Operation.PHENOTYPE_SEARCH
        if(study.hasCopyNumberData()) operations << Operation.CIN

        if(endpoints != null && (endpoints.size() > 0)) operations << Operation.KM
        if(endpoints && study.hasGenomicData() && dataSetType.contains('GENE EXPRESSION')) operations << Operation.KM_GENE_EXP
        if(study.hasGenomicData() && dataSetType.contains('GENE EXPRESSION')) operations << Operation.GENE_EXPRESSION

		if(files && (dataSetType.size() > 0))
        {
            if(dataSetType.size() != 1 || (!study.hasWgsData() && !study.hasWgsForPopGenData())) operations << Operation.PCA
        }

		if((study.hasGenomicData() && dataSetType.contains('GENE EXPRESSION')) || (study.hasMicroRNAData() && dataSetType.contains('microRNA')) || (study.hasCopyNumberData() && dataSetType.contains('COPY_NUMBER')) || (study.hasMetabolomicsData() && dataSetType.contains('METABOLOMICS'))) operations << Operation.HEAT_MAP

		return operations
	}

	boolean doesStudySupportOperation(String intendedOperation, Study study) {
		intendedOperation = intendedOperation.toLowerCase();
		boolean result = true
		//log.debug("operation is: "+intendedOperation)
		StudyContext.setStudy(study.schemaName)
		def endpoints = KmAttribute.findAll()
		def files = htDataService.getHTDataMap()
		def dataSetType = files.keySet()
		
		if(intendedOperation == "km")
			result = (endpoints != null && (endpoints.size() > 0))
		
		else if(intendedOperation == "kmgeneexp")
			result = (endpoints && study.hasGenomicData() && dataSetType.contains('GENE EXPRESSION'))
		
		else if(intendedOperation == "cin")
			result = study.hasCopyNumberData()
			
		else if(intendedOperation == "variantsearch")
			result = study.hasWgsData()
			
		else if(intendedOperation == "phenotypesearch")
			result = study.hasWgsForPopGenData()
		
		else if(intendedOperation == "dicom")
			result = study.hasImagingData()
			
		else if(intendedOperation == "geneexpression")
			result = study.hasGenomicData() && dataSetType.contains('GENE EXPRESSION')
			
		else if(intendedOperation == "clinical")
			result = study.hasClinicalData()
			
		else if(intendedOperation == "groupcomparison")
			result = files && study.hasDynamicData()
			
		else {
			//log.debug("Clearing study context")
			StudyContext.clear();
		}
			
		//log.debug("doesStudySupportOperation: "+result)
			
		return result
	}

}
