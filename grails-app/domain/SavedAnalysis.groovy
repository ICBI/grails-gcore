import grails.converters.*
import org.grails.taggable.*

class SavedAnalysis implements Taggable {
	static mapping = {
		table 'SAVED_ANALYSIS'
		analysisData type: 'text'
		queryData type: 'text'
		type column:'analysis_type'
		studies joinTable: [name: 'ANALYSIS_STUDY', column: 'STUDY_ID', key: 'ANALYSIS_ID']
		cache true
	}
	
	static constraints = {
		taskId nullable: true
		analysisData maxSize: 1024 * 1024 * 10  //10 MB
		queryData maxSize: 1024 * 1024 * 10  //10 MB
	}
	
	static hasMany = [studies:Study,evidence:Evidence]
	static fetchMode = [studies: 'eager']
	static transients = [ "analysis", "query", "groups"]
	
	Object analysis
	Object query
	AnalysisType type
	String analysisData
	String queryData
	String status
	String taskId
	static belongsTo = [author:GDOCUser]
	Date dateCreated
	Date lastUpdated
	
	public Object getAnalysis() {
		if(this.@analysis) {
			return this.@analysis
		}
		if(analysisData) {
			this.@analysis = JSON.parse(analysisData)
			return this.@analysis
		} else {
			return null
		}
	}
	
	public void setAnalysis(Object data) {
		def temp
		temp = data as JSON
		this.@analysisData = temp
	}
	
	public Object getQuery() {
		if(this.@query) {
			return this.@query
		}
		if(queryData) {
			this.@query = JSON.parse(queryData)
			return this.@query
		} else {
			return null
		}
	}
	
	public Object getGroups(){
		if(this.@id){
			def objectId = this.@id.toString()
			def artHQL = "SELECT distinct artifact FROM ProtectedArtifact artifact WHERE artifact.type = 'SavedAnalysis' AND artifact.objectId = :id "
			def artifact = ProtectedArtifact.executeQuery(artHQL, [id: objectId])
			if(artifact && artifact.groups){
				artifact.groups.flatten()
				def names = artifact.groups.collect{it.name}
				return names.flatten()
			}
		}
	}
	
	public void setQuery(Object data) {
		this.@queryData = data as JSON
	}
	
	def reloadData = {
		this.@analysis = JSON.parse(analysisData)
	}
	
	def studyNames = {
		return studies.collect {it.shortName}
	}
	
	def studySchemas = {
		return studies.collect {it.schemaName}
	}
	
}