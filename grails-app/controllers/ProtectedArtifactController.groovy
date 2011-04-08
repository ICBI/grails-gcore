

class ProtectedArtifactController {
    def securityService
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
            flash.message = "ProtectedArtifact not found with id ${params.id}"
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
		/**
		-Report adds/deletes to user
		**/
		def deletionNames = []
		def additionNames = []
		def protectedArtifactInstance = ProtectedArtifact.get( params.id )
	    if(protectedArtifactInstance) {
				if(protectedArtifactInstance.groups){
					log.debug "associations exist with $protectedArtifactInstance.groups"
					def additions = []
					def deletions = []
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
						//Loop over existing list and see if they exist in submitted list, for each not found, add to 'delete' list.
						protectedArtifactInstance.groups.each{ group ->
							log.debug "does $submittedGroups contain " + group.id.toString() + "? or should we delete"
							if(!submittedGroups.contains(group.id.toString())){
								deletions << group.id
							}	
						}
						//Delete item associations
						if(deletions){
							log.debug "this artifact will delete the following group associations $deletions"
							deletions.each{ toDeleteId ->
								def collabGroup = CollaborationGroup.get(toDeleteId)
								if(collabGroup){
									protectedArtifactInstance.removeFromGroups(collabGroup)
									deletionNames << collabGroup.name
								}
							}
						}else "no associations will be deleted"
						log.debug "the following deletions have been made $deletionNames"
						
						//Loop over submitted and see if they exist in pre-existing list, for each not found, add to 'add' list.
						submittedGroups.each{ groupId ->
							def existing = protectedArtifactInstance.groups.collect{it.id.toString()}
							log.debug "does $submittedGroups contain " + groupId + "? or should we add"
							if(!existing.contains(groupId)){
								additions << groupId
							}
						}
						//Add item associations
						if(additions){ 
							log.debug "this artifact will add the following group associations $additions"
							additions.each{ groupId ->
								def collabGroup = CollaborationGroup.get(groupId)
								if(collabGroup){
									protectedArtifactInstance.addToGroups(collabGroup)
									additionNames << collabGroup.name
								}
							}
						}else "no additions will be made"
						log.debug "the following additions have been made $additionNames"						
					
					//No submitted associations	
					}else{
						log.debug "this currently has associations, but the update includes none, so deletions need to be made"
						securityService.deleteAllGroupArtifacts(protectedArtifactInstance.id, ProtectedArtifact.class.name)
						log.debug "the following deletions have been made $deletionNames"
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
						submittedGroups.each{ groupId ->
							def collabGroup = CollaborationGroup.get(groupId)
							if(collabGroup){
								protectedArtifactInstance.addToGroups(collabGroup)
								additionNames << collabGroup.name
							}
						}
						log.debug "the following additions have been made $additionNames"
					}
					else{
						log.debug "no existing associations and no associations have been added"
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
