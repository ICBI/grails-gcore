

class InvitationController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ invitationInstanceList: Invitation.list( params ), invitationInstanceTotal: Invitation.count() ]
    }

    def show = {
        def invitationInstance = Invitation.get( params.id )

        if(!invitationInstance) {
            flash.message = "Invitation not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ invitationInstance : invitationInstance ] }
    }

    def delete = {
        def invitationInstance = Invitation.get( params.id )
        if(invitationInstance) {
            try {
                invitationInstance.delete(flush:true)
                flash.message = "Invitation ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "Invitation ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "Invitation not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def invitationInstance = Invitation.get( params.id )

        if(!invitationInstance) {
            flash.message = "Invitation not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ invitationInstance : invitationInstance ]
        }
    }

    def update = {
        def invitationInstance = Invitation.get( params.id )
        if(invitationInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(invitationInstance.version > version) {
                    
                    invitationInstance.errors.rejectValue("version", "invitation.optimistic.locking.failure", "Another user has updated this Invitation while you were editing.")
                    render(view:'edit',model:[invitationInstance:invitationInstance])
                    return
                }
            }
            invitationInstance.properties = params
            if(!invitationInstance.hasErrors() && invitationInstance.save()) {
                flash.message = "Invitation ${params.id} updated"
                redirect(action:show,id:invitationInstance.id)
            }
            else {
                render(view:'edit',model:[invitationInstance:invitationInstance])
            }
        }
        else {
            flash.message = "Invitation not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def invitationInstance = new Invitation()
        invitationInstance.properties = params
        return ['invitationInstance':invitationInstance]
    }

    def save = {
        def invitationInstance = new Invitation(params)
        if(!invitationInstance.hasErrors() && invitationInstance.save()) {
            flash.message = "Invitation ${invitationInstance.id} created"
            redirect(action:show,id:invitationInstance.id)
        }
        else {
            render(view:'create',model:[invitationInstance:invitationInstance])
        }
    }
}
