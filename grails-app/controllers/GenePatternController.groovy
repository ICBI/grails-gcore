class GenePatternController {

	def genePatternService
	def userListService
	
    def index = {
		if(params.id) {
			def currStudy = StudyDataSource.get(params.id)
			session.study = currStudy
			StudyContext.setStudy(session.study.schemaName)
		}
		def lists = userListService.getAllLists(session.userId,session.sharedListIds)
		def patientLists = lists.findAll { item ->
			(item.tags.contains("patient") && item.schemaNames().contains(StudyContext.getStudy()))
		}
		session.patientLists = patientLists.sort { it.name }
		def geneLists = lists.findAll { item ->
			item.tags.contains("gene")
		}
		session.geneLists = geneLists
		session.files = MicroarrayFile.findByNameLike('%.Rda')
		
	}

	def submit = { GenePatternCommand cmd ->
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			redirect(action:'index')
		} else {
			def jobId = genePatternService.submitJob(session.userId, cmd)
			if(!session.genePatternJobs) {
				session.genePatternJobs = []
			} 
			session.genePatternJobs << [jobId: jobId, complete: false, dateCreated: new Date()]
			redirect(controller:'notification')
		}
	}
}
