class CollaborationGroupService{
	def securityService
	def invitationService
	
	
	//gets all user memberships, sends back array. First list is managed memberships,
	//second is all others, third is memberships that exist in groups where user doesnt have access
	def getUserMemberships(loginId){
		def allMemberships = []
		allMemberships = Membership.getAll()
		def managedMemberships =  []
		def otherMemberships =  []
		def user = GDOCUser.findByUsername(loginId)
		def userMemberships = user.memberships
		allMemberships.removeAll(userMemberships)
		def dontShow = []
		userMemberships.each{ mm ->
			def foundMemberships = []
			foundMemberships = allMemberships.findAll{ am ->
				mm.collaborationGroup.name == am.collaborationGroup.name
			}
			if(foundMemberships){
				dontShow.addAll(foundMemberships)
			}
		}
		if(allMemberships){
			if(dontShow){
				allMemberships.removeAll(dontShow)
			}
		}
		userMemberships.each{ cg ->
			if(securityService.isUserCollaborationManager(cg)){
				managedMemberships << cg
			}else{
				otherMemberships << cg
			}
		}
		
		return [managedMemberships,otherMemberships,allMemberships]
	}
	
	
	def getExistingUsers(usernames, groupName){
		def names = []
		def existingUsers = []
		usernames.each{
			names << it
		}
		names.each{ name ->
			if(invitationService.userAlreadyInGroup(name, groupName)){
				existingUsers << name
			}
		}
		return existingUsers
	}
	
	def validName(name){
		def invalidChars = ['"','<','%','>',';','[',']']
		def listAsChars = name.toList()
		def invalidFound = listAsChars.find{
			invalidChars.contains(it)
		}
		if(!(name.trim()) || invalidFound){
			return false
		}
		else{
			return true
		}
	}
	
	def manipulateArtifactGroups(protectedArtifactInstance,submittedGroups){
		def additions = []
		def deletions = []
		def deletionNames = []
		def additionNames = []
		//Loop over existing list and see if they exist in submitted list, for each not found, add to 'delete' list.
		protectedArtifactInstance.groups.each{ group ->
			//log.debug "does $submittedGroups contain " + group.id.toString() + "? or should we delete"
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
		//log.debug "the following deletions have been made $deletionNames"
		
		//Loop over submitted and see if they exist in pre-existing list, for each not found, add to 'add' list.
		submittedGroups.each{ groupId ->
			def existing = protectedArtifactInstance.groups.collect{it.id.toString()}
			//log.debug "does $submittedGroups contain " + groupId + "? or should we add"
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
		//log.debug "the following additions have been made $additionNames"
		def nameMap=[:]
		nameMap["additionNames"] = additionNames
		nameMap["deletionNames"] = deletionNames
		return nameMap
	}
	
	def associateGroupsToArtifact(protectedArtifactInstance,submittedGroups){
		def additionNames = []
		submittedGroups.each{ groupId ->
			def collabGroup = CollaborationGroup.get(groupId)
			if(collabGroup){
				protectedArtifactInstance.addToGroups(collabGroup)
				additionNames << collabGroup.name
			}
		}
		return additionNames
	}
	
	def protectStudy(projectName, isPublic) {

		def protectedArtifact = new ProtectedArtifact()
		protectedArtifact.name =  projectName + "_DATA"
		protectedArtifact.objectId = projectName
		protectedArtifact.type = 'Study'
		if(!protectedArtifact.save(flush:true)){
			log.error "Error saving protected artifact " + protectedArtifact.errors
		}
		def groupToAdd
		if(isPublic) {
			log.info "Adding $projectName as a public study."
			groupToAdd = CollaborationGroup.findByName("PUBLIC")

		} else {
			log.info "Adding $projectName as a private study."
			groupToAdd = new CollaborationGroup()
			groupToAdd.name = projectName + "_COLLAB"
			groupToAdd.description = "Collaboration group for $projectName"
			if(!groupToAdd.save()) {
				log.error "Error creating collaboration group: ${groupToAdd.errors}"
			}
		}
		groupToAdd.addToArtifacts(protectedArtifact)
		if(!groupToAdd.save()) {
			log.error "Error adding artifact to group: ${groupToAdd.errors}"
		}

	}
	
}