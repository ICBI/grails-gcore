

class RoleController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ roleInstanceList: Role.list( params ), roleInstanceTotal: Role.count() ]
    }

    def show = {
        def roleInstance = Role.get( params.id )

        if(!roleInstance) {
            flash.message = message(code: "role.notFound", args: [params.id])
            redirect(action:list)
        }
        else { return [ roleInstance : roleInstance ] }
    }

    def delete = {
        def roleInstance = Role.get( params.id )
        if(roleInstance) {
            try {
                roleInstance.delete(flush:true)
                flash.message = message(code: "role.deleted", args: [params.id])
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code: "role.notDeleted", args: [params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code: "role.notFound", args: [params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def roleInstance = Role.get( params.id )

        if(!roleInstance) {
            flash.message = message(code: "role.notFound", args: [params.id])
            redirect(action:list)
        }
        else {
            return [ roleInstance : roleInstance ]
        }
    }

    def update = {
        def roleInstance = Role.get( params.id )
        if(roleInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(roleInstance.version > version) {
                    
                    roleInstance.errors.rejectValue("version", "role.optimistic.locking.failure", "Another user has updated this Role while you were editing.")
                    render(view:'edit',model:[roleInstance:roleInstance])
                    return
                }
            }
            roleInstance.properties = params
            if(!roleInstance.hasErrors() && roleInstance.save()) {
                flash.message = message(code: "role.updated", args: [params.id])
                redirect(action:show,id:roleInstance.id)
            }
            else {
                render(view:'edit',model:[roleInstance:roleInstance])
            }
        }
        else {
            flash.message = message(code: "role.notFound", args: [params.id])
            redirect(action:list)
        }
    }

    def create = {
        def roleInstance = new Role()
        roleInstance.properties = params
        return ['roleInstance':roleInstance]
    }

    def save = {
        def roleInstance = new Role(params)
        if(!roleInstance.hasErrors() && roleInstance.save()) {
            flash.message = message(code: "role.created", args: [roleInstance.id])
            redirect(action:show,id:roleInstance.id)
        }
        else {
            render(view:'create',model:[roleInstance:roleInstance])
        }
    }
}
