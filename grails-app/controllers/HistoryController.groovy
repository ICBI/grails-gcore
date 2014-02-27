

class HistoryController {
    
    def index = {


        //redirect(action:list,params:params)

    }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {

        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ historyInstanceList: History.list( params ), historyInstanceTotal: History.count() ]
    }

    def show = {
        def historyInstance = History.get( params.id )

        if(!historyInstance) {
            flash.message = "History not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ historyInstance : historyInstance ] }
    }

    def delete = {
        def historyInstance = History.get( params.id )
        if(historyInstance) {
            try {
                historyInstance.delete(flush:true)
                flash.message = "History ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "History ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "History not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def historyInstance = History.get( params.id )

        if(!historyInstance) {
            flash.message = "History not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ historyInstance : historyInstance ]
        }
    }

    def update = {
        def historyInstance = History.get( params.id )
        if(historyInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(historyInstance.version > version) {
                    
                    historyInstance.errors.rejectValue("version", "history.optimistic.locking.failure", "Another user has updated this History while you were editing.")
                    render(view:'edit',model:[historyInstance:historyInstance])
                    return
                }
            }
            historyInstance.properties = params
            if(!historyInstance.hasErrors() && historyInstance.save()) {
                flash.message = "History ${params.id} updated"
                redirect(action:show,id:historyInstance.id)
            }
            else {
                render(view:'edit',model:[historyInstance:historyInstance])
            }
        }
        else {
            flash.message = "History not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def historyInstance = new History()
        historyInstance.properties = params
        return ['historyInstance':historyInstance]
    }

    def save = {
        def historyInstance = new History(params)
        if(!historyInstance.hasErrors() && historyInstance.save()) {
            flash.message = "History ${historyInstance.id} created"
            redirect(action:show,id:historyInstance.id)
        }
        else {
            render(view:'create',model:[historyInstance:historyInstance])
        }
    }
}
