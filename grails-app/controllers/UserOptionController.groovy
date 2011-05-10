

class UserOptionController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ userOptionInstanceList: UserOption.list( params ), userOptionInstanceTotal: UserOption.count() ]
    }

    def show = {
        def userOptionInstance = UserOption.get( params.id )

        if(!userOptionInstance) {
            flash.message = message(code: "userOption.notFound", args: [params.id])
            redirect(action:list)
        }
        else { return [ userOptionInstance : userOptionInstance ] }
    }

    def delete = {
        def userOptionInstance = UserOption.get( params.id )
        if(userOptionInstance) {
            try {
                userOptionInstance.delete(flush:true)
                flash.message = message(code: "userOption.deleted", args: [params.id])
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code: "userOption.notDeleted", args: [params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code: "userOption.notFound", args: [params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def userOptionInstance = UserOption.get( params.id )

        if(!userOptionInstance) {
            flash.message = message(code: "userOption.notFound", args: [params.id])
            redirect(action:list)
        }
        else {
            return [ userOptionInstance : userOptionInstance ]
        }
    }

    def update = {
        def userOptionInstance = UserOption.get( params.id )
        if(userOptionInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(userOptionInstance.version > version) {
                    
                    userOptionInstance.errors.rejectValue("version", "userOption.optimistic.locking.failure", "Another user has updated this UserOption while you were editing.")
                    render(view:'edit',model:[userOptionInstance:userOptionInstance])
                    return
                }
            }
            userOptionInstance.properties = params
            if(!userOptionInstance.hasErrors() && userOptionInstance.save()) {
                flash.message = message(code: "userOption.updated", args: [params.id])
                redirect(action:show,id:userOptionInstance.id)
            }
            else {
                render(view:'edit',model:[userOptionInstance:userOptionInstance])
            }
        }
        else {
            flash.message = message(code: "userOption.notFound", args: [params.id])
            redirect(action:list)
        }
    }

    def create = {
        def userOptionInstance = new UserOption()
        userOptionInstance.properties = params
        return ['userOptionInstance':userOptionInstance]
    }

    def save = {
        def userOptionInstance = new UserOption(params)
        if(!userOptionInstance.hasErrors() && userOptionInstance.save()) {
            flash.message = message(code: "userOption.created", args: [userOptionInstance.id])
            redirect(action:show,id:userOptionInstance.id)
        }
        else {
            render(view:'create',model:[userOptionInstance:userOptionInstance])
        }
    }
}
