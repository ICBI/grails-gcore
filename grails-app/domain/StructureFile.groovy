class StructureFile{
	static mapping = {
		table 'DRUG.STRUCTURE_FILE'
	}
	
	static searchable = {
	    fileType component: true
		fileFormat component: true
		dateCreated index: 'no'
		lastUpdated index: 'no'
		relativePath index: 'no'
		fileSize index: 'no'
	}
	
	String name
	String relativePath
	Long fileSize
	static belongsTo = [Structure]
	Structure structure
	FileType fileType
	FileFormat fileFormat
	Date dateCreated
	Date lastUpdated
	static constraints = {
		name(nullable:false)
		relativePath(nullable:false)
		structure(nullable:true)
		fileSize(nullable:true)
		fileType(nullable:true)
		fileFormat(nullable:true)
	}
	

	
}