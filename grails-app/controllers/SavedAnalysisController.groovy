import grails.converters.*

class SavedAnalysisController{
	def securityService
	def savedAnalysisService
	def tagService
	
	def index = {
        //if(!params.max) params.max = 10
		def user = GDOCUser.findByLoginName(session.userId)
		user.refresh()
		def timePeriods = [1:"1 day",7:"1 week",30:"past 30 days",90:"past 90 days",all:"show all"]
		def groupAnalysisIds = []
		def filteredAnalysis = []
		if(!session.sharedAnalysisIds){
			groupAnalysisIds = savedAnalysisService.getSharedAnalysisIds(session.userId)
		}else{
			groupAnalysisIds = session.sharedAnalysisIds
		}
		def myAnalysis = user.analysis
		def analysisIds = []
		
		if(myAnalysis.metaClass.respondsTo(myAnalysis, "size")) {
				myAnalysis.each{
					analysisIds << it.id.toString()
				}
		} else {
				analysisIds << myAnalysis.id.toString()
		}
	
		//until we modify ui, just add shared analyisis to 'all' analysis
		groupAnalysisIds.each{
			if(!analysisIds.contains(it)){
			def foundAnalysis = SavedAnalysis.get(it)
			if(foundAnalysis){
				myAnalysis << foundAnalysis
			}
			}
		}
		myAnalysis = myAnalysis.sort { one, two ->
			def dateOne = one.dateCreated
			def dateTwo = two.dateCreated
			return dateTwo.compareTo(dateOne)
		}
		
		if(params.analysisFilter){
			if(params.analysisFilter == 'all'){
				session.analysisFilter = "all"
				filteredAnalysis = myAnalysis
				return [ savedAnalysis: filteredAnalysis, timePeriods: timePeriods]
			}
			else{
				session.analysisFilter = params.analysisFilter
				filteredAnalysis = savedAnalysisService.filterAnalysis(params.analysisFilter,myAnalysis)
				//println params.analysisFilter
				//println filteredAnalysis.size()
			}
		}
		else if(session.analysisFilter){
			filteredAnalysis = savedAnalysisService.filterAnalysis(session.analysisFilter,myAnalysis)
		}
		else{
			session.analysisFilter = "30"
			filteredAnalysis = savedAnalysisService.filterAnalysis(session.analysisFilter,myAnalysis)
		}
        [ savedAnalysis: filteredAnalysis, timePeriods: timePeriods]
    }

	//TODO refactor to re-use the code in this
	def delete = {
		savedAnalysisService.deleteAnalysis(params.id)
		def user = GDOCUser.findByLoginName(session.userId)
		def groupAnalysisIds = []
		if(!session.sharedAnalysisIds){
			groupAnalysisIds = savedAnalysisService.getSharedAnalysisIds(session.userId)
		}else{
			groupAnalysisIds = session.sharedAnalysisIds
		}
		def myAnalysis = user.analysis
		def analysisIds = []
		
		if(myAnalysis.metaClass.respondsTo(myAnalysis, "size")) {
				myAnalysis.each{
					analysisIds << it.id.toString()
				}
		} else {
				analysisIds << myAnalysis.id.toString()
		}
		if(groupAnalysisIds.metaClass.respondsTo(groupAnalysisIds, "size")) {
				groupAnalysisIds.removeAll(analysisIds)
		} else {
				groupAnalysisIds.remove(analysisIds)
		}	
		
		//until we modify ui, just add shared analyisis to 'all' analysis
		groupAnalysisIds.each{
			def foundAnalysis = SavedAnalysis.get(it)
			if(foundAnalysis){
				myAnalysis << foundAnalysis
			}
		}
		myAnalysis = myAnalysis.sort { one, two ->
			def dateOne = one.dateCreated
			def dateTwo = two.dateCreated
			return dateTwo.compareTo(dateOne)
		}
		def filteredAnalysis = []
		if(session.analysisFilter){
			filteredAnalysis = savedAnalysisService.filterAnalysis(session.analysisFilter,myAnalysis)
		}
		render(template:"/savedAnalysis/savedAnalysisTable",model:[ savedAnalysis: filteredAnalysis ])
	}
	
	//TODO - decide if we always want to auto-save KM plots. Right now, we do not. They must implicitly call 'save'.
	def save = {
			println ("THE RESULT:")
			println params.resultData
			def savedAttempt = [:]
			println "session command" + session.command
			if(session.command != null){
			println ("THE COMMAND PARAMS:")
				if(savedAnalysisService.saveAnalysisResult(session.userId, params.resultData,session.command)){
					println ("saved analysis")
					savedAttempt["result"] = "Analysis Saved"
					render savedAttempt as JSON		
				} 	else{
							savedAttempt["result"] = "Analysis not Saved -- may have already been saved."
							println savedAttempt
							render savedAttempt as JSON
					}
			}else{
					savedAttempt["result"] = "Analysis not Saved -- may have already been saved."
					println savedAttempt
					render savedAttempt as JSON
			}
	}
	
	def addTag = {
		println params
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
		println params
		if(params.id && params.tag){
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