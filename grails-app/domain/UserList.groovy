import org.grails.taggable.*

class UserList implements Taggable{
	static mapping = {
		table 'USER_LIST'
		id column: 'ID'
		studies joinTable: [name: 'LIST_STUDY', column: 'STUDY_ID', key: 'LIST_ID'] 
		cache true
	}

	String name 
	Date dateCreated
	Date lastUpdated
	String description
	
	static searchable = {
     supportUnmarshall false
	    listItems component: true
	}
	static belongsTo = [author:GDOCUser]
	static hasMany = [listItems:UserListItem,listComments:Comments, studies:Study, evidence:Evidence]
	static fetchMode = [listItems: 'eager',tags:'eager', studies: 'eager']
	static constraints = {
		name(blank:false)
		author(blank:false)
		description nullable: true
	}
	
	static transients = ["groups"]
	
	def studyNames = {
		return studies.collect {it.shortName}
	}
	
	def schemaNames = {
		return studies.collect {it.schemaName}
	}
	
	public Object getGroups(){
		if(this.@id){
			def objectId = this.@id.toString()
			def artHQL = "SELECT distinct artifact FROM ProtectedArtifact artifact WHERE artifact.type = 'UserList' AND artifact.objectId = :id "
			def artifact = ProtectedArtifact.executeQuery(artHQL, [id: objectId])
			if(artifact && artifact.groups){
				artifact.groups.flatten()
				def names = artifact.groups.collect{it.name}
				return names.flatten()
			}
		}
	}
	
}
