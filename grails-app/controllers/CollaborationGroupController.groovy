

class CollaborationGroupController {
    def securityService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		//params.sort = "name"
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
				if(params.artifacts){
					
				}else{
					log.debug "this currently has associations, but the update includes none, so deletions need to be made"
					securityService.deleteAllGroupArtifacts(collaborationGroupInstance.id, CollaborationGroup.class.name)		
				}
			}
			else{
				if(params.artifacts){
					log.debug "this group doesn't currently have associations, but the update includes them, so additions need to be made"
					
				}
				else{
					log.debug "no existing associations and no associations have been added"
				}
			}
			
            collaborationGroupInstance.properties = params
			collaborationGroupInstance.validate()
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
		def collaborationGroupInstance = new CollaborationGroup(params)
		collaborationGroupInstance.validate()
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
