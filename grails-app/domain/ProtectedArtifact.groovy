class ProtectedArtifact {
	static mapping = {
			table 'PROTECTED_ARTIFACT'
			version false
			id column:'PROTECTED_ARTIFACT_ID'
			groups joinTable: [name: 'GROUP_ARTIFACT', column: 'COLLABORATION_GROUP_ID', key: 'PROTECTED_ARTIFACT_ID'] 
	}
	static hasMany = [groups:CollaborationGroup]
	static belongsTo = CollaborationGroup
	String name
	String objectId
	String type
	
	static constraints = {
		name(blank:false,unique:true)
		objectId(blank:false)
		type(blank:false)
	}
	
	public String toString(){
		if(this.@name){
			return this.@name
		}
	}

}
