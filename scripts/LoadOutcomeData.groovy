import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.orm.hibernate3.SessionFactoryUtils
import org.springframework.orm.hibernate3.SessionHolder
import org.springframework.transaction.support.TransactionSynchronizationManager
import org.springframework.mock.jndi.SimpleNamingContextBuilder

grailsHome = Ant.antProject.properties."env.GRAILS_HOME"
includeTargets << grailsScript("Bootstrap")
includeTargets << grailsScript("Init")

target(main: "Load outcome relpase data into the DB") {
	depends(clean, compile, classpath)
	
	// Load up grails contexts to be able to use GORM
	loadApp()
	configureApp()

	if(!argsMap['study']) {
		print "Please specify a study name using the --study parameter."
	}
	def projectName =  argsMap['study'].toUpperCase()
	def successful = false;
	def dataSourceClass = classLoader.loadClass('Study')
	def study = dataSourceClass.findBySchemaName(projectName)
	while(!study) {
		println "Project with name: $projectName doesn't exist. This script should be run when all data is loaded."
		return
	}
	def outcomeFile = new File("dataImport/${projectName}/${projectName}_outcomes.txt")
	if(!outcomeFile.exists()) {
		println "Cannot find study outcome file at dataImport/${projectName}/${projectName}_outcomes.txt.  Please locate or build file and try again."
		return
	}
	try {
		println "load all outcome data...."
	    loadOutcomeData(study, outcomeFile)
	} catch (Throwable e) {
		e.printStackTrace()
		"Outcome-data loading for $projectName was not successful"
		return
	}
	println "Outcome-data loading for $projectName was successful"
}


def loadOutcomeData(study, outcomeFile) {
	println "begin data load"
	def createdSuccessfully = false
	def outcomeService = appCtx.getBean("outcomeDataService")
	def sessionFactory = appCtx.getBean("sessionFactory")
	//def session = sessionFactory.getCurrentSession()
	//def trans = session.beginTransaction()
	
	try{
	outcomeFile.eachLine { lineData, outcomeLineNumber ->
		if(outcomeLineNumber != 1) {
			def outcomeData = lineData.split('\t', -1)
			println outcomeData
			def name = outcomeData[0] 
			def query = outcomeData[1].replaceAll('"'," ")
			def description = outcomeData[2] 
			def group = outcomeData[3]
			if(name && query && description && group){
				Long outcomeGroup = group.toLong()
				def outcomeClass = classLoader.loadClass('Outcome')
				def results = outcomeClass.findAll("from Outcome as outcome where outcome.outcomeType = :type and outcome.studyDataSource = :study and outcome.outcomeGroup = :outcomeGroup", [type:name, study:study, outcomeGroup:outcomeGroup])
				if(results){
					println "found existing $name data for $study.schemaName study with group $group...this run will skip loading this data."
				}else{
					//add outcome group
					outcomeService.addQueryOutcome(study,name, query, description,group)
					println "finished loading $name data for group $group"
				}
			}
		}
	}
	//trans.commit()	
	println "committed data"
	} catch (Exception e) {
				//trans.rollback()
				println e.message
				throw e
	}
	
}


def buildCriteriaMap(outcomeData){
	println "build outcome criteria"
	def criteriaMap = [:]
	if(outcomeData[1] == 'Time'){
		criteriaMap[outcomeData[2]] = [min:outcomeData[4],max:outcomeData[5]]
	}else if(outcomeData[1] == 'Attribute'){
		criteriaMap[outcomeData[2]] = outcomeData[3]
	}
	println "built -> $criteriaMap"
	return criteriaMap
}


setDefaultTarget(main)
