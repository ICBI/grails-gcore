import grails.converters.*
import grails.orm.PagedResultList
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

@Mixin(ControllerMixin)
class ListsController {
	private static Integer MAX_LIST_SIZE = 2000
    def securityService
	def userListService
	def exportService
	def annotationService
	def vennService
	def searchableService
	def tagService
	def htDataService
	def springSecurityService

    /**def show = {
		log.debug params
		def lists = [:]
		def username = params.username
		def listFilter = params.filter
		def offset = params.offset?.toInteger()
		def searchTerm = params.label
		def baseUrl = CH.config.grails.serverURL
		def currentUser = springSecurityService.getPrincipal()
		if(username && username == currentUser.username){
			def sharedListIds = []
			sharedListIds = userListService.getSharedListIds(username,true)
			if(!listFilter){
				listFilter = "all"
			}
			if(offset){
				if(offset > 0){
					def plists = userListService.getPaginatedLists(listFilter,sharedListIds,offset,username,searchTerm)
					def listCollection = []
					plists["results"].each{
						def mmap = [:]
						mmap["id"] = it.id
						mmap["name"] = it.name
						mmap["uri"] = baseUrl+"/lists/$it.id"
						listCollection << mmap
					}
					lists["lists"]=listCollection
					lists["count"]=plists["count"]
				}
				else{
					def plists = userListService.getPaginatedLists(listFilter,sharedListIds,0,username,searchTerm)
					lists["lists"]=plists["results"]
					lists["count"]=plists["count"]	
				}
			}
			//no pagination
			else{
				def plists = userListService.getPaginatedLists(listFilter,sharedListIds,0,username,searchTerm)
				lists["lists"]=plists["snapshot"]
				lists["count"]=plists["count"]
			}
			render lists as JSON
			
		}else{
			render( status: 401, contentType: "text/json"){
			      error( exception: "either the client is not authorized to view data or an authorization parameter not found")
			}
		}
		
    }**/

	
	
}
