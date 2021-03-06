import SecurityException

@Mixin(ControllerMixin)
class ShareController {
    def securityService
//def index = { redirect(action:share,params:params) }

def shareItem = {
	//REFACTOR TO USE SHARE COMMAND
	ShareCommand cmd ->
	if(cmd.hasErrors()) {
		flash['cmd'] = cmd
		log.debug cmd.errors
		redirect(controller:'share',action:'share')
		return
	}
	else{	
	flash['cmd'] = cmd
	log.debug cmd
	def item
	def groups = []
	def alreadySharedGroups = []
 	
	groups = cmd.groups.toList()
	log.debug groups
	/**
	if(cmd.groups instanceof String[]){
		params.groups.each{
			groups << it 
		}
	}else if (params.groups instanceof String){
		groups << params.groups
	}**/
	
	if(cmd.type.equals(Constants.SAVED_ANALYSIS)){
		if(isAnalysisAuthor(cmd.itemId)){
			log.debug 'share saved analysis: ' + cmd.itemId
			item = SavedAnalysis.get(cmd.itemId)
		}
		else{
			log.debug "user is NOT permitted to share analysis"
			redirect(controller:'policies',action:'deniedAccess')
			return
		}
	}
	if(cmd.type.equals(Constants.USER_LIST)){
		if(isListAuthor(cmd.itemId)){
			log.debug 'share user list: ' + cmd.itemId
			item = UserList.get( cmd.itemId )
		}
		else{
			log.debug "user is NOT permitted to share list"
			redirect(controller:'policies',action:'deniedAccess')
			return
		}
	}
	if(item && cmd.type){
		try{
			alreadySharedGroups = securityService.groupsShared(item)
			if(alreadySharedGroups){
			 alreadySharedGroups.each{
				groups.remove(it)
			 }
			log.debug "removed already shared groups: $alreadySharedGroups"
			log.debug "remaing groups: $groups"
			}
			if(!groups.isEmpty()){
			log.debug "sharing with groups: $groups"
			securityService.share(item, groups)
			}
		}catch(SecurityException se){
				log.error("error with sharing item", se)
				flash['message'] = message(code: "share.problem")
				redirect(action:share,params:[success:false,groups:groups,name:params.name])
		}
	}
	if(groups.isEmpty()){
			log.debug "no item is to be shared"
			flash['message'] = message(code: "share.alreadyShared")
			for(int i=0;i<alreadySharedGroups.size();i++){
				if((i+1)==alreadySharedGroups.size()){
					flash.message+=alreadySharedGroups[i]
				}else{
					flash.message+=alreadySharedGroups[i] + " , "
				}
			}
			redirect(action:share,params:[failure:true,name:params.name])
	}else{
		log.debug "shared to groups: $groups"
		flash.message = message(code: "share.with", args: [cmd.name])
		for(int i=0;i<groups.size();i++){
			if((i+1)==groups.size()){
				flash.message+=groups[i]
			}else{
				flash.message+=groups[i] + " , "
			}
		}
		redirect(action:share,params:[success:true,groups:groups,name:params.name])
		}
	}
}

//add group besides on 'PUBLIC' group
def share = {
	def item
	if(params.id && params.type){
		item = getItem(params.id, params.type)
		if(item) {
			def alreadySharedGroups = []
			alreadySharedGroups = securityService.groupsShared(item)
			if(alreadySharedGroups){
				flash.message = alreadySharedGroups
				[groups:alreadySharedGroups]
			}
		}
	}
}

def getItem(id,type){
	def item
	if(type.equals(Constants.SAVED_ANALYSIS)){
		if(isAnalysisAuthor(id)){
			log.debug 'attempting to share saved analysis: ' + id
			item = SavedAnalysis.get(id)
			return item
		}
		else{
			log.debug "user is NOT permitted to share analysis"
			redirect(controller:'policies',action:'deniedAccess')
			return
		}
	}
	if(type.equals(Constants.USER_LIST)){
		if(isListAuthor(id)){
			log.debug 'attempting to share user list: ' + id
			item = UserList.get(id)
			return item
		}
		else{
			log.debug "user is NOT permitted to share list"
			redirect(controller:'policies',action:'deniedAccess')
			return
		}
	}
	return item
}

}