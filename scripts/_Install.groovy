import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication

//
// This script is executed by Grails after plugin was installed to project.
// This script is a Gant script so you can use all special variables provided
// by Gant (such as 'baseDir' which points on project base dir). You can
// use 'ant' to access a global instance of AntBuilder
//
// For example you can create directory under project tree:
//
//    ant.mkdir(dir:"${basedir}/grails-app/jobs")
//

Ant.property(environment: "env")
grailsHome = Ant.antProject.properties."env.GRAILS_HOME"

Ant.sequential {

	event("StatusUpdate", ["Installing gcore resources"])

	//applets
	

	// css files
	copy(todir: "${basedir}/web-app/css", overwrite: true) {
    	fileset(dir: "${pluginBasedir}/web-app/css")
	}
	
	//images
	copy(todir: "${basedir}/web-app/images", overwrite: true) {
    	fileset(dir: "${pluginBasedir}/web-app/images")
	}
	
	// js files
  	copy(todir: "${basedir}/web-app/js", overwrite: true) {
    	fileset(dir: "${pluginBasedir}/web-app/js")
	}
	
	//visualizations
	copy(todir: "${basedir}/web-app/visualizations", overwrite: true) {
    	fileset(dir: "${pluginBasedir}/web-app/visualizations")
	}
	
	//config file
	copy(file: "${pluginBasedir}/grails-app/conf/GcoreConfig.groovy", todir: "${basedir}/grails-app/conf/", overwrite: false) 
	
	
	def file = new File("${basedir}/grails-app/conf/Config.groovy")
	def appConfig = new ConfigSlurper().parse(file.toURL())
	if(appConfig.grails.config.defaults.locations){
		event("StatusUpdate", ["External default configuration already exists, skip config addition"])
	}
	else{
		event("StatusUpdate", ["Adding configuration default setting"])
		def configObj = new ConfigObject()
		configObj.grails.config.defaults.locations = [ "classpath:conf/GcoreConfig.groovy", "file:"+"${basedir}/grails-app/conf/GcoreConfig.groovy"]

		def tempFile=File.createTempFile('Tem', '.txt')
		tempFile.withWriterAppend{ writer ->
			configObj.writeTo(writer)
		}
		file.eachLine{
			tempFile.append(it+"\n")
		}
		file.write("")
		tempFile.eachLine{
			file.append(it+"\n")
		}
	}
}

event("StatusFinal", ["Installed gcore resources"])
