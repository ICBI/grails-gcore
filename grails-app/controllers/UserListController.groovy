import grails.converters.*
import grails.orm.PagedResultList

@Mixin(ControllerMixin)
class UserListController {
	private static Integer MAX_LIST_SIZE = 2000
    def securityService
	def userListService
	def exportService
	def annotationService
	def vennService
	def searchableService
	def tagService
	def htDataService
	
    def index = { 
		redirect(action:'list',params:params) 
		
	}

    def list = {
		log.debug params
		def lists = []
		//removed : 1:"-1 day",7:"-1 week",
		def timePeriods = [
			hideShared: message(code:"userList.filterMy"),
			search: message(code:"userList.searchMy"),
			my_gene: message(code:"userList.filterGene"),
			my_reporter: message(code:"userList.filterReporter"),
			my_patient: message(code:"userList.filterPatient"),
			30: message(code:"userList.filter30"),
			90: message(code:"userList.filter90"),
			180: message(code:"userList.filter6months"),
			all: message(code:"userList.filterAll"),
			gene: message(code:"userList.filterAllGene"),
			reporter: message(code:"userList.filterAllReporter"),
			patient: message(code:"userList.filterAllPatient"),
			onlyShared: message(code:"userList.filterShared"),
			findings: message(code:"userList.filterFindings")]
		def filteredLists = []
		def searchTerm = params.searchTerm
		def pagedLists = []
			if(params.listFilter){
				session.listFilter = params.listFilter
			}
			else if (session.listFilter){
				log.debug "current session list filter is $session.listFilter"
			}else{
				session.listFilter = "all"
			}
			if(params.offset){
				pagedLists = userListService.getPaginatedLists(session.listFilter,session.sharedListIds,params.offset.toInteger(),session.userId,searchTerm)
			}
			else{
				pagedLists = userListService.getPaginatedLists(session.listFilter,session.sharedListIds,0,session.userId,searchTerm)	
			}
		def listSnapShots = []
		listSnapShots = pagedLists["snapshot"]//userListService.getAllListsNoPagination(session.userId,session.sharedListIds)
		def allLists
		if(pagedLists["count"] && pagedLists["count"][0]){
			allLists = pagedLists["count"][0]
		}
		else{
			allLists = 0;
		}
       [ userListInstanceList: pagedLists["results"], allLists: allLists, timePeriods: timePeriods, toolsLists:listSnapShots]
    }

	def checkName(name){
		def listName
		if(name){
			listName = name
		}else{
			listName = "list_"+System.currentTimeMillis().toString()
		}
		return listName
	}
	
	def addTag = {
		log.debug params
		if(params.id && params.tag){
			def list = tagService.addTag(UserList.class.name,params.id,params.tag.trim())
			if(list){
				render list.tags
			}
			else{
				render ""
			}
		}
	}
	
	def removeTag = {
		log.debug params
		if(isListAuthor(params.id)){
			if(params.id && params.tag){
				def list = tagService.removeTag(UserList.class.name,params.id,params.tag.trim())
				if(list){
					render list.tags
				}
				else{
					render ""
				}
			}
		}
		else{
			log.debug "user is NOT permitted to remove tag from list"
			redirect(controller:policies,action:deniedAccess)
		}
	}
	
	def venn = {
		log.debug params
		def author = GDOCUser.findByUsername(session.userId)
		def sortedLists = []
		def unitedStudies = []
		def allListsNames = []
		sortedLists = vennService.organizeVennLists(params.ids)
		def tags = userListService.gatherTags(params.ids)
		def tagsString = tags.toString()
		tagsString = tagsString.replace("[","")
		tagsString = tagsString.replace("]","")
		//if this is a patient list, set study
		sortedLists.each{
			allListsNames << it.name
			
		}
		if(tags && tags.contains(Constants.PATIENT_LIST)){
			sortedLists.each{ list ->
				if(list.studies){
					list.studies.each{
						unitedStudies << it.schemaName
					}
				 }
			}
			if(unitedStudies){
				StudyContext.setStudy(unitedStudies[0])
				loadCurrentStudy(); 
			}
		}
		else{
			log.debug "this is not a patient list, set study context to null"
			StudyContext.clear()
			session.study = null
		}
		def results
		if(sortedLists.size() == 2){
			results = vennService.createIntersection2ListDictionary(sortedLists)
		}
		else if(sortedLists.size() == 3){
			results = vennService.createIntersection3ListDictionary(sortedLists)
		}
		else if(sortedLists.size() == 4){
			results = vennService.createIntersection4ListDictionary(sortedLists)
		}
		session.results = null
		def names = results.dictionary["names"]
		[dictionary:results.dictionary as JSON,compartments:names as JSON,vennNumbers:results.vennData,graphData:results.graphData,allListsNames:allListsNames as JSON,tags: tagsString]
	}
	
	def vennDiagram = {
		log.debug params
		def author = GDOCUser.findByUsername(params.author)
		def vennJSON = vennService.vennDiagram(params.listName,author,params.ids);
		def tags = userListService.gatherTags(params.ids)
		def tagsString = tags.toString()
		tagsString = tagsString.replace("[","")
		tagsString = tagsString.replace("]","")
		def parsedJSON = JSON.parse(vennJSON.toString());
		log.debug vennJSON
		flash.message = null
		def intersectedIds = parsedJSON
		//intersectedIds: intersectedIds, 
		[ vennJSON: vennJSON, tags: tagsString]
	}

	def tools = {
		def ids = []
		def listName = checkName(params.listName)
		if(params.listAction == 'intersect' ||
			params.listAction == 'join' || 
				params.listAction == 'diff'){
			def author = GDOCUser.findByUsername(session.userId)
			def listDup = author.lists.find {
						it.name == listName
			}
			if(listDup) {
				log.debug "List did  not save, $listName already exists as a list"
				flash.error = message(code: "userList.listDidNotSave", args: [listName])
				redirect(action:list)
				return
			}
			if(!userListService.validListName(listName)){
				log.debug "List did  not save, invalid characters were found in name, $listName"
				flash.error = message(code: "userList.invalidChar", args: [listName])
				redirect(action:list)
				return
			}
		}
		if (params.userListIds && params.listAction){
			params.userListIds.each{
				ids.add(it)
			}
			def userListInstance
			def tags
			if(params.listAction == 'intersect'){
				userListInstance = userListService.intersectLists(listName,session.userId,ids);
			}else if(params.listAction == 'join'){
				userListInstance = userListService.uniteLists(listName,session.userId,ids);
			}else if(params.listAction == 'diff'){
				userListInstance = userListService.diffLists(listName,session.userId,ids);
			}else if(params.listAction == 'venn'){
					redirect(action:"venn",params:[listName:listName,author:session.userId,ids:ids])
					return
			}
			if(userListInstance){
				flash.message = message(code: "userList.created", args: [listName])
				session.listFilter = "hideShared"
				session.results = null
				redirect(action:list)
			}else{
				flash.error = message(code: "userList.notCreated")
				redirect(action:list)
			}
		}else{
			log.debug "no lists have been selected"
			flash.error = message(code: "userList.noSelected")
			redirect(action:list)
		}
	}

    def deleteList = {
		if(isListAuthor(params.id)){
			log.debug "user is permitted to delete list"
			userListService.deleteList(params.id)
			redirect(action:list)
		}
		else{
			log.debug "user is NOT permitted to delete list"
			redirect(controller:'policies',action:'deniedAccess')
		}
    }

	

	def deleteMultipleLists ={
		def delmessage = ""
		if(params.deleteList){
			log.debug "Requesting deletion of: $params.deleteList"
			if(params.deleteList.metaClass.respondsTo(params.deleteList, "max")){
				for(String listIdToBeRemoved : params.deleteList){
					print listIdToBeRemoved + " "
					def userListInstance = UserList.get(listIdToBeRemoved)
			        if(userListInstance) {
			            if(userListInstance.evidence){
							log.debug "could not delete " + userListInstance + ", this link represents a piece of evidence in a G-DOC finding"
							delmessage += message(code: "userList.finding", args: [userListInstance.name, g.appTitle()])
						}
						else if(userListInstance.author.username != session.userId){
							log.debug "did not delete " + userListInstance + ", you are not the author."
							delmessage += message(code: "userList.notAuthor", args: [userListInstance.id])
						}
						else{
			            	userListService.deleteList(userListInstance.id)
							log.debug "deleted " + userListInstance
							delmessage += message(code: "userList.deleted", args:[userListInstance.name])
						}
					}
				}
			}else{
				def userListInstance = UserList.get(params.deleteList)
		        if(userListInstance) {
					if(userListInstance.evidence){
						log.debug "could not delete " + userListInstance + ", this link represents a piece of evidence in a G-DOC finding"
						delmessage = message(code: "userList.finding", args: [userListInstance.name, g.appTitle()])
					}
					else if(userListInstance.author.username != session.userId){
						log.debug "did not delete " + userListInstance + ", you are not the author."
						delmessage += message(code: "userList.notAuthor", args: [userListInstance.id])
					}
					else{
		            	userListService.deleteList(userListInstance.id)
						log.debug "deleted " + userListInstance
						delmessage = message(code: "userList.deleted", args:[userListInstance.name])
					}
				}
			}
			flash.message = delmessage
			redirect(action:list)
			return
		}else{
			flash.message = message(code: "userList.noSelectionDelete")
			redirect(action:list)
			return
		}
		
	}

	def deleteListItem = {
		log.debug params
        def userListItemInstance = UserListItem.findById(params["id"])
        if(userListItemInstance) {
			def list = UserList.findById(userListItemInstance.list.id)
			if(list.author.username == session.userId){
				list.listItems.remove(userListItemInstance);
				userListItemInstance.delete(flush:true)	
	            list.save();
				render(template:"/userList/userListDiv",model:[ userListInstance: list, listItems:list.listItems ], plugin: "gcore")
			}
			else {
	            flash.message = message(code: "userList.notFound", args: [params.id])
				redirect(action:list)
	        }
        }
        
    }

	def getListItems = {
		log.debug params
		def userListInstance = UserList.get( params.id )
		def metadata = [:]
		//REFACTOR and check if molecule-tatget plugin exists
		metadata = userListService.decorateListItems(userListInstance)
		if(userListInstance) {
			def listItems = userListInstance.listItems
			listItems = listItems.sort{it.value}
			render(template:"/userList/userListDiv",model:[ userListInstance: userListInstance, listItems:listItems, metadata:metadata], plugin: "gcore")
        }
        else {
            flash.message = message(code: "userList.notFound2", args: [params.id])
			redirect(action:list)
        }
    }


    def saveFromQuery = {
		log.debug params
		def author = GDOCUser.findByUsername(session.userId)
		if(!params["name"]){
			def usname = "list" +  new Date().getTime()
			params["name"] = usname
		}
		
		params["author.id"] = author.id
		def listDup = author.lists.find {
			it.name == params["name"]
		}
		if(listDup) {
			render message(code: "userList.exists", args: [params.name])
			return
		}
		if(!userListService.validListName(params["name"])){
			render message(code: "userList.invalidChar", args: [params.name])
			return
		}
		log.debug "save list"
		def ids = new HashSet();
		if(params.selectAll == "true") {
			log.debug "save all ids as Set"
			def tags = params.tags.split(",").toList()
			//if patient list, save all gdocIds straight from result
			if(tags.contains("patient")) {
				session.results.each {
					ids << it.gdocId
				}
				
			}
			
			//if gene symbol list, look up gene symbols from reporters straight from result
			else if(tags.contains("gene")){
				if(session.results){
						session.resultTable.each{ row ->
							ids << row.geneName
						}
				}
			}
			//if reporters list, save reporters straight from result
			else{
				if(session.results){
					session.results.resultEntries.each{ ccEntry ->
						ids << ccEntry.reporterId
					}
				}
			}
			if(ids.size() > MAX_LIST_SIZE) {
				render message(code: "userList.maxSize", args: [MAX_LIST_SIZE])
				return
			}
		} else if(params['ids']){
			log.debug "just save selected ids as Set"
			params['ids'].tokenize(",").each{
				it = it.replace('[','');
				it = it.replace(']','');
				//if gene symbols list, look up gene symbols from reporters (ids)
				def tags = params.tags.split(",").toList()
				if(tags && tags.contains("gene")){
					log.debug "contains gene"
					if(session.results && session.results.resultEntries){
						session.results.resultEntries.each{ ccEntry ->
							if(it.trim() == ccEntry.reporterId){
								def geneSymbol = annotationService.findGeneForReporter(ccEntry.reporterId)
								if(geneSymbol){
									ids << geneSymbol.trim()
								}
							}
						}
					}else{
						ids << it.trim()
					}
				}else{
					//or just save the value of the id itself, after it has been cleaned up
					ids << it.trim()
				}
				
			}
		}
		def tags = []
		if(params["tags"]){
			params['tags'].tokenize(",").each{ tag->
				tag = tag.trim()
				def clTag = tag.stripIndent()
				if(clTag != Constants.TEMPORARY){
					tags << clTag
				}
			}
		}
		def userListInstance = userListService.createList(session.userId, params.name, ids, [StudyContext.getStudy()], tags)
        if(userListInstance){
			render message(code: "userList.success", args: [params.name])
		}
		else {
			render message(code: "userList.error", args: [params.name])
        }
    }

	def saveListFromExistingLists = {
		log.debug params
		def author = GDOCUser.findByUsername(session.userId)
		if(!params["name"]){
			params["name"] = author.username + new Date().getTime();
		}
		
		params["author.id"] = author.id
		def listDup = author.lists.find {
			it.name == params["name"]
		}
		if(listDup) {
			render message(code: "userList.exists", args: [params.name])
			return
		}
		if(!userListService.validListName(params["name"])){
			render  message(code: "userList.invalidChar", args: [params.name])
			return
		}
		def ids = new HashSet();
		if(params['ids']){
			params['ids'].tokenize(",").each{
				it = it.replace('[','');
				it = it.replace(']','');
				// just save the value of the id itself, after it has been cleaned up
					ids << it.trim()
			}
		}
		def tags = []
		if(params["tags"]){
			params['tags'].tokenize(",").each{
				tags << it
			}
		}
		def studies = new HashSet<String>()
		if(params["studies"]){
			params['studies'].tokenize(",").each{
				it = it.replace('[','');
				it = it.replace(']','');
				studies << it
			}
		}else{
			studies << StudyContext.getStudy()
		}
		def userListInstance = userListService.createList(session.userId, params.name, ids, studies , tags)
        if(userListInstance) {
				render message(code: "userList.success", args: [params.name])
        } else {
				render message(code: "userList.error", args: [params.name])
        }
	}

	def save = {
		def ids = new HashSet();
		if(params["ids"]){
			params['ids'].each{
				ids << it.trim()
			}
		}
		if(ids.size() > MAX_LIST_SIZE) {
			flash.message = message(code: "userList.maxSize2", args: [MAX_LIST_SIZE])
			return
		}
		if(!userListService.validListName(params["name"])){
			render  message(code: "userList.invalidChar", args: [params.name])
			return
		}
		def userListInstance = userListService.createList(session.userId, params.name, ids, [StudyContext.getStudy()], [])
		 if(userListInstance) {
			flash.message = message(code: "userList.success", args: [params.name])
	            	redirect(action:show,id:userListInstance.id)
	        }
	        else {
				render(view:'create',model:[userListInstance:userListInstance])
	     }
		
	}
	
	def createFromKm = {
		def ids = request.JSON['ids']
		def tags = request.JSON['tags']
		def studies = []
		studies << StudyContext.getStudy()
		def name = request.JSON['name']
		def returnVal = userListService.createList(session.userId, name, ids, studies, tags)
		render returnVal as JSON
	}	
	
	def upload = {
		
	}
	
	def listModify = {}
	
	def renameList = { RenameListCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			log.debug cmd.errors
			redirect(action:'listModify')
			return
		}
		else{
			flash['cmd'] = cmd
			if(isListAccessible(cmd.id)){
				log.debug "rename list: "+params
				if(cmd.newName && cmd.id){
					def author = GDOCUser.findByUsername(session.userId)
					def listDup = author.lists.find {
						it.name == cmd.newName.trim()
					}
					if(listDup) {
						log.debug "List not saved. $cmd.newName already exists"
						flash.error = message(code: "userList.rename", args: [cmd.newName])
						redirect(action:'listModify')
						return
					}else{
						flash['cmd'] = cmd
						def userListInstance = UserList.get(cmd.id)
						userListInstance.name = cmd.newName.trim()
						if(userListInstance.save()){
							flash.message = message(code: "userList.updated", args: [cmd.id, cmd.newName])
							redirect(action:'listModify')
							return
						}
					}
				}
			}
			else{
				log.debug "user is NOT permitted to rename list"
				redirect(controller:'policies',action:'deniedAccess')
				return
			}
		}
		
		
	}
	
	
	def saveList = {
		//TODO: Validate list
		if(!params.listName){
			log.debug "List needs to be named"
			flash["message"]= message(code: "userList.pleaseName")
			redirect(action:upload,params:[failure:true])
			return
		}
		if(!request.getFile("file").inputStream.text){
			log.debug "List needs a file associated with it"
			flash["message"]= message(code: "userList.selectFile")
			redirect(action:upload,params:[failure:true])
			return
		}
		
		if(request.getFile("file").inputStream.text) {
			log.debug "upload list: $params.listName"
			def author = GDOCUser.findByUsername(session.userId)
			def listDup = author.lists.find {
				it.name == params["listName"]
			}
			if(request.getFile("file").getOriginalFilename().lastIndexOf(".txt") == -1){
				log.debug "List $params.listName needs to be formatted as plain-text .txt file"
				flash["message"]= message(code: "userList.textFile", args: [params.listName])
				redirect(action:upload,params:[failure:true])
				return
			}
			
			
			if(listDup) {
				log.debug "List $params.listName already exists"
				flash["error"]= message(code: "userList.exists", args: [params.listName])
				redirect(action:upload,params:[failure:true])
				return
			}else if(!userListService.validListName(params["listName"])){
				log.debug "List $params.listName contains invalid characters"
				flash["error"]= message(code: "userList.invalidChar", args: [params.listName])
				redirect(action:upload,params:[failure:true])
				return
			}else{
				def userList = new UserList()
				userList.name = params["listName"]
				userList.author = author 
				def items = new HashSet();
				request.getFile("file").inputStream.eachLine { value ->
					//log.debug value
					if(value.trim())
						items << value.trim()
				}
				items.each{ item->
					if (item =~ /^(\w|@|\'|:|\.|\(|\)|\/|-)+$/ && item.length() <= 255)
						userList.addToListItems(new UserListItem(value:item))
				}
				log.debug "size: " + userList.listItems?.size()
				log.debug "listItems: " + userList.listItems
				if(!userList.listItems) {
					flash.error = "List cannot be empty."
					redirect(action:upload,params:[failure:true])
					return
				}
				if(userList.listItems?.size() > MAX_LIST_SIZE) {
					flash.error = message(code: "userList.maxSize2", args: [MAX_LIST_SIZE])
					redirect(action:upload,params:[failure:true])
					return
				}
	        	if(!userList.hasErrors() && userList.save()) {

						userList.addTag(params["listType"])
						flash["message"] = message(code: "userList.uploadSuccess", args: [params.listName])
						redirect(action:upload,params:[success:true])
						return

		        } else {
					flash["error"] =  message(code: "userList.errorUpload", args: [params.listName])
					redirect(action:upload,params:[failure:true])
					return
		        }
			}
		}
		//redirect(action:upload)
	}
	
	def export = {
		if(isListAccessible(params.id)){
			log.debug "EXPORTING LIST ${params.id}"
			response.setHeader("Content-disposition", "attachment; filename=${params.id}-export.txt")  
			response.contentType = "text/plain"
			exportService.exportList(response.outputStream, params.id)
		}
		else{
			log.debug "user is NOT permitted to export list"
			redirect(controller:'policies',action:'deniedAccess')
			return
		}
	}
	
}
