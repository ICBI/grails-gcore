import grails.converters.*

class SavedAnalysisService {
	
	def securityService
	
	def getAllSavedAnalysis(userId,sharedIds){
		def user = GDOCUser.findByUsername(userId)
		user.refresh()
		def analyses = user.analysis
		def analysisIds = []
		def sharedAnalysisIds = []
		sharedAnalysisIds = sharedIds
		
		if(!sharedAnalysisIds){
			sharedAnalysisIds = getSharedAnalysisIds(userId,false)
		}
		if(analyses){
			if(analyses.metaClass.respondsTo(analyses, "size")) {
				analyses.each{
					analysisIds << it.id.toString()
				}
			} else {
				analysisIds << analyses.id.toString()
			}
		}
			
		def sharedAnalyses = []
		//until we modify ui, just add shared lists to 'all' lists
		sharedAnalysisIds.each{
			if(!(analysisIds.contains(it))){
				def foundAnalysis = SavedAnalysis.get(it.toString())
				if(foundAnalysis){
					analyses << foundAnalysis
				}
		   	}
		}
		analyses = analyses.sort { one, two ->
			def dateOne = one.dateCreated
			def dateTwo = two.dateCreated
			return dateTwo.compareTo(dateOne)
		}
		
		
		return analyses
	}
	
	def checkSavedAnalysis(userId) {
		def criteria = GDOCUser.createCriteria()
		def savedAnalysis = criteria {
			projections {
				analysis {
					property('id')
					property('type')
					property('status')
					property('dateCreated')
				}
			}
			eq("username", userId)
		}
		return savedAnalysis
	}
	
	def addSavedAnalysis(userId, notification, command, tags) {
		def user = GDOCUser.findByUsername(userId)
		log.debug notification.item.taskId
		def params = command.properties
		def queryData = [:]
		params.each { k, v ->
			if(!['errors', 'class', 'metaClass', 'annotationService', 'requestType', 'idService', 'userListService', 'constraints'].contains(k)) {
				queryData[k] = v
			}
		}
		def newAnalysis = new SavedAnalysis()
		newAnalysis.type = command.requestType
		newAnalysis.query = queryData
		newAnalysis.analysis = notification
		newAnalysis.author = user
		newAnalysis.status = notification.status
		newAnalysis.taskId = notification.item.taskId
		def study = Study.findBySchemaName(command.study)
		newAnalysis.addToStudies(study)
		newAnalysis.save(flush:true)
		if(tags){
			tags.each {
				log.debug "add tag, $it to analysis $newAnalysis"
				newAnalysis.addTag(it)
			}
		}
		return newAnalysis
	}
	
	
	
	
	def saveAnalysisResult(userId, result, command, tags){
		def user = GDOCUser.findByUsername(userId)
		def params = command.properties
		def queryData = [:]
		params.each { k, v ->
			if(!['errors', 'class', 'metaClass', 'annotationService', 'requestType', 'idService', 'userListService', 'constraints'].contains(k)) {
				queryData[k] = v
			}
		}
		log.debug "going to send: " + command.requestType + ", " + params + ", " + result + ", " + user
		def newAnalysis = new SavedAnalysis()
		newAnalysis.type = command.requestType
		newAnalysis.query = queryData
		newAnalysis.analysisData = result
		newAnalysis.author = user
		newAnalysis.status = "Complete"
		def study = Study.findBySchemaName(command.study)
		newAnalysis.addToStudies(study)
		newAnalysis.save(flush:true)
		if(newAnalysis.type == AnalysisType.KM_GENE_EXPRESSION){
			tags << "GENE_EXPRESSION"
			if(newAnalysis.query.geAnalysisId.toString() != null){
				log.debug "found the related analysis: " + newAnalysis.query.geAnalysisId + " , is it temporary?"
				def relatedAnalysis = SavedAnalysis.get(newAnalysis.query.geAnalysisId)
				if(relatedAnalysis.tags?.contains(Constants.TEMPORARY)){
					tags << Constants.TEMPORARY
				}
			}
		}
		if(tags){
			tags.each {
				//log.debug "add tag, $it to analysis"
				newAnalysis.addTag(it)
			}
		}
		return newAnalysis
	}
	
	
	
	def updateSavedAnalysis(userId, notification) {
		def runningAnalysis = getSavedAnalysis(userId, notification.item.taskId)
		if(runningAnalysis) {
			runningAnalysis.analysis = notification
			runningAnalysis.status = notification.status
			runningAnalysis.taskId = notification.item.taskId
			runningAnalysis.save(flush:true)
				
		} else {
			log.debug "ERROR!  Analysis ${notification.item.taskId} not found"
		}
	}
	
	def getAllSavedAnalysis(userId) {
		def user = GDOCUser.findByUsername(userId)
		//def groupAnalysisIds = securityService.getSharedItemIds(userId, SavedAnalysis.class.name,false)
		def notifications = user.analysis
		return notifications
	}
	
	def deleteAnalysis(analysisId) {
		def analysis = SavedAnalysis.get(analysisId)
		if(analysis) {
			ProtectedArtifact.executeUpdate("delete ProtectedArtifact pa where pa.type = 'SavedAnalysis' and pa.objectId = :analysisId", [analysisId:analysisId.toString()])
			log.debug "deleted all protected artifacts for saved analysis $analysisId"
			if(analysis.type == AnalysisType.KM_GENE_EXPRESSION){
				if(analysis.query.geAnalysisId.toString() != 'null'){
					log.debug "deleting the related analysis: " + analysis.query.geAnalysisId
					def id = new Long(analysis.query.geAnalysisId)
					def relatedAnalysis = SavedAnalysis.get(id)
					if(relatedAnalysis)
						relatedAnalysis.delete(flush: true)
				}
				analysis.delete(flush: true)
			}else{
				analysis.delete(flush: true)
			}
		}
	}
	
	def getFilteredAnalysis(timePeriod, userId, sharedIds){
		
		def filteredAnalysis = []
		
			if(timePeriod == "all"){
				log.debug "show ALL user's analyses"
				filteredAnalysis = getAllSavedAnalysis(userId, sharedIds)
				return filteredAnalysis
			}
			else if(timePeriod == "hideShared"){
				log.debug "only show user's analyses"
				def user = GDOCUser.findByUsername(userId)
				filteredAnalysis = user.analysis
				return filteredAnalysis
			}
			else{
				def tp = Integer.parseInt(timePeriod)
				def today = new Date()
				def allAnalysis = []
				def user = GDOCUser.findByUsername(userId)
				allAnalysis = user.analysis
				allAnalysis.each{ analysis ->
					if(today.minus(analysis.dateCreated) <= tp){
						filteredAnalysis << analysis
					}
				}
				return filteredAnalysis
			}
			
		return filteredAnalysis
		
	}
	
	def getPaginatedAnalyses(filter,sharedIds,offset,userId,searchTerm){
		log.debug "get paginates ANALYSIS search term $searchTerm"
		def pagedAnalyses
		def user = GDOCUser.findByUsername(userId)
		switch (filter) {
			case "hideShared":
				pagedAnalyses = getUsersAnalyses(offset,user)
			break;
			case "all":
				pagedAnalyses = getAllAnalyses(sharedIds,offset,user)
			break;
			case ['30','90','180']:
	            pagedAnalyses = getUsersAnalysesByTimePeriod(filter,offset,user)
			break;
			case "search":
				if(!searchTerm){
					pagedAnalyses = getUsersAnalyses(offset,user)
				}
				else{
					pagedAnalyses = searchAnalysesByTerm(searchTerm,sharedIds,user.username,offset)
				}
			break;
			default: pagedAnalyses = getUsersAnalyses(offset,user)
		}
		
		return pagedAnalyses
	}
	
	def searchAnalysisByTerm(term,sharedIds, user,offset){
		log.debug "use criteria ..."+"GENE_EXPRESSIONs"
		def pagedAnalyses = []
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			pagedAnalyses = SavedAnalysis.createCriteria().list(max:10,offset:offset)
				{
					or{
						'ilike'('name', "%"+term+"%")
						'ilike'("description", "%"+term+"%")
						'ilike'("type", AnalysisType.fromValue("GENE_EXPRESSION"))
					}
					or {
						eq("author", user)
						'in'('id',ids)
					}
				}
			log.debug "all analysis -> $pagedAnalyses as Paged set"
		}else{
			pagedAnalyses = SavedAnalysis.createCriteria().list(max:10,offset:offset)
				{
					or{
						'ilike'('name', "%"+term+"%")
						'ilike'("description", "%"+term+"%")
						'ilike'("type", term)
					}
					or {
						eq("author", user)
					}
				}
		}
		return pagedAnalyses
	}
	
	def searchAnalysesByTerm(term,sharedIds, userName,offset){
		def pagedAnalyses = [:]
		def ids = []
		def results = []
		def snapshotMaps = []
		def count = 0
		if(sharedIds){
			sharedIds.each{
				ids << new Long(it)
			}
		}
		if(ids){
			//log.debug "search by the term "+"$term"
			def analysisHQL = "SELECT analysis FROM SavedAnalysis analysis JOIN analysis.author author " + 
			"WHERE (author.username = :username " +
			"OR analysis.id IN (:ids)) " + 
			"AND (lower(analysis.description) like lower(:term) " +
			"OR lower(analysis.name) like lower(:term) " +
			"OR lower(analysis.type) like lower(:term))"
			"ORDER BY analysis.dateCreated desc"
			results = SavedAnalysis.executeQuery(analysisHQL, [term:"%"+term+"%", ids:ids, username: userName,max:10, offset:offset])
			pagedAnalyses["results"] = results
			log.debug "the resukts"+results
			def analysisCountHQL = "SELECT count(distinct analysis.id) FROM SavedAnalysis analysis JOIN analysis.author author " + 
			"WHERE (author.username = :username " +
			"OR analysis.id IN (:ids)) " + 
			"AND (lower(analysis.description) like lower(:term) " +
			"OR lower(analysis.name) like lower(:term) " +
			"OR lower(analysis.type) like lower(:term))" 
			count = SavedAnalysis.executeQuery(analysisCountHQL,[term:"%"+term+"%", ids:ids, username: userName])
			pagedAnalyses["sa_count"] = count
			log.debug "paged analyses $pagedAnalyses"
		}
		else{
			def analysisHQL = "SELECT analysis FROM SavedAnalysis analysis JOIN analysis.author author " + 
			"WHERE author.username = :username " +
			"AND (lower(analysis.description) like lower(:term) " +
			"OR lower(analysis.name) like lower(:term) " +
			"OR lower(analysis.type) like lower(:term))"
			"ORDER BY analysis.dateCreated desc"
			results = SavedAnalysis.executeQuery(analysisHQL, [term:'%'+term+'%', username: userName,max:10, offset:offset])
			pagedAnalyses["results"] = results
			def analysisCountHQL = "SELECT count(distinct analysis.id) FROM SavedAnalysis analysis JOIN list.author author " + 
			"WHERE author.username = :username " + 
			"AND (lower(analysis.description) like lower(:term) " +
			"OR lower(analysis.name) like lower(:term) " +
			"OR lower(analysis.type) like lower(:term))"
			count = SavedAnalysis.executeQuery(analysisCountHQL,[term:'%'+term+'%', username: userName])
			pagedAnalyses["sa_count"] = count
		}
		
		return pagedAnalyses
	}
		
	
	def getAllAnalyses(sharedIds,offset,user){
		log.debug "in get all"
		def pagedAnalyses = []
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			pagedAnalyses = SavedAnalysis.createCriteria().list(
				max:10,
				offset:offset)
				{
					and{
						'ne'('status', "Running")
						'order'("dateCreated", "desc")
					}
					or {
						eq("author", user)
						'in'('id',ids)
					}
				}
			log.debug "all analysis -> $pagedAnalyses as Paged set"
		}else{
			pagedAnalyses = SavedAnalysis.createCriteria().list(
				max:10,
				offset:offset)
				{
					and{
						'ne'('status', "Running")
						'order'("dateCreated", "desc")
						'eq'("author", user)
					}
				}
		}
		return pagedAnalyses
	}
	
	def getUsersAnalyses(offset,user) {
		def userAnalysis = [:]
		def pagedAnalyses = [:]
		def total
		pagedAnalyses = SavedAnalysis.createCriteria().list(
			max:10,
			offset:offset)
			{
				and{
					'ne'('status', "Running")
					'order'("dateCreated", "desc")
					'eq'("author", user)
				}
			}
		log.debug "user analysis only-> $pagedAnalyses as Paged set"
		return pagedAnalyses
	}
	
	def getUsersAnalysesByTimePeriod(timePeriod,offset,user) {
		def pagedAnalyses = []
		def now = new Date()
		def tp = Integer.parseInt(timePeriod)
		pagedAnalyses = SavedAnalysis.createCriteria().list(
			max:10,
			offset:offset)
			{
				and{
					'ne'('status', "Running")
					'between'('dateCreated',now-tp,now)
					'order'("dateCreated", "desc")
				}
				or {
					eq("author", user)
				}
			}
		log.debug "user analysis only over past $timePeriod days-> $pagedAnalyses as Paged set"
		return pagedAnalyses
	}
	
	def getAllAnalysesIds(sharedIds,userId){
		def savedAnalysisIds = []
		def analysisHQL
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			analysisHQL = "SELECT distinct analysis.id FROM SavedAnalysis analysis JOIN analysis.author author " + 
			"WHERE author.username = :username OR analysis.id IN (:ids) "
			savedAnalysisIds = UserList.executeQuery(analysisHQL,[username:userId, ids:ids])
		}else{
			analysisHQL = "SELECT distinct analysis.id FROM SavedAnalysis analysis JOIN analysis.author author " + 
			"WHERE author.username = :username "
			savedAnalysisIds = SavedAnalysis.executeQuery(analysisHQL,[username:userId])
		}
		log.debug "got savedAnalysis ids $savedAnalysisIds"
		return savedAnalysisIds
	}
	
	def isDuplicateAnalysis(userId, analysisId, analysisName){
		def name = analysisName.trim()
		def analysisIds = []
		def analysisHQL
		analysisHQL = "SELECT distinct analysis.id FROM SavedAnalysis analysis JOIN analysis.author author " + 
		"WHERE author.username = :username and analysis.name = :name"
		analysisIds = SavedAnalysis.executeQuery(analysisHQL,[username:userId, name:name])
		if(analysisIds.size() == 1){
			log.debug "found analysisIds="+analysisIds[0]
			if(analysisIds[0] == analysisId.toLong()){
				log.debug "assert same analysis"
				return false
			}
			else{
				log.debug "analysis name already exists"
				return true
			}
		}
		log.debug "analysis exists by that name, naming can continue"
		return false
	}
	

	
	def filterAnalysis(timePeriod, allAnalysis, userId){
		def filteredAnalysis = []
		if(allAnalysis){
			if(timePeriod == "all"){
				return allAnalysis
			}
			else if(timePeriod == "hideShared"){
				log.debug "hide all shared lists"
				allAnalysis.each{ analysis ->
					if(analysis.author.username == userId){
						filteredAnalysis << analysis
					}
				}
				return filteredAnalysis
			}
			else{
				def tp = Integer.parseInt(timePeriod)
				def today = new Date()
				allAnalysis.each{ analysis ->
					if(today.minus(analysis.dateCreated) <= tp){
						filteredAnalysis << analysis
					}
				}
				return filteredAnalysis
			}
			
		}else{
			return filteredAnalysis
		}
		
	}
	
	
	
	def getSavedAnalysis(userId, taskId) {
		def item = SavedAnalysis.findByTaskId(taskId)
		if(item){
			item.refresh()
			item.studies
		}
		return item
	}
	
	def getTempAnalysisIds(userId) {
		
		String findByTagHQL = """
		   SELECT DISTINCT analysis.id
		   FROM SavedAnalysis analysis, TagLink tagLink
		   JOIN analysis.author author
		   WHERE analysis.id = tagLink.tagRef
		   AND author.username = :username
		   AND tagLink.type = 'savedAnalysis'
		   AND tagLink.tag.name = :tag
		"""
		
		def savedAnalysisIds = SavedAnalysis.executeQuery(findByTagHQL, [tag: Constants.TEMPORARY, username: userId])
		return savedAnalysisIds	
	}
	
	def getSharedAnalysisIds(userId,refresh){
		def sharedAnalysisIds = []
		sharedAnalysisIds = securityService.getSharedItemIds(userId, SavedAnalysis.class.name,refresh)
		return sharedAnalysisIds
	}
	
	def getSavedAnalysis(analysisId) {
		def item = SavedAnalysis.get(analysisId)
		if(item){
			item.refresh()
		}
		return item
	}
	
	def analysisIsTemporary(analysisId){
		def compAnalysis = SavedAnalysis.get(analysisId)
		if(compAnalysis.tags?.contains(Constants.TEMPORARY)){
			return true
		}
		else{
			return false
		}
		return false
	}
}