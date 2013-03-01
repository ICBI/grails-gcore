import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.orm.hibernate3.SessionFactoryUtils
import org.springframework.orm.hibernate3.SessionHolder
import org.springframework.transaction.support.TransactionSynchronizationManager
import org.springframework.mock.jndi.SimpleNamingContextBuilder

grailsHome = Ant.antProject.properties."env.GRAILS_HOME"
includeTargets << grailsScript("Bootstrap")
includeTargets << grailsScript("Init")

target(main: "Load a annotations into the database") {
	depends(clean, compile, classpath)
	
	// Load up grails contexts to be able to use GORM
	loadApp()
	configureApp()
	if(!argsMap['study']) {
		print "Please specify a study name using the --study parameter."
	}
	def projectName =  argsMap['study'].toUpperCase()
	def studyFile = new File("dataImport/${projectName}/${projectName}_annotation_table.txt")
	if(!studyFile.exists()) {
		println "Cannot find study metadata file at dataImport/${projectName}/${projectName}_annotation_table.txt.  Please make sure this file exists."
		return
	}
	
	try {
		println "Loading annotation data...."
		loadAnnotationData(projectName)
	} catch (Throwable e) {
		e.printStackTrace()
		"Data loading for $projectName was not successful"
		return
	}
	println "Loading annotations was successful"
}

def loadAnnotationData(projectName) {
	def annotationData = new File("dataImport/${projectName}/${projectName}_annotation_table.txt")
	
	def sessionFactory = appCtx.getBean("sessionFactory")
	def annotationService = appCtx.getBean("annotationService")
	try {
		def annotations = []
		def attributeHash = [:]
		def annotationAndData = [:]
		annotationData.eachLine { line, number ->
			def data = line.split("\t", -1)
			data = data.collect { it.trim() }
			if(number != 1) {
				def annotation = [:]
				annotation.name = data[0]
				annotation.type = data[1]
				annotations << annotation
				def annotationDataHash = [:]
				attributeHash.each { key, value ->
					annotationDataHash[value] = data[key]
				}
				annotationAndData[annotation] = annotationDataHash
			} else {
				data.eachWithIndex { value, index ->
					if(index > 3) {
						attributeHash[index] = value
					}
				}
			}
		}
		annotationAndData.each { annotation, values ->
			annotationService.loadAnnotation(annotation, values)
		}
	} catch (Exception e) {
		println e.message
		throw e
	} 
}

setDefaultTarget(main)
