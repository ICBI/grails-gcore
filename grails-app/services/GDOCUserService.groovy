import grails.converters.*

class GDOCUserService{
	
	def getOwnedObjects(user){
		def userMap = [:]
		userMap["lists"] = 0
		userMap["analyses"] = 0
		String listHQL = "SELECT count(distinct list.id) FROM UserList list WHERE author = :user " 
		userMap["lists"] = UserList.executeQuery(listHQL,[user:user])
		String analysesHQL = "SELECT count(distinct analysis.id) FROM SavedAnalysis analysis WHERE author = :user " 
		userMap["analyses"] = SavedAnalysis.executeQuery(analysesHQL,[user:user])
		return userMap
	}
	
	
}