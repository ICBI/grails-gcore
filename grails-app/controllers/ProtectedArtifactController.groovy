

class ProtectedArtifactController {
    def securityService
	def collaborationGroupService
	
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 20,  100)
		//params.sort = "name"
        [ protectedArtifactInstanceList: ProtectedArtifact.list( params ), protectedArtifactInstanceTotal: ProtectedArtifact.count() ]
    }

    def show = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
		
        if(!protectedArtifactInstance) {
            flash.message = message(code:"protectedArtifact.notFound", args: [params.id])
            redirect(action:list)
        }
        else { 
			def artifactDesc = "unknown description of artifact"
			if(protectedArtifactInstance.type == 'UserList'){
				def list = UserList.get(protectedArtifactInstance.objectId)
				if(list)
					artifactDesc = list.name
			}else if(protectedArtifactInstance.type == 'SavedAnalysis'){
				def sa = SavedAnalysis.get(protectedArtifactInstance.objectId)
				if(sa)
					artifactDesc = sa.type
			}else if(protectedArtifactInstance.type == 'Study'){
				artifactDesc = protectedArtifactInstance.objectId
			}	
			return [ protectedArtifactInstance:protectedArtifactInstance, description:artifactDesc ] 
		}
    }

    def delete = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
        if(protectedArtifactInstance) {
            try {
                protectedArtifactInstance.delete(flush:true)
                flash.message = message(code: "protectedArtifact.deleted", args: [params.id])
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = message(code: "protectedArtifact.notDeleted", args: [params.id])
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = message(code: "protectedArtifact.notFound", args: [params.id])
            redirect(action:list)
        }
    }

    def edit = {
        def protectedArtifactInstance = ProtectedArtifact.get( params.id )
        if(!protectedArtifactInstance) {
            flash.message = message(code: "protectedArtifact.notFound", args: [params.id])
            redirect(action:list)
        }
        else {
            return [ protectedArtifactInstance : protectedArtifactInstance ]
        }
    }

    def update = {
		def additionNames =[]
		def deletionNames = []
		def protectedArtifactInstance = ProtectedArtifact.get( params.id )
	    if(protectedArtifactInstance) {
				if(protectedArtifactInstance.groups){
					log.debug "associations exist with $protectedArtifactInstance.groups"
					if(params.group){
						def submittedGroups = []
						if(params.group.metaClass.respondsTo(params.group, "max")){
							params.group.each{ grpId ->
								submittedGroups << grpId
							}
						}
						else{
							submittedGroups << params.group
						}
						def nameMap = collaborationGroupService.manipulateArtifactGroups(protectedArtifactInstance,submittedGroups)
						additionNames = nameMap["additionNames"]
						deletionNames = nameMap["deletionNames"]
						log.debug "the following additions have been made $additionNames"
						log.debug "the following deletions have been made $deletionNames"						
					
					//No submitted associations	
					}else{
						log.debug "this currently has associations, but the update includes none, so deletions need to be made"
						securityService.deleteAllGroupArtifacts(protectedArtifactInstance.id, ProtectedArtifact.class.name)
						log.debug "all group assocaited artifacts have been deleted"
					}
				}
				else{
					if(params.group){
						log.debug "this artifact doesn't currently have associations, but the update includes them, so additions need to be made"
						def submittedGroups = []
						if(params.group.metaClass.respondsTo(params.group, "max")){
							params.group.each{ grpId ->
								submittedGroups << grpId
							}
						}
						else{
							submittedGroups << params.group
						}
						additionNames = collaborationGroupService.associateGroupsToArtifact(protectedArtifactInstance,submittedGroups)
						log.debug "the following additions have been made $additionNames"
					}
					else{
						log.debug "no existing associations and no associations have been added"
					}
				}
				
				
            protectedArtifactInstance.properties = params
			protectedArtifactInstance.validate()
            if(!protectedArtifactInstance.hasErrors() && protectedArtifactInstance.save()) {
                flash.message = message(code: "protectedArtifact.updated", args: [params.id])
                redirect(action:show,id:protectedArtifactInstance.id)
            }
            else {
                render(view:'edit',model:[protectedArtifactInstance:protectedArtifactInstance])
            }
        }
        else {
            flash.message = message(code: "protectedArtifact.notFound", args: [params.id])
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
		protectedArtifactInstance.validate()
        if(!protectedArtifactInstance.hasErrors() && protectedArtifactInstance.save()) {
            flash.message = message(code: "protectedArtifact.created", args: [protectedArtifactInstance.id])
            redirect(action:show,id:protectedArtifactInstance.id)
        }
        else {
            render(view:'create',model:[protectedArtifactInstance:protectedArtifactInstance])
        }
    }
}
