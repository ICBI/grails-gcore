

class CollaborationGroupController {
    def securityService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		params.sort = "name"
        [ collaborationGroupInstanceList: CollaborationGroup.list( params ), collaborationGroupInstanceTotal: CollaborationGroup.count() ]
    }

    def show = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )

        if(!collaborationGroupInstance) {
            flash.message = "CollaborationGroup not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ collaborationGroupInstance : collaborationGroupInstance ] }
    }

    def delete = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )
        if(collaborationGroupInstance) {
            try {
                collaborationGroupInstance.delete(flush:true)
                flash.message = "CollaborationGroup ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "CollaborationGroup ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "CollaborationGroup not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def collaborationGroupInstance = CollaborationGroup.get( params.id )

        if(!collaborationGroupInstance) {
            flash.message = "CollaborationGroup not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ collaborationGroupInstance : collaborationGroupInstance ]
        }
    }

    def update = {
		if(params.artifacts){
			log.debug "looks like the update includes artifacts, should I add the associated artifacts, $params.artifacts, or do they exist?"
		}
        def collaborationGroupInstance = CollaborationGroup.get( params.id )
        if(collaborationGroupInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(collaborationGroupInstance.version > version) {
                    
                    collaborationGroupInstance.errors.rejectValue("version", "collaborationGroup.optimistic.locking.failure", "Another user has updated this CollaborationGroup while you were editing.")
                    render(view:'edit',model:[collaborationGroupInstance:collaborationGroupInstance])
                    return
                }
            }
            collaborationGroupInstance.properties = params
            if(!collaborationGroupInstance.hasErrors() && collaborationGroupInstance.save()) {
                flash.message = "CollaborationGroup ${params.id} updated"
                redirect(action:show,id:collaborationGroupInstance.id)
            }
            else {
                render(view:'edit',model:[collaborationGroupInstance:collaborationGroupInstance])
            }
        }
        else {
            flash.message = "CollaborationGroup not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def collaborationGroupInstance = new CollaborationGroup()
        collaborationGroupInstance.properties = params
        return ['collaborationGroupInstance':collaborationGroupInstance]
    }

    def save = {
		log.debug params
        def collaborationGroupInstance = new CollaborationGroup(params)
		collaborationGroupInstance.validate()
		log.debug collaborationGroupInstance.validate()
        if(!collaborationGroupInstance.hasErrors()) {
			if(securityService.createCollaborationGroup(params.owner, params.name, params.description)){
				flash.message = "CollaborationGroup ${collaborationGroupInstance.id} created"
	            redirect(action:show,id:collaborationGroupInstance.id)
			}
            
        }
        else {
            render(view:'create',model:[collaborationGroupInstance:collaborationGroupInstance])
        }
    }
}
