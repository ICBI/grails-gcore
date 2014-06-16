import grails.converters.*

class AdminController {
	def dataAvailableService
	def cleanupService
	def securityService
	def searchResults
	
	def index = {
		def dataAvail = servletContext.getAttribute("dataAvailability")
		def loadedStudies = []
		dataAvail['dataAvailability'].each{elm ->
			def studyName = elm.find{ key, value ->
				if(key == 'STUDY'){
					//log.debug "load $value"
					loadedStudies << value
				}
			}
		}
		if(loadedStudies)
		loadedStudies.sort()
		[loadedStudies:loadedStudies]
	}
	
	def reload = {
		log.debug("reload available data")
	    dataAvailableService.loadDataAvailability()
		def da = dataAvailableService.getDataAvailability()
		servletContext.setAttribute("dataAvailability", da)
		session.dataAvailability = dataAvailableService.getMyDataAvailability(session.myStudies)
		log.debug("finished reloading data")
		redirect(action:index)
		return
	}

}