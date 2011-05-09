

class CollaborationGroupController {
    def securityService
	def collaborationGroupService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        //params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		//params.sort = "name"
		if (!params.max) params.max = 10
		if (!params.offset) params.offset = 0
		if (!params.sort) params.sort = "name"
		if (!params.order) params.order = "asc"
		[ collaborationGroupInstanceList: CollaborationGroup.list( params ), collaborationGroupInstanceTotal: CollaborationGroup.count() ]
    }

    def show = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )

        if(!collaborationGroupInstance) {
            flash.message = message(code:"collaborationGroup.groupNotFound", args:[params.id])
            redirect(action:list)
        }
        else { return [ collaborationGroupInstance : collaborationGroupInstance ] }
    }

    def delete = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )
        if(collaborationGroupInstance) {
            try {
                collaborationGroupInstance.delete(flush:true)
                flash.message = message(code:"collaborationGroup.deleted", args:[params.id])
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code:"collaborationGroup.notDeleted", args:[params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code:"collaborationGroup.groupNotFound", args:[params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )
		
        if(!collaborationGroupInstance) {
            flash.message = message(code:"collaborationGroup.groupNotFound", args:[params.id])
            redirect(action:list)
        }
        else {
            return [ collaborationGroupInstance : collaborationGroupInstance ]
        }
    }

    def update = {
		log.debug params
		/**
		-Report adds/deletes to user
		**/
		def deletionNames = []
		def additionNames = []
        def collaborationGroupInstance = CollaborationGroup.get( params.id )
        if(collaborationGroupInstance) {
            if(collaborationGroupInstance.artifacts){
				log.debug "associations exist with $collaborationGroupInstance.artifacts"
				def additions = []
				def deletions = []
				if(!params.artifacts){
					log.debug "this currently has associations, but the update includes none, so deletions need to be made"
					securityService.deleteAllGroupArtifacts(collaborationGroupInstance.id, CollaborationGroup.class.name)		
				}
			}
			if(!collaborationGroupService.validName(params.name)){
				log.debug "Group $params.name contains invalid characters"
				flash["error"]=  message(code:"collaborationGroup.invalidChars", args:[params.name])
				redirect(action:edit,id:collaborationGroupInstance.id)
				return
			}
            collaborationGroupInstance.properties = params
			collaborationGroupInstance.validate()
            if(!collaborationGroupInstance.hasErrors() && collaborationGroupInstance.save()) {
                flash.message = message(code:"collaborationGroup.updated", args:[params.id])
                redirect(action:show,id:collaborationGroupInstance.id)
            }
            else {
                render(view:'edit',model:[collaborationGroupInstance:collaborationGroupInstance])
            }
        }
        else {
            flash.message = message(code:"collaborationGroup.groupNotFound", args:[params.id])
            redirect(action:list)
        }
    }

    def create = {
        def collaborationGroupInstance = new CollaborationGroup()
        collaborationGroupInstance.properties = params
        return ['collaborationGroupInstance':collaborationGroupInstance]
    }

    def save = {
		def collaborationGroupInstance = new CollaborationGroup(params)
		collaborationGroupInstance.validate()
		if(!collaborationGroupService.validName(params.name)){
			log.debug "Group $params.name  contains invalid characters"
			flash["error"]=  message(code:"collaborationGroup.invalidChars", args:[params.name])
			redirect(action:create)
			return
		}
		if(!collaborationGroupInstance.hasErrors()) {
			def newGroup = securityService.createCollaborationGroup(params.owner, params.name, params.description)
			if(newGroup){
				flash.message = message(code:"collaborationGroup.created", args:[newGroup.id])
	            redirect(action:show,id:newGroup.id)
			}
            
        }
        else {
            render(view:'create',model:[collaborationGroupInstance:collaborationGroupInstance])
        }
    }
}
