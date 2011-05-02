class ShareCommand {

	String[] groups
	String type
	String name
	String itemId
	
	static constraints = {
		groups(validator: { val, obj ->
			if(!val) {
				return "custom.size"
			}
			if(obj.groups){
				def groupList = obj.groups.toList()
				if(groupList.contains('PUBLIC')){
					return "custom.public"
				}
			}
			return true
		})
		type(blank:false)
		name(blank:false)
		itemId(blank:false)
	}
	
}