import org.springframework.jdbc.core.JdbcTemplate 
import groovy.text.SimpleTemplateEngine

class ClinicalService {
	static PAGE_SIZE = 1000
	def sessionFactory
	def jdbcTemplate 
	def middlewareService
	def queryString = '(select distinct p.subject_id from ${schema}.subject p, common.attribute_type c, ${schema}.subject_attribute_value v ' +
		 			  'where p.type = \'${type}\' and p.subject_id = v.subject_id and v.attribute_type_id = c.attribute_type_id ' +
					  ' and v.value = \'${value}\' and c.short_name = \'${key}\')'
	def rangeQueryString = '(select /*+ index(v,SUBJECT_ATTRIBUTE_VALUE_INDEX1) */ distinct p.subject_id from ${schema}.subject p, common.attribute_type c, ${schema}.subject_attribute_value v ' +
		 			  	   'where p.subject_id = v.subject_id and v.attribute_type_id = c.attribute_type_id ' +
					  	   ' and c.short_name = \'${key}\' and v.value BETWEEN ${value.min} and ${value.max} )'					
	
	def patientIdQuery = 'select s.parent_id from ${schema}.subject s where s.subject_id in (${ids})'
    boolean transactional = true
	
	def queryByCriteria(criteria, subjectType, childIds) {
		log.debug "querying by criteria"
		def patientIds = getSubjectIdsForCriteria(criteria, subjectType, childIds)
		return getPatientsForIds(patientIds)
	}
	
	def getSubjectIdsForCriteria(criteria, subjectType, biospecimenIds){
		def engine = new SimpleTemplateEngine()
		def queryTemplate = engine.createTemplate(queryString)
		def rangeQueryTemplate = engine.createTemplate(rangeQueryString)
		def selects = []
		
		// get patient ids for biospecimens
		def bioPatientIds
		if(biospecimenIds && biospecimenIds.size() > 0) {
			bioPatientIds = getSubjectsIdsForChildIds(biospecimenIds)
		}
		log.debug "BIO PATIENT IDS $bioPatientIds"
		if(!criteria || criteria.size() == 0) {
			def patients = Subject.executeQuery("select p.id from Subject p where p.type = \'${subjectType}\'")
			// filter out patients that did not match biopecimens
			if(bioPatientIds && bioPatientIds.size() > 0) {
				patients = patients.findAll {
					log.debug "COMPARING ${it}"
					bioPatientIds.count(it) > 0
				}
			}
			return patients
		}
		criteria.each { entry ->
			def temp =[:]
			temp.key = entry.key
			temp.value = entry.value
			temp.schema = StudyContext.getStudy()
			temp.type = subjectType
			if(temp.value instanceof java.util.Map) {
				selects << rangeQueryTemplate.make(temp)
			} 
			else if(temp.value instanceof java.util.ArrayList) {
				//log.debug "its an array create an or string and add to select statements"
				selects << createORQueryString(temp.value)
			} 
			else {
				selects << queryTemplate.make(temp)
			}
			
		}
		def query = selects.join(" INTERSECT ")
		log.debug query
		def ids = jdbcTemplate.queryForList(query)
		def patientIds = ids.collect { id ->
			return id["SUBJECT_ID"]
		}
		
		// filter out patients that do not match biospecimen criteria
		if(bioPatientIds && bioPatientIds.size() > 0) {
			patientIds = patientIds.intersect(bioPatientIds)
		}
		return patientIds
	}
	
	def createORQueryString(attributes){
		def schema = StudyContext.getStudy()
		def selectStmnt = '(select /*+ index(v,PATIENT_ATTRIBUTE_VALUE_INDEX1) */ unique (p.subject_id) from ' + schema + '.subject p, common.attribute_type c, ' + schema + '.patient_attribute_value v ' +
			 			  'where p.subject_id = v.subject_id and v.attribute_type_id = c.attribute_type_id ' +
						  ' and ('
		//log.debug "iterate over array and add each mapped criteria, depending on range or regular value"
		def addendum = []
		def addendumString = ""
		attributes.each{ att ->
			att.each{ key, value ->
				if(value instanceof java.util.Map){
					//value.each{ mapKey, mapVal ->
						//log.debug "this value for $key is a map, rangeify it for $value.min , $value.max"
						addendum << "(c.short_name = \'${key}\' and v.value BETWEEN ${value.min} and ${value.max} )"
					//}
				}else{
					//log.debug "this value for $key is not a map"
					addendum << "(c.short_name = \'${key}\' and v.value = \'${value}\' )"
				}
			}
		}
		addendumString = addendum.join(" OR ")
		selectStmnt += addendumString
		selectStmnt += "))"
		log.debug "MY SELCT statement = $selectStmnt"
		return selectStmnt
	}
	
	def getSubjectsIdsForChildIds(biospecimenIds) { 
		
		def engine = new SimpleTemplateEngine()
		def queryTemplate = engine.createTemplate(patientIdQuery)
		def patientIds = []
		def index = 0;
		while(index < biospecimenIds.size()) {
			def specimensLeft = biospecimenIds.size() - index
			def tempSpecimens
			if(specimensLeft > PAGE_SIZE) {
				def ids = biospecimenIds.getAt(index..<(index + PAGE_SIZE))
				def temp =[:]
				temp.ids = ids.join(", ")
				temp.schema = StudyContext.getStudy()
				def query = queryTemplate.make(temp)
				log.debug "QUERY $query"
				tempSpecimens = jdbcTemplate.queryForList(query.toString())
				patientIds.addAll(tempSpecimens.collect { id ->
					return id["PARENT_ID"]
				})
				index += PAGE_SIZE
			} else {
				def ids = biospecimenIds.getAt(index..<biospecimenIds.size())
				log.debug "IDS $ids"
				
				def temp =[:]
				temp.ids = ids.join(", ")
				temp.schema = StudyContext.getStudy()
				def query = queryTemplate.make(temp)
				log.debug "QUERY $query"
				tempSpecimens = jdbcTemplate.queryForList(query.toString())
				patientIds.addAll(tempSpecimens.collect { id ->
					return id["PARENT_ID"]
				})
				index += specimensLeft
			}
		}
		return patientIds
	}
	
	def getPatientsForGdocIds(gdocIds) {
		return getPatientsForIds(gdocIds)
	}
	
	def getPatientsForIds(patientIds) {
		def pids = []
		if(patientIds.metaClass.respondsTo(patientIds, "replace")) {
			log.debug " ids are coming from string"
			patientIds.tokenize(",").each{
				pids.add(it)	
			}
		}else{
			pids = patientIds
		}
		def patients = []
		def index = 0;
		log.debug "patient ids $pids"
		while(index < pids.size()) {
			def patientsLeft = pids.size() - index
			def tempPatients
			if(patientsLeft > PAGE_SIZE) {
				tempPatients = Subject.getAll(pids.getAt(index..<(index + PAGE_SIZE)))
				patients.addAll(tempPatients)
				index += PAGE_SIZE
			} else {
				tempPatients = Subject.getAll(pids.getAt(index..<pids.size()))
				patients.addAll(tempPatients)
				index += patientsLeft
			}
		}
		log.debug patients.size()
		return patients.grep { it }
	}
	
	def retrieveSearchableAttributes(){
		def attributesQuery = QueryBuilder.getAllAttributesSparql()
		def results = middlewareService.sparqlQuery(attributesQuery)
		return results;
	}
	
}
