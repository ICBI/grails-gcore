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
	def timepointQuery = '(select p.subject_id from ${schema}.Subject p where p.type = \'${subjectType}\' and p.timepoint = \'${timepoint}\') '
	
	def patientIdQuery = 'select s.parent_id from ${schema}.subject s where s.subject_id in (${ids})'
	
    boolean transactional = true
	
	//-----------new feature--------------
	def getSummary(criteria, subjectType, childIds) {
		//log.debug "querying by criteria"
		def patientIds = []
		def patients = []
		patientIds = getSubjectIdsForCriteria(criteria, subjectType, childIds)
		if(patientIds)
			patients = Subject.getAll(patientIds)
		return patients
	}
	
	def getBreakdowns(criteria, patientIds){
		def breakdown = [:]
		return breakdown
	}
	//-----------------------------------
	
	
	def queryByCriteria(criteria, subjectType, childIds) {
		log.debug "querying by criteria"
		def patientIds = getSubjectIdsForCriteria(criteria, subjectType, childIds)
		return getPatientsForIds(patientIds)
	}
	
	def getSubjectIdsForCriteria(criteria, subjectType, biospecimenIds){
		def engine = new SimpleTemplateEngine()
		def queryTemplate = engine.createTemplate(queryString)
		def rangeQueryTemplate = engine.createTemplate(rangeQueryString)
		def timepointQueryTemplate = engine.createTemplate(timepointQuery)
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
			if(temp.key == "timepoint") {
				return
			}
			else if(temp.value instanceof java.util.Map) {
				selects << rangeQueryTemplate.make(temp)
			} 
			else if(temp.value instanceof java.util.ArrayList) {
				//log.debug "its an array create an or string and add to select statements"
				selects << createORQueryString(temp)
			} 
			else {
				selects << queryTemplate.make(temp)
			}
			
		}
		if(criteria.timepoint)
			selects << timepointQueryTemplate.make([timepoint: criteria.timepoint, subjectType: subjectType, schema: StudyContext.getStudy()])
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
		//log.debug "parse " + attributes.value
		def key = attributes.key
		def schema = StudyContext.getStudy()
		def selectStmnt = '(select /*+ index(v,SUBJECT_ATTRIBUTE_VALUE_INDEX1) */ unique (p.subject_id) from ' + schema + '.subject p, common.attribute_type c, ' + schema + '.subject_attribute_value v ' +
			 			  'where p.subject_id = v.subject_id and v.attribute_type_id = c.attribute_type_id ' +
						  ' and ('
		//log.debug "iterate over array and add each mapped criteria, depending on range or regular value"
		def addendum = []
		def addendumString = ""
		attributes.value.each{ att ->
			addendum << "(c.short_name = \'${key}\' and v.value = \'${att}\' )"
			log.debug addendum
		}
		addendumString = addendum.join(" OR ")
		selectStmnt += addendumString
		selectStmnt += "))"
		log.debug "MY SELCT statement = $selectStmnt"
		return selectStmnt
	}
	
	def getExistingSubjectsIdsForChildIds(biospecimenIds){
		def parentsId = []
		parentsId = getSubjectsIdsForChildIds(biospecimenIds)
		if(parentsId){
			//log.debug "remove nulls $parentsId"
			parentsId.removeAll([null])
			//log.debug "removed nulls $parentsId"
		}
		return parentsId
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
	
	//move to service
	def handleCriteria(breakdowns,criteria,filterSubjects, toAddCriteria,toDeleteCriteria,medians,atttributeLabel) {
		log.debug "handle criteria "+criteria
		criteria.each{ k,v ->
			log.debug "find by $k"
			if(v instanceof Map){
				def attCount = []
				def attCountN = []
				def max = v.max.toLong()
				def min = v.min.toLong()
				def removeBucket = []
				if(medians[k]){
					toAddCriteria[k] = []
					log.debug "found median for $k of "+medians[k]
					def upperLabel = k+":"+"UPPER"+"("+(medians[k]+1)+"-"+v.max+")"
					def lowerLabel = k+":"+"LOWER"+"("+v.min+"-"+medians[k]+")"
					breakdowns[atttributeLabel][upperLabel] = new HashSet()
					breakdowns[atttributeLabel][lowerLabel] = new HashSet()
					if(v.min > medians[k]){
						log.debug "must have chosen upper quartile"
						toAddCriteria[k] << "UPPER"+"("+(medians[k]+1)+"-"+v.max+")"
						removeBucket << lowerLabel
					}
					if(v.max == medians[k]){
						log.debug "must have chosen lower quartile"
						toAddCriteria[k] << "LOWER"+"("+v.min+"-"+medians[k]+")"
						removeBucket << upperLabel
					}
					if((v.min < medians[k]) && (v.max != medians[k]))
						toAddCriteria[k]=["UPPER"+"("+(medians[k]+1)+"-"+v.max+")","LOWER"+"("+v.min+"-"+medians[k]+")"]
				}
				else{
					breakdowns[atttributeLabel][k] = []
				}
				//add median if not defined earlier and group into upper and lower for each, then Re-modify combo
				//code to account for this classification
				filterSubjects.each{
					def val = it.clinicalDataValues[k]?.toLong()
					def vals =[]
					//log.debug it.clinicalDataValues[k].toLong() + "?"
					
					//NEW for sample
					if(!val){
						log.debug "no clinical field on parent, mjs be child"
						if(it.children){
								it.children.each{ subject ->
									if(subject.clinicalDataValues[k]){
										def values = []
										if(subject.clinicalDataValues[k].metaClass?.respondsTo(subject.clinicalDataValues[k], 'join'))
											values = subject.clinicalDataValues[k]
										else
											values << subject.clinicalDataValues[k]
										values.each{ clinVal->
												log.debug "make big decimal"
												clinVal = clinVal.toBigDecimal()
												log.debug "done big decimal"
												if(medians[k]){
													log.debug "found median now compare "+medians[k].class+ " and " +clinVal.class
													if( (clinVal <= medians[k])){
														breakdowns[atttributeLabel][k+":"+"LOWER"+"("+v.min+"-"+medians[k]+")"] << it.id
													}else if( (clinVal > medians[k])){
														breakdowns[atttributeLabel][k+":"+"UPPER"+"("+(medians[k]+1)+"-"+v.max+")"] << it.id
													}
												}else{
													if( (clinVal <= max) && (clinVal >= min)){
														breakdowns[atttributeLabel][k] << it.id
													}
												}
											
										}
									}
										
								}
						}
					}
					//END NEW for sample
					else{
						if(medians[k]){
							if( (val <= medians[k])){
								breakdowns[atttributeLabel][k+":"+"LOWER"+"("+v.min+"-"+medians[k]+")"] << it.id
							}else if( (val > medians[k])){
								breakdowns[atttributeLabel][k+":"+"UPPER"+"("+(medians[k]+1)+"-"+v.max+")"] << it.id
							}
						}else{
							if( (val <= max) && (val >= min)){
								breakdowns[atttributeLabel][k] << it.id
							}
						}
					}
				}
				
				//add to delete criteria
				toDeleteCriteria[k]=v.toMapString()
			}
			if(v.metaClass?.respondsTo(v, 'join')){
				v.each{ attValue ->
					def attCount = []
					attCount = filterSubjects.findAll{
						it.clinicalDataValues[k] == attValue
					}
					
					//NEW for sample
					if(!attCount){
						log.debug "no subjects found for $k array,trying to find $k"
						if(filterSubjects.children){
								filterSubjects.each{ subject ->
									if(subject.children.clinicalDataValues[k] && subject.children.clinicalDataValues[k].contains(attValue)){
										if(!attCount.contains(subject))
											attCount << subject
									}
										
								}
						}
					}
					//END NEW for sample
					
					breakdowns[atttributeLabel][k+":"+attValue] = [:]
					breakdowns[atttributeLabel][k+":"+attValue] = attCount.collect{it.id}
				}
			}else{
				def attCount = []
				attCount = filterSubjects.findAll{
					it.clinicalDataValues[k] == v
				}
				
				//NEW for sample
				if(!attCount){
					if(filterSubjects.children){
							filterSubjects.each{ subject ->
								if(subject.children.clinicalDataValues[k] && subject.children.clinicalDataValues[k].contains(v)){
									if(!attCount.contains(subject))
										attCount << subject
								}
									
							}
					}
				}
				//END NEW for sample
				
				breakdowns[atttributeLabel][k+":"+v] = [:]
				breakdowns[atttributeLabel][k+":"+v] = attCount.collect{it.id}
				
			}
			
			log.debug "breakdowns now: "+breakdowns
		}
		
	
	
	//criteria ends
	return [breakdowns:breakdowns,toAddCriteria:toAddCriteria,toDeleteCriteria:toDeleteCriteria]
	}
	
	
	
	public static <K,V> void combinations( Map<K,Set<V>> map, List<Map<K,V>> list ) {
	        recurse( map, new LinkedList<K>( map.keySet() ).listIterator(), new HashMap<K,V>(), list );
	 }
	
	// helper method to do the recursion
	private static <K,V> void recurse( Map<K,Set<V>> map, ListIterator<K> iter, Map<K,V> cur, List<Map<K,V>> list ) {
	            // we're at a leaf node in the recursion tree, add solution to list
	        if( !iter.hasNext() ) {
	            Map<K,V> entry = new HashMap<K,V>();

	            for( K key : cur.keySet() ) {
	                entry.put( key, cur.get( key ) );
	            }

	            list.add( entry );
	        } else {
	            K key = iter.next();
				Set<V> set = new HashSet();
				if(map.get( key ) instanceof String){
					set.add(map.get( key ) );
				}else{
					set = map.get( key );
				}
	            

	            for( V value : set ) {
	                cur.put( key, value );
	                recurse( map, iter, cur, list );
	                cur.remove( key );
	            }

	            iter.previous();
	        }
	}
	
	
	
}
