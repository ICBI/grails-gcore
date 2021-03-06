import grails.converters.*

class UserListService{

def securityService
def extensionService
def idService
	
	def getPaginatedLists(filter,sharedIds,offset,userId,searchTerm){
		def pagedLists = [:]
		log.debug "get paginated lists"
		switch (filter) {
		   case "hideShared":
			pagedLists = getUsersLists(offset,userId)
		   break;
		   case "all":
			pagedLists = getAllLists(sharedIds,offset,userId)
		   break;
		   case ['1','7','30','90','180']:
            pagedLists = getUsersListsByTimePeriod(filter,offset,userId)
		   break;
		   case ['gene','patient','reporter']:
			pagedLists = filterByType(filter,sharedIds,userId,offset)
		    break;
		   case ['my_gene','my_patient','my_reporter']:
		    filter = filter.split("_")
			pagedLists = filterByType(filter[1],null,userId,offset)
			break;
		   case ['findings']:
			pagedLists = filterByFindingsLists(offset)
			break;
		   case "onlyShared":
			pagedLists = getSharedListsOnly(sharedIds,offset)
		  	log.debug "only shared"
		    break;
		   case "search":
			if(!searchTerm){
				pagedLists = getUsersLists(offset,userId)
			}
			else{
				pagedLists = searchListsByTerm(searchTerm,sharedIds,userId,offset)
			}
			break;
		   default: pagedLists = getUsersLists(offset,userId)
		}
		return pagedLists
	}
	
	def searchListsByTerm(term,sharedIds, userName,offset){
		def pagedLists = [:]
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
			log.debug "search by term $term"
			def listHQL = "SELECT distinct list FROM UserList list,UserListItem item JOIN list.author author " + 
			"WHERE list = item.parentList " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " + 
			"AND (lower(item.value) like lower(:term) " +
			"OR lower(list.name) like lower(:term) " + 
			"OR lower(list.description) like lower(:term)) " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL, [term:"%"+term+"%", ids:ids, username: userName,max:2000, offset:offset])
			pagedLists["results"] = results
			def listCountHQL = "SELECT count(distinct list.id) FROM UserList list,UserListItem item JOIN list.author author " +
			"WHERE list = item.parentList " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " +
			"AND (lower(item.value) like lower(:term) " +
			"OR lower(list.name) like lower(:term) " +
			"OR lower(list.description) like lower(:term)) "
			count = UserList.executeQuery(listCountHQL,[term:"%"+term+"%", ids:ids, username: userName])
			pagedLists["count"] = count
			log.debug "paged lists $pagedLists"
		}
		else{
			def listHQL = "SELECT distinct list FROM UserList list,UserListItem item JOIN list.author author " +
			"WHERE list = item.parentList " +
			"AND author.username = :username " +
			"AND (lower(item.value) like lower(:term) " +
			"OR lower(list.name) like lower(:term) " +
			"OR lower(list.description) like lower(:term)) " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL, [term:'%'+term+'%', username: userName,max:2000, offset:offset])
			pagedLists["results"] = results
			def listCountHQL = "SELECT count(distinct list.id) FROM UserList list,UserListItem item JOIN list.author author " +
			"WHERE list = item.parentList " +
			"AND author.username = :username " +
			"AND (lower(item.value) like lower(:term) " +
			"OR lower(list.name) like lower(:term) " +
			"OR lower(list.description) like lower(:term)) "
			count = UserList.executeQuery(listCountHQL,[term:'%'+term+'%', username: userName])
			pagedLists["count"] = count
		}
		//add query to populate tools list with non-paginated snap-shot
		snapshotMaps = getAllListsNoPagination(userName,sharedIds)
		pagedLists["snapshot"] = snapshotMaps
		return pagedLists
	}

	def deleteList(listId){
        def userListInstance = UserList.get(listId)
        if(userListInstance) {
			ProtectedArtifact.executeUpdate("delete ProtectedArtifact pa where pa.type = 'UserList' and pa.objectId = :listId", [listId:listId.toString()])
			log.debug "deleted all protected artifacts for list $listId"

            userListInstance.delete(flush:true)
			log.debug "deleted " + userListInstance
        }
        else {
            log.debug "did not delete list $listId"
        }
    }

	def getSharedListsOnly(sharedIds,offset){
		def pagedLists = [:]
		def results = []
		def snapshots = []
		def snapshotMaps = []
		def count = 0
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			String listHQL = "SELECT distinct list FROM UserList list " +
			"WHERE list.id IN (:ids) " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL,[ids:ids, max:2000, offset:offset])
			pagedLists["results"] = results
			String listHQL2 = "SELECT count(distinct list.id) FROM UserList list " +
			"WHERE list.id IN (:ids) "
			count = UserList.executeQuery(listHQL2,[ids:ids])
			pagedLists["count"] = count
			String listHQL3 = "SELECT distinct list.id,list.name FROM UserList list " +
			"WHERE list.id IN (:ids) "
			snapshots = UserList.executeQuery(listHQL3,[ids:ids])
			if(snapshots){
				snapshots.each{
					def snapMap = [:]
					snapMap["id"] = it[0]
					snapMap["name"] = it[1]
					snapshotMaps << snapMap
				}
			}
			pagedLists["snapshot"] = snapshotMaps
			log.debug "only shared lists -> $pagedLists as Paged set"
		}else{
			log.debug "no shared lists"
		}
		return pagedLists
	}

	def getUsersLists(offset,user){
		def pagedLists = [:]
		def results = []
		def count = 0
		def snapshots = []
		def snapshotMaps = []
		String listHQL = "SELECT distinct list FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username " +
		"ORDER BY list.dateCreated desc"
		results = UserList.executeQuery(listHQL,[username:user, max:2000, offset:offset])
		pagedLists["results"] = results
		String listHQL2 = "SELECT count(distinct list.id) FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username "
		count = UserList.executeQuery(listHQL2,[username:user])
		pagedLists["count"] = count
		//add query to populate tools list with non-paginated snap-shot
		String listHQL3 = "SELECT distinct list.id, list.name, list.dateCreated FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username " +
		"ORDER BY list.dateCreated desc"
		snapshots = UserList.executeQuery(listHQL3,[username:user])
		if(snapshots){
			snapshots.each{
				def snapMap = [:]
				snapMap["id"] = it[0]
				snapMap["name"] = it[1]
				snapshotMaps << snapMap
			}
		}
		pagedLists["snapshot"] = snapshotMaps
		return pagedLists
	}

	def getAllListIds(sharedIds,userId){
		def listIds = []
		def listHQL
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			listHQL = "SELECT distinct list.id FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username OR list.id IN (:ids) "
			listIds = UserList.executeQuery(listHQL,[username:userId, ids:ids])
		}else{
			listHQL = "SELECT distinct list.id FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username "
			listIds = UserList.executeQuery(listHQL,[username:userId])
		}
		log.debug "got list ids $listIds"
		return listIds
	}

	def getAllLists(sharedIds,offset,user){
		def pagedLists = [:]
		def results = []
		def snapshots = []
		def snapshotMaps = []
		def count = 0
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			String listHQL = "SELECT distinct list FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username OR list.id IN (:ids) " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL,[username:user, ids:ids, max:2000, offset:offset])
			pagedLists["results"] = results
			String listHQL2 = "SELECT count(distinct list.id) FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username OR list.id IN (:ids) "
			count = UserList.executeQuery(listHQL2,[username:user,ids:ids])
			pagedLists["count"] = count
			log.debug "all lists -> $pagedLists as Paged set"
		}else{
			String listHQL = "SELECT distinct list FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL,[username:user, max:2000, offset:offset])
			pagedLists["results"] = results
			String listHQL2 = "SELECT count(distinct list.id) FROM UserList list JOIN list.author author " +
			"WHERE author.username = :username "
			count = UserList.executeQuery(listHQL2,[username:user])
			pagedLists["count"] = count
			log.debug "all lists -> $pagedLists as Paged set"
		}
		//add query to populate tools list with non-paginated snap-shot
		snapshotMaps = getAllListsNoPagination(user,sharedIds)
		pagedLists["snapshot"] = snapshotMaps
		return pagedLists
	}

	def getAllListsNoPagination(userId,sharedIds){
		def user = GDOCUser.findByUsername(userId)
		def pagedLists = []
		def pagedListsMaps = []
		if(sharedIds){
			def ids =[]
			sharedIds.each{
				ids << new Long(it)
			}
			pagedLists = UserList.createCriteria().list()
				{
					projections{
						property('id')
						property('name')
					}
					and{
						'order'("dateCreated", "desc")
					}
					or {
						eq("author", user)
						'in'('id',ids)
					}
				}
		}
		else {
			pagedLists = UserList.createCriteria().list()
				{
					projections{
						property('id')
						property('name')
					}
					and{
						'order'("dateCreated", "desc")
					}
					or {
						eq("author", user)
					}
				}
		}
		pagedLists.each{
			def pagedListsMap = [:]
			pagedListsMap["id"] = it[0]
			pagedListsMap["name"] = it[1]
			pagedListsMaps << pagedListsMap
		}
		//log.debug "all lists snapsot -> $pagedListsMaps "
		return pagedListsMaps
	}

	def getUsersListsByTimePeriod(timePeriod,offset,user) {
		def pagedLists = [:]
		def results = []
		def snapshots = []
		def snapshotMaps = []
		def count = 0
		def now = new Date()
		def tp = Integer.parseInt(timePeriod)
		def range = now-tp
		String listHQL = "SELECT distinct list FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username " +
		"AND list.dateCreated BETWEEN :range and :now " +
		"ORDER BY list.dateCreated desc"
		results = UserList.executeQuery(listHQL,[username:user, now:now, range:range, max:2000, offset:offset])
		pagedLists["results"] = results
		String listHQL2 = "SELECT count(distinct list.id) FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username " +
		"AND list.dateCreated BETWEEN :range and :now "
		count = UserList.executeQuery(listHQL2,[username:user, now:now, range:range])
		pagedLists["count"] = count
		//add query to populate tools list with non-paginated snap-shot
		String listHQL3 = "SELECT distinct list.id, list.name, list.dateCreated FROM UserList list JOIN list.author author " +
		"WHERE author.username = :username " +
		"AND list.dateCreated BETWEEN :range and :now " +
		"ORDER BY list.dateCreated desc"
		snapshots = UserList.executeQuery(listHQL3,[username:user, now:now, range:range])
		if(snapshots){
			snapshots.each{
				def snapMap = [:]
				snapMap["id"] = it[0]
				snapMap["name"] = it[1]
				snapshotMaps << snapMap
			}
		}
		pagedLists["snapshot"] = snapshotMaps
		log.debug "user lists only over past $timePeriod days-> $pagedLists as Paged set"
		return pagedLists
	}

	def filterByFindingsLists(offset){
		def pagedLists = [:]
		def results = []
		def snapshots = []
		def snapshotMaps = []
		def count = 0
		def listHQL = "SELECT distinct list FROM UserList list,Evidence evidence " +
		"WHERE list.id = evidence.userList " +
		"ORDER BY list.dateCreated desc"
	    results = UserList.executeQuery(listHQL, [max:2000, offset:offset])
		pagedLists["results"] = results
		def listCountHQL = "SELECT count(distinct list.id) FROM UserList list,Evidence evidence " +
		"WHERE list.id = evidence.userList "
		count = UserList.executeQuery(listCountHQL)
		pagedLists["count"] = count
		//add query to populate tools list with non-paginated snap-shot
		String listHQL3 = "SELECT distinct list.id, list.name, list.dateCreated FROM UserList list,Evidence evidence " +
		"WHERE list.id = evidence.userList " +
		"ORDER BY list.dateCreated desc"
		snapshots = UserList.executeQuery(listHQL3)
		if(snapshots){
			snapshots.each{
				def snapMap = [:]
				snapMap["id"] = it[0]
				snapMap["name"] = it[1]
				snapshotMaps << snapMap
			}
		}
		pagedLists["snapshot"] = snapshotMaps
		log.debug "findings-based user lists returned"
		return pagedLists
	}

	def filterByType(tag,sharedIds, userName,offset){
		def pagedLists = [:]
		def ids = []
		def results = []
		def snapshots = []
		def snapshotMaps = []
		def count = 0
		if(sharedIds){
			sharedIds.each{
				ids << new Long(it)
			}
		}
		if(ids){
			def listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " +
			"AND tagLink.tag.name = :tag " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL, [tag: tag, ids:ids, username: userName,max:2000, offset:offset])
			pagedLists["results"] = results
			def listCountHQL = "SELECT count(distinct list.id) FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " +
			"AND tagLink.tag.name = :tag "
			count = UserList.executeQuery(listCountHQL,[tag: tag, ids:ids, username: userName])
			pagedLists["count"] = count
			//add query to populate tools list with non-paginated snap-shot
			def listHQL3 = "SELECT distinct list.id, list.name, list.dateCreated FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " +
			"AND tagLink.tag.name = :tag "+
			"ORDER BY list.dateCreated desc"
			snapshots = UserList.executeQuery(listHQL3,[tag: tag, ids:ids,username:userName])
			if(snapshots){
				snapshots.each{
					def snapMap = [:]
					snapMap["id"] = it[0]
					snapMap["name"] = it[1]
					snapshotMaps << snapMap
				}
			}
			pagedLists["snapshot"] = snapshotMaps
			log.debug "paged lists $pagedLists"
		}
		else{
			def listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND tagLink.tag.name = :tag " +
			"AND author.username = :username " +
			"ORDER BY list.dateCreated desc"
			results = UserList.executeQuery(listHQL, [tag: tag, username: userName,max:2000, offset:offset])
			pagedLists["results"] = results
			def listCountHQL = "SELECT count(distinct list.id) FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND author.username = :username " +
			"AND tagLink.tag.name = :tag"
			count = UserList.executeQuery(listCountHQL,[tag: tag, username: userName])
			pagedLists["count"] = count
			//add query to populate tools list with non-paginated snap-shot
			def listHQL3 = "SELECT distinct list.id, list.name, list.dateCreated FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND author.username = :username " +
			"AND tagLink.tag.name = :tag "+
			"ORDER BY list.dateCreated desc"
			snapshots = UserList.executeQuery(listHQL3,[tag: tag, username:userName])
			if(snapshots){
				snapshots.each{
					def snapMap = [:]
					snapMap["id"] = it[0]
					snapMap["name"] = it[1]
					snapshotMaps << snapMap
				}
			}
			pagedLists["snapshot"] = snapshotMaps
		}
		return pagedLists
	}

	def newListsAvailable(sharedIds, lastLogin,userName){
		def count = 0
		def ids = []
		if(sharedIds){
			sharedIds.each{
				ids << new Long(it)
			}
			String listHQL
			if(ids){
				listHQL = "SELECT count(distinct list.id) FROM UserList list JOIN list.author author  " +
				"WHERE list.dateCreated >= :lastLogin " +
				"AND author.username != :username " +
				"AND list.id IN (:ids) "
				count = UserList.executeQuery(listHQL,[ids:ids, lastLogin: lastLogin,username: userName])
				return count[0]
			}
		}
		else{
			log.debug "no new shared lists"
			return count
		}
		return count
	}

	def getListsByTag(tag,sharedIds, userName){
		def ids = []
		def taggedLists = []
		def pagedLists = [:]
		if(sharedIds){
			sharedIds.each{
				ids << new Long(it)
			}
		}
		String listHQL
		if(ids){
			listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND (author.username = :username " +
			"OR list.id IN (:ids)) " +
			"AND tagLink.tag.name = :tag " +
			"ORDER BY list.dateCreated desc"
			taggedLists = UserList.executeQuery(listHQL, [tag: tag, ids:ids, username: userName])
		}
		else{
			listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.author author " +
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND tagLink.tag.name = :tag " +
			"AND author.username = :username " +
			"ORDER BY list.dateCreated desc"
			taggedLists = UserList.executeQuery(listHQL, [tag: tag, username: userName])
		}
		return taggedLists
	}
	
	def getListsByTagAndStudy(tag,study,sharedIds,userName){
		def sids =[]
		def ids = []
		def patientLists = [] 
		sids << study
		if(sharedIds){
			sharedIds.each{
				ids << new Long(it)
			}
		}
		String listHQL
		if(ids){
			listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.studies studies " + 
			"WHERE list.id = tagLink.tagRef AND tagLink.type = 'userList' " +
			"AND tagLink.tag.name = :tag " +
			"AND (list.author.username = :username " +
			"OR list.id IN (:ids)) " + 
			"AND studies IN (:sids) " + 
			"ORDER BY list.dateCreated desc"
			patientLists = UserList.executeQuery(listHQL, [tag: tag, username: userName, ids:ids, sids:sids])
		}else{
			listHQL = "SELECT distinct list FROM UserList list,TagLink tagLink JOIN list.studies studies " + 
			"WHERE list.id = tagLink.tagRef	AND tagLink.type = 'userList' " +
			"AND tagLink.tag.name = :tag " +
			"AND list.author.username = :username " +
			"AND studies IN (:sids) " + 
			"ORDER BY list.dateCreated desc"
			patientLists = UserList.executeQuery(listHQL, [tag: tag, username: userName, sids:sids])
		}
		return patientLists
		
	}
	
	def getTempListIds(userId) {
		String findByTagHQL = """
		   SELECT DISTINCT list.id
		   FROM UserList list, TagLink tagLink
		   JOIN list.author author
		   WHERE list.id = tagLink.tagRef
		   AND author.username = :username
		   AND tagLink.type = 'userList'
		   AND tagLink.tag.name = :tag
		"""
		
		def listIds = UserList.executeQuery(findByTagHQL, [tag: Constants.TEMPORARY, username: userId])
		return listIds	
	}
	
	def getSharedListIds(userId,refresh){
		log.debug "get $userId shared lists"
		def sharedListIds = []
		sharedListIds = securityService.getSharedItemIds(userId, UserList.class.name,refresh)
		return sharedListIds
	}
	
	def uniteLists(name,author,ids){
		return performOperation(name, author, ids, { items, list ->
			items.addAll(list.listItems.collect{it.value})
		})
	}
	
	def diffLists(name,author,ids){
		return performOperation(name, author, ids, { items, list ->
			def tempItems = list.listItems.collect{it.value}
			tempItems.removeAll(items)
			
			def tempIntersection = list.listItems.collect{it.value}
			tempIntersection.retainAll(items)
			
			items.removeAll(tempIntersection)
			items.addAll(tempItems)
		})
	}
	
	def intersectLists(name,author,ids){ 
		return performOperation(name, author, ids, { items, list ->
			items.retainAll(list.listItems.collect{it.value})
		})
	}
	
	def performOperation(name, author, ids, strategy) {
		Set<String> unitedTags = []
		Set unitedStudies = []
		def items = new ArrayList<String>();
        ids.each{
            UserList list = UserList.get(it);
            if(!list.listItems.isEmpty()){
				if(items.isEmpty())
					items.addAll(list.listItems.collect{it.value})
				else 
					strategy(items, list)
            }
			if(list.tags){
				list.tags.each{ tag ->
					tag = tag.trim()
					def clTag = tag.stripIndent()
					if(clTag != Constants.TEMPORARY){
						unitedTags << clTag
					}
				}
			}
			list.studies.each {
				unitedStudies << it.schemaName
			}
        }
	    Set<String> unitedSet = new HashSet<String>(items);
		if(unitedSet.isEmpty()){
			return null
		}else{
			def userList = createList(author, name, unitedSet, unitedStudies, unitedTags)
			return userList
		}
	}
	
	
def gatherTags(ids){
	Set<String> unitedTags = []
	ids.each{
	      UserList list = UserList.get(it);
			if(list.tags){
				list.tags.each{ tag ->
					unitedTags << tag
				}
			}
	}
	return unitedTags as List
}

def validListName(listName){
	def invalidChars = ['"','<','%','>',';']
	def listAsChars = listName.toList()
	def invalidFound = listAsChars.find{
		invalidChars.contains(it)
	}
	if(!(listName.trim()) || invalidFound){
		return false
	}
	else{
		return true
	}
}


def createList(userName, listName, listItems, studies, tags) {
		def author = GDOCUser.findByUsername(userName)
		def listDup = author.lists.find {
			it.name == listName
		}
		if(listDup) {
			return [error: "List with name $listName already exists."]
		}
		if(!validListName(listName)){
			return [error: "List did  not save, invalid characters were found in name, $listName. Please try again."]
		}
		def userListInstance = new UserList()
		userListInstance.name = listName
		userListInstance.author = author
		listItems.each {
			if(it){
				userListInstance.addToListItems(new UserListItem(value:it));
			}
		}
		log.debug "associate with these studies $studies"
		studies.each {
			if(it){
				def ds = Study.findBySchemaName(it)
				userListInstance.addToStudies(ds)
			}
		}
		if(!userListInstance.hasErrors() && userListInstance.save()) {
			tags.each {
				userListInstance.addTag(it)
			}
			return [success: "UserList ${userListInstance.name} created successfully."]
		} else {
			return [error: "Error creating UserList ${userListInstance.name}."]
		}
	}
	
	
	def createAndReturnList(userName, listName, listItems, studies, tags) {
			def author = GDOCUser.findByUsername(userName)
			def listDup = author.lists.find {
				it.name == listName
			}
			if(listDup) {
				return [error: "List with name $listName already exists."]
			}
			def userListInstance = new UserList()
			userListInstance.name = listName
			userListInstance.author = author
			listItems.each {
				if(it){
					userListInstance.addToListItems(new UserListItem(value:it));
				}
			}
			studies.each {
				if(it){
					def ds = Study.findBySchemaName(it)
					userListInstance.addToStudies(ds)
				}
			}
			if(!userListInstance.hasErrors() && userListInstance.save()) {
				tags.each {
					//log.debug "add tag, $it"
					userListInstance.addTag(it)
				}
				log.debug "UserList ${userListInstance.name} created successfully."
				return userListInstance
			} else {
				log.debug "Error creating UserList ${userListInstance.name}."
				return null
			}
		}
	
	/**util method that finds metadata about list items for display purposes
	REFACTOR & move to mol target to test if molecule-target-plugin exists
	**/
def decorateListItems(userList){
	def metadata = [:]
	def compiledMetadata = [:]
	metadata = extensionService.addListItemMetadata(userList)
	metadata.each{key, value->
		log.debug key +"--"+value
		value.each{k,v->
			if(v){
				//log.debug v
				if(!compiledMetadata || !compiledMetadata[value]){
					//compiledMetadata[value] = 
				}
			}
		}
		
	}
	return metadata
}
	
def listIsTemporary(listId,author){
	log.debug "find if $listId is temporary"
	def compList = UserList.get(listId)
	if(compList && compList.tags?.contains(Constants.TEMPORARY)){
		return true
	}
	else{
		return false
	}
	return false
}	

	def doListsOverlap(listIdOne, listIdTwo) {
		def one = UserList.get(listIdOne) 
		def two = UserList.get(listIdTwo)
		def itemsOne = one.listItems.collect { it.value }
		def itemsTwo = two.listItems.collect { it.value }
		itemsOne.retainAll(itemsTwo)
		log.debug("ITEMS: ${itemsOne}")
		return !itemsOne.isEmpty()
	}

	def checkGroupSizes(groupsIds, dataFile) {
		def groupHash = [:]
		def allIds = idService.sampleIdsForFile(dataFile)
		groupsIds.each { groupId ->
			def samples = idService.samplesForListId(groupId)
			samples = allIds.intersect(samples)
			groupHash[groupId] = samples.size
		}
		
		return groupHash
	}
	
	def getListNameForId(listId) {
		def list = UserList.get(listId)
		if(list){
			return list.name
		}else{
			return null
		}
		
	}
	
	def findByNameAndUserId(listName, userId) {
		def listHQL = "SELECT distinct list.id FROM UserList list JOIN list.author author  " + 
		"WHERE author.username = :userId  and name = :listName"
		println "LISTNAME: $listName $userId"
		def id = UserList.executeQuery(listHQL,[userId: userId, listName: listName])
		println "ID: $id"
		if(!id[0])
			return -1
		else
			return id[0]
	}
	
	def isDuplicateList(userId, listId, listName){
		def name = listName.trim()
		def listIds = []
		def listHQL
		listHQL = "SELECT distinct list.id FROM UserList list JOIN list.author author " + 
		"WHERE author.username = :username and list.name = :name"
		listIds = UserList.executeQuery(listHQL,[username:userId, name:name])
		if(listIds.size() == 1){
			log.debug "found listIds="+listIds[0]
			if(listIds[0] == listId.toLong()){
				log.debug "assert same list"
				return false
			}
			else{
				log.debug "list name already exists"
				return true
			}
		}
		log.debug "list exists by that name, naming can continue"
		return false
	}
}