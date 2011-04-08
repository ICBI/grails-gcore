

class GDOCUserController {
    def GDOCUserService
	def securityService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		//params.sort = "username"
        [ GDOCUserInstanceList: GDOCUser.list( params ), GDOCUserInstanceTotal: GDOCUser.count() ]
    }

	//future feature
	def searchForUser = {
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
						ne("username","CSM")
					}
					or {
						eq("username", params.userId)
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
						ne("username","CSM")
					}
				}
		}
		return users
	}

    def show = {
        def GDOCUserInstance = GDOCUser.get( params.id )

        if(!GDOCUserInstance) {
            flash.message = "GDOCUser not found with id ${params.id}"
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
	                flash.message = "GDOCUser ${params.id} deleted"
	                redirect(action:list)
				}
				else{
					flash.message = "GDOCUser ${params.id} could not be deleted"
	                redirect(action:show,id:params.id)
				}
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "GDOCUser ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "GDOCUser not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def GDOCUserInstance = GDOCUser.get( params.id )

        if(!GDOCUserInstance) {
            flash.message = "GDOCUser not found with id ${params.id}"
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
            if(params.version) {
                def version = params.version.toLong()
                if(GDOCUserInstance.version > version) {
                    
                    GDOCUserInstance.errors.rejectValue("version", "GDOCUser.optimistic.locking.failure", "Another user has updated this GDOCUser while you were editing.")
                    render(view:'edit',model:[GDOCUserInstance:GDOCUserInstance])
                    return
                }
            }
            GDOCUserInstance.properties = params
            if(!GDOCUserInstance.hasErrors() && GDOCUserInstance.save()) {
                flash.message = "GDOCUser ${params.id} updated"
                redirect(action:show,id:GDOCUserInstance.id)
            }
            else {
                render(view:'edit',model:[GDOCUserInstance:GDOCUserInstance])
            }
        }
        else {
            flash.message = "GDOCUser not found with id ${params.id}"
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
			if(securityService.createNewUser(params.username, params.password, params.firstName,params.lastName,params.email,params.organization, params.title, params.department)){
				flash.message = "GDOCUser ${GDOCUserInstance.id} created"
				redirect(action:show,id:GDOCUserInstance.id)
			}
			else{
				flash.message = "GDOCUser not created"
	            redirect(action:create)
			}
            
        }
        else {
            render(view:'create',model:[GDOCUserInstance:GDOCUserInstance])
        }
    }
}
