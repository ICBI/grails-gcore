

class GDOCUserController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ GDOCUserInstanceList: GDOCUser.list( params ), GDOCUserInstanceTotal: GDOCUser.count() ]
    }

    def show = {
        def GDOCUserInstance = GDOCUser.get( params.id )

        if(!GDOCUserInstance) {
            flash.message = "GDOCUser not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ GDOCUserInstance : GDOCUserInstance ] }
    }

    def delete = {
        def GDOCUserInstance = GDOCUser.get( params.id )
        if(GDOCUserInstance) {
            try {
                GDOCUserInstance.delete(flush:true)
                flash.message = "GDOCUser ${params.id} deleted"
                redirect(action:list)
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
        if(!GDOCUserInstance.hasErrors() && GDOCUserInstance.save()) {
            flash.message = "GDOCUser ${GDOCUserInstance.id} created"
            redirect(action:show,id:GDOCUserInstance.id)
        }
        else {
            render(view:'create',model:[GDOCUserInstance:GDOCUserInstance])
        }
    }
}
