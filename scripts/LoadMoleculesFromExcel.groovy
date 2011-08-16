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
	println "Please specify a drug-containig file name:"
	def fileName = new InputStreamReader(System.in).readLine().toUpperCase()
	def drugFile = new File("dataImport/DRUGS/${fileName}")
	if(!drugFile.exists()) {
		println "Cannot find drug-containing file at dataImport/DRUGS/${fileName}.  Please check the file name and try again."
		return
	}
	def moleculeService = appCtx.getBean("moleculeService")
	try {
		println "loading data"
		moleculeService.createMolecules("dataImport/DRUGS/${fileName}")
	} catch (Exception e) {
		e.printStackTrace()
	}
	
}


setDefaultTarget(main)
