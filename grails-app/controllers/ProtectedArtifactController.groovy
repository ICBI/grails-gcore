

class ProtectedArtifactController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 20,  100)
        [ protectedArtifactInstanceList: ProtectedArtifact.list( params ), protectedArtifactInstanceTotal: ProtectedArtifact.count() ]
    }

    def show = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )

        if(!protectedArtifactInstance) {
            flash.message = "ProtectedArtifact not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ protectedArtifactInstance : protectedArtifactInstance ] }
    }

    def delete = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
        if(protectedArtifactInstance) {
            try {
                protectedArtifactInstance.delete(flush:true)
                flash.message = "ProtectedArtifact ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "ProtectedArtifact ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "ProtectedArtifact not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
        if(!protectedArtifactInstance) {
            flash.message = "ProtectedArtifact not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ protectedArtifactInstance : protectedArtifactInstance ]
        }
    }

	//TODO: add association to collaboration group
    def update = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
        if(protectedArtifactInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(protectedArtifactInstance.version > version) {
                    
                    protectedArtifactInstance.errors.rejectValue("version", "protectedArtifact.optimistic.locking.failure", "Another user has updated this ProtectedArtifact while you were editing.")
                    render(view:'edit',model:[protectedArtifactInstance:protectedArtifactInstance])
                    return
                }
            }
            protectedArtifactInstance.properties = params
            if(!protectedArtifactInstance.hasErrors() && protectedArtifactInstance.save()) {
                flash.message = "ProtectedArtifact ${params.id} updated"
                redirect(action:show,id:protectedArtifactInstance.id)
            }
            else {
                render(view:'edit',model:[protectedArtifactInstance:protectedArtifactInstance])
            }
        }
        else {
            flash.message = "ProtectedArtifact not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def protectedArtifactInstance = new ProtectedArtifact()
        protectedArtifactInstance.properties = params
        return ['protectedArtifactInstance':protectedArtifactInstance]
    }

    def save = {
        def protectedArtifactInstance = new ProtectedArtifact(params)
        if(!protectedArtifactInstance.hasErrors() && protectedArtifactInstance.save()) {
            flash.message = "ProtectedArtifact ${protectedArtifactInstance.id} created"
            redirect(action:show,id:protectedArtifactInstance.id)
        }
        else {
            render(view:'create',model:[protectedArtifactInstance:protectedArtifactInstance])
        }
    }
}
