import grails.converters.*

@Mixin(ControllerMixin)
class SavedAnalysisController{
	def securityService
	def savedAnalysisService
	def tagService
	
	def index = {
		def myAnalyses = []
		def timePeriods = [
			30: message(code: "gcore.filter30"), 
			90: message(code: "gcore.filter90"), 
			180: message(code: "gcore.filter6months"),
			hideShared: message(code: "gcore.filterMyAnalysis"),
			all: message(code: "gcore.filterAllAnalysis")]
		def pagedAnalyses = [:]
		
		if(params.analysisFilter){
			session.analysisFilter = params.analysisFilter
		}
		else if(session.analysisFilter){
			log.debug "current session analysis filter is $session.analysisFilter"
		}
		else{
			session.analysisFilter = "all"
		}
		if(params.offset){
			pagedAnalyses = savedAnalysisService.getPaginatedAnalyses(session.analysisFilter,session.sharedAnalysisIds,params.offset.toInteger(),session.userId)
		}
		else{
			pagedAnalyses = savedAnalysisService.getPaginatedAnalyses(session.analysisFilter,session.sharedAnalysisIds,0,session.userId)	
		}
		
		log.debug "the count is " + pagedAnalyses.totalCount
        [ savedAnalysis: pagedAnalyses, allAnalysesSize:pagedAnalyses.totalCount, timePeriods: timePeriods]
    }

	def delete = {
		if(isAnalysisAuthor(params.id)){
			log.debug "user is permitted to delete analysis"
			savedAnalysisService.deleteAnalysis(params.id)
			def myAnalyses = []
			redirect(action:index)
			return
		}else{
			log.debug "user is NOT permitted to delete analysis"
			redirect(controller:'policies',action:'deniedAccess')
		}	
	
	}
	
	def deleteMultipleAnalyses ={
		def delmessage = ""
		if(params.deleteAnalyses){
			log.debug "Requesting deletion of: $params.deleteAnalyses"
			if(params.deleteAnalyses.metaClass.respondsTo(params.deleteAnalyses, "max")){
				params.deleteAnalyses.each{ analysisIdToBeRemoved ->
					log.debug analysisIdToBeRemoved 
					def analysis = SavedAnalysis.get(analysisIdToBeRemoved)
			        if(analysis) {
			            if(analysis.evidence){
							log.debug "could not delete " + analysis + ", this link represents a piece of evidence in a G-DOC finding"
							delmessage += message(code: "savedAnalysis.finding", args: [analysis.id, g.appTitle()])
						}
						else if(analysis.author.username != session.userId){
							log.debug "did not delete " + analysis + ", you are not the author."
							delmessage += message(code: "savedAnalysis.noDelete", args: [analysis.id])
						}
						else{
			            	savedAnalysisService.deleteAnalysis(analysis.id)
							log.debug "deleted " + analysis
							delmessage += message(code: "savedAnalysis.deleted", args: [analysis.id])
						}
					}
				}
			}else{
				def analysis = SavedAnalysis.get(params.deleteAnalyses)
		        if(analysis) {
		             if(analysis.evidence){
							log.debug "could not delete " + analysis + ", this link represents a piece of evidence in a G-DOC finding"
							delmessage += message(code: "savedAnalysis.finding", args: [analysis.id, g.appTitle()])
						}
						else if(analysis.author.username != session.userId){
							log.debug "did not delete " + analysis + ", you are not the author."
							delmessage += message(code: "savedAnalysis.noDelete", args: [analysis.id])
						}
						else{
			            	savedAnalysisService.deleteAnalysis(analysis.id)
							delmessage += message(code: "savedAnalysis.deleted", args: [analysis.id])
						}
				}
			}
			flash.message = delmessage
			redirect(action:index)
			return
		}else{
			flash.message = message(code: "savedAnalysis.noneSelected")
			redirect(action:index)
			return
		}
	}
	
	//TODO - decide if we always want to auto-save KM plots. Right now, we do not. They must implicitly call 'save'.
	def save = {
			log.debug ("THE RESULT:")
			log.debug params.resultData
			def savedAttempt = [:]
			log.debug "session command" + session.command
			if(session.command != null){
			log.debug ("THE COMMAND PARAMS:")
				if(savedAnalysisService.saveAnalysisResult(session.userId, params.resultData,session.command,null)){
					log.debug ("saved analysis")
					savedAttempt["result"] = message(code: "savedAnalysis.saved")
					render savedAttempt as JSON		
				} 	else{
							savedAttempt["result"] = message(code: "savedAnalysis.notSaved")
							log.debug savedAttempt
							render savedAttempt as JSON
					}
			}else{
					savedAttempt["result"] = message(code: "savedAnalysis.notSaved")
					log.debug savedAttempt
					render savedAttempt as JSON
			}
	}
	
	def addTag = {
		log.debug params
		if(params.id && params.tag){
			def list = tagService.addTag(SavedAnalysis.class.name,params.id,params.tag.trim())
			if(list){
				render list.tags
			}
			else{
				render ""
			}
		}
	}
	
	def removeTag = {
		log.debug params
		if(params.id && params.tag){
			if(isAnalysisAuthor(params.id)){
				def analysis = tagService.removeTag(SavedAnalysis.class.name,params.id,params.tag.trim())
				if(analysis){
					render analysis.tags
				}
				else{
					render ""
				}
			}
		}
	}
	
}