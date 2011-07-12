import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.orm.hibernate3.SessionFactoryUtils
import org.springframework.orm.hibernate3.SessionHolder
import org.springframework.transaction.support.TransactionSynchronizationManager


grailsHome = Ant.antProject.properties."env.GRAILS_HOME"
includeTargets << grailsScript("Bootstrap")
includeTargets << grailsScript("Init")

target(main: "Load data into the DB from Excel file") {
	depends(clean, compile, classpath)
	
	// Load up grails contexts to be able to use GORM
	loadApp()
	configureApp()
	load()
	
}

def load(){
	def moleculeService = appCtx.getBean("moleculeService")
	try {
		println "load data"
		moleculeService.createMolecules("/Users/kmr75/Documents/gu/gdocRelated/DDG-Schema/FAIBS/imagesFAIBS118/FAIBS_MULTI-Targets-1-118_withImages(116).xls")
	} catch (Exception e) {
		e.printStackTrace()
	}
	
	
}


setDefaultTarget(main)
