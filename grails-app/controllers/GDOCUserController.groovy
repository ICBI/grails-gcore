import grails.converters.*

class GDOCUserController {
    def GDOCUserService
	def securityService
	def searchResults
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    /**def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		//params.sort = "username"
        [ GDOCUserInstanceList: GDOCUser.list( params ), GDOCUserInstanceTotal: GDOCUser.count() ]
    }**/
	

	//future feature
	def list = {
		log.debug params
		def users
		if(params.userId){
			 users = GDOCUser.createCriteria().list()
				{
					projections{
						property('id')
						property('username')
						property('firstName')
						property('lastName')
						property('email')
						property('organization')
					}
					and{
						'order'("username", "asc")
					}
					or {
						eq("username", params.userId)
						ilike("username", "%"+params.userId+"%")
						ilike("lastName", "%"+params.userId+"%")
						ilike("email", "%"+params.userId+"%")
					}
				}
		}else{
			users = GDOCUser.createCriteria().list()
				{
					projections{
						property('id')
						property('username')
						property('firstName')
						property('lastName')
						property('email')
						property('organization')
					}
					and{
						'order'("username", "asc")
					}
				}
		}
		def columns = []
		columns << [index: "id", name: "User ID", sortable: true, width: '70']
		//columns << [index: "dataSourceInternalId", name: "PATIENT ID", sortable: true, width: '70']
		def columnNames = ["username","firstName","lastName","email","organization"]
		def userListings = []
		users.each{
			def userMap = [:]
			userMap["id"] = it[0]
			userMap["username"] = it[1]
			userMap["firstName"] = it[2]
			userMap["lastName"] = it[3]
			userMap["email"] = it[4]
			userMap["organization"] = it[5]
			userListings << userMap
		}
		columnNames.each {
			def column = [:]
			column["index"] = it
			column["name"] = it
			column["width"] = '160'
			column["sortable"] = true
			columns << column
		}
		session.ucolumnJson = columns as JSON
		def sortedColumns = ["User ID"]//, "PATIENT ID"]
		sortedColumns.addAll(columnNames)
		session.uresults = userListings
		session.ucolumns = sortedColumns
		session.ucolumnNames = sortedColumns as JSON
		return users
	}
	
	def viewUsers = {
		searchResults = session.uresults
		def columns = session.ucolumns
		def results = []
		def rows = params.rows.toInteger()
		def currPage = params.page.toInteger()
		def startIndex = ((currPage - 1) * rows)
		def endIndex = (currPage * rows)
		def sortColumn = params.sidx
		if(endIndex > searchResults.size()) {
			endIndex = searchResults.size()
		}
		def sortedResults = searchResults.sort { r1, r2 ->
			def val1 
			def val2
			val1 = r1[sortColumn]
			val2 = r2[sortColumn]
			def comparison
			if(val1 == val2) {
				return 0
			}
			if(params.sord != 'asc') {
				if(val2 == null) {
					return -1
				} else if (val1 == null) {
					return 1
				}
				comparison =  val2.compareTo(val1)
			} else {
				if(val1 == null) {
					return -1
				} else if(val2 == null) {
					return 1
				}
				comparison =  val1.compareTo(val2)
			}
			return comparison
		}
		session.uresults = sortedResults
		sortedResults.getAt(startIndex..<endIndex).each { user ->
			def cells = []
			cells << user.id
			cells << user.username
			cells << user.firstName
			cells << user.lastName
			cells << user.email
			cells << user.organization
			results << [id: user.id, cell: cells]
		}
		//log.debug "results rows:" + results
		def jsonObject = [
			page: currPage,
			total: Math.ceil(searchResults.size() / rows),
			records: searchResults.size(),
			rows:results
		]
		render jsonObject as JSON
	}
	

    def show = {
        def GDOCUserInstance 
		if(params.id){
			GDOCUserInstance = GDOCUser.get( params.id )
		}
		else if(params.username){
			GDOCUserInstance = GDOCUser.findByUsername(params.username)
		}

        if(!GDOCUserInstance) {
            flash.message = message(code:"users.notFoundBoth", args:[params.id, params.username])
            redirect(action:list)
        }
        else { 
			def userMap = GDOCUserService.getOwnedObjects(GDOCUserInstance)
			def userLists = userMap["lists"]
			def userAnalyses = userMap["analyses"]
			return [ GDOCUserInstance : GDOCUserInstance, userLists: userLists, userAnalyses: userAnalyses] 
		}
    }

    def delete = {
        def GDOCUserInstance = GDOCUser.get( params.id )
        if(GDOCUserInstance) {
            try {
				if(securityService.removeUser(params.id)){
                	//GDOCUserInstance.delete(flush:true)
	                flash.message = message(code:"users.deleted", args:[params.id])
	                redirect(action:list)
				}
				else{
					flash.message = message(code:"users.notDeleted", args:[params.id])
	                redirect(action:show,id:params.id)
				}
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code:"users.notDeleted", args:[params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code:"users.notFound", args:[params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def GDOCUserInstance = GDOCUser.get( params.id )

        if(!GDOCUserInstance) {
            flash.message = message(code:"users.notFound", args:[params.id])
            redirect(action:list)
        }
        else {
            return [ GDOCUserInstance : GDOCUserInstance ]
        }
    }

    def update = {
		log.debug params
        def GDOCUserInstance = GDOCUser.get( params.id )
        if(GDOCUserInstance) {
            GDOCUserInstance.properties = params
            if(!GDOCUserInstance.hasErrors() && GDOCUserInstance.save()) {
                flash.message = message(code:"users.updated", args:[params.id])
                redirect(action:show,id:GDOCUserInstance.id)
            }
            else {
                render(view:'edit',model:[GDOCUserInstance:GDOCUserInstance])
            }
        }
        else {
            flash.message = message(code:"users.notFound", args:[params.id])
            redirect(action:list)
        }
    }

    def create = {
        def GDOCUserInstance = new GDOCUser()
        GDOCUserInstance.properties = params
        return ['GDOCUserInstance':GDOCUserInstance]
    }

    def save = {
        def GDOCUserInstance = new GDOCUser(params)
		GDOCUserInstance.validate()
        if(!GDOCUserInstance.hasErrors()) {
			def newUser = securityService.createNewUser(params.username, params.password, params.firstName,params.lastName,params.email,params.organization, params.title, params.department)
			if(newUser){
				flash.message = message(code:"users.created", args:[newUser.id])
				redirect(action:show,id:newUser.id)
			}
			else{
				flash.message = message(code:"users.notCreated")
	            redirect(action:create)
			}
            
        }
        else {
			GDOCUserInstance.errors().each{
				log.debug it
			}
            render(view:'create',model:[GDOCUserInstance:GDOCUserInstance])
        }
    }
}
