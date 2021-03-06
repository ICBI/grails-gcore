

class MembershipController {
    def securityService
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        /**params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
		//params.sort = "collaborationGroup.name"**/
		if (!params.max) params.max = 10
		if (!params.offset) params.offset = 0
		if (!params.sort) params.sort = "groupName"
		if (!params.order) params.order = "asc"
		def membershipInstanceList = Membership.withCriteria {
		     maxResults(params.max?.toInteger())
		     firstResult(params.offset?.toInteger())
		     if (params.sort == 'groupName') {
		         collaborationGroup {
		                order('name', params.order)
		          }
		     }
			else if (params.sort == 'roleName') {
		         role {
		                order('name', params.order)
		          }
		     }
			else if (params.sort == 'userName') {
		         user {
		                order('username', params.order)
		          }
		     }
			else{
		          order(params.sort, params.order)
		         }
		 }
		[ membershipInstanceList: membershipInstanceList, membershipInstanceTotal: Membership.count() ]
        //[ membershipInstanceList: Membership.list( params ), membershipInstanceTotal: Membership.count() ]
    }

    def show = {
        def membershipInstance = Membership.get( params.id )

        if(!membershipInstance) {
            flash.message = message(code:"membership.notFound",args:[params.id])
            redirect(action:list)
        }
        else { return [ membershipInstance : membershipInstance ] }
    }

    def delete = {
        def membershipInstance = Membership.get( params.id )
        if(membershipInstance) {
            try {
				def user = membershipInstance.user
				user.removeFromMemberships(membershipInstance)
				log.debug "$user removed membership $membershipInstance"
                membershipInstance.delete(flush:true)
                flash.message = message(code:"membership.deleted",args:[params.id])
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code:"membership.notDeleted",args:[params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code:"membership.notFound",args:[params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def membershipInstance = Membership.get( params.id )

        if(!membershipInstance) {
            flash.message = message(code:"membership.notFound",args:[params.id])
            redirect(action:list)
        }
        else {
            return [ membershipInstance : membershipInstance ]
        }
    }

    def update = {
	log.debug params
		flash.params = params
		//def existingMembership = securityService.doesMembershipExistByIds(params.user.id,params.collaborationGroup.id,params.role.id)
        //if(!existingMembership){
			def membershipInstance = Membership.get( params.id )
	        if(membershipInstance) {
	            membershipInstance.properties = params
	            if(!membershipInstance.hasErrors() && membershipInstance.save()) {
	                flash.message = message(code:"membership.updated",args:[params.id])
	                redirect(action:show,id:membershipInstance.id)
	            }
	            else {
	                render(view:'edit',model:[membershipInstance:membershipInstance])
	            }
	        }
	        else {
	            flash.message = message(code:"membership.notFound",args:[params.id])
	            redirect(action:list)
	        }
		/**}else {
			log.debug "this user already exists with a role, $params.role.id in this group $params.collaborationGroup.id"
			flash.error = "this user already has this role within this group"
		    render(view:'edit',model:[membershipInstance:existingMembership])
		}**/
    }

    def create = {
        def membershipInstance = new Membership()
        membershipInstance.properties = params
        return ['membershipInstance':membershipInstance]
    }

    def save = {
		log.debug params
		flash.params = params
        def membershipInstance = securityService.doesMembershipExistByNames(params.username,params.groupName.toUpperCase(),params.role)
        if(!membershipInstance) {
         	def newMembershipInstance = securityService.createMembership(params.username,params.groupName.toUpperCase(),params.role)
			if(newMembershipInstance){
				flash.message = message(code:"membership.created",args:[newMembershipInstance.id])
	            redirect(action:show,id:newMembershipInstance.id)
			}else{
				flash.message = message(code:"membership.notCreated")
	            redirect(action:create)
			}
		}
        else {
			log.debug "$params.username already exists as a $params.role in $params.groupName"
			flash.error = message(code:"membership.alreadyExists",args:[params.username,params.role,params.groupName])
            render(view:'create')
        }
    }
}
