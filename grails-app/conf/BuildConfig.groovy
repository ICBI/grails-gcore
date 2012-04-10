// war file setup
grails.war.resources = {stagingDir ->
	delete(file: "$stagingDir/WEB-INF/lib/jbossall-client.jar")
	delete(file: "$stagingDir/WEB-INF/lib/javax.jms.jar")
	delete(file: "$stagingDir/WEB-INF/lib/commons-collections-2.1.1.jar")
	delete(file: "$stagingDir/WEB-INF/lib/jboss-jca.jar")
	delete(file: "$stagingDir/WEB-INF/lib/ojdbc14.jar")
}

grails.project.dependency.resolution = {
	
	inherits("global") {
	        // uncomment to disable ehcache
	        // excludes 'ehcache'
	}
	repositories {
		grailsPlugins()
		grailsHome()
		mavenRepo "https://gdoc-stage.georgetown.edu/artifactory/plugins-release-local/"
		grailsCentral()
	}
	dependencies {
		compile("org.tmatesoft.svnkit:svnkit:1.3.5") {
            excludes "jna", "trilead-ssh2", "sqljet"
			export = false
        }
	}
	
	plugins {
		build ':recaptcha:0.5.2'
		build ':searchable:0.5.5'
		build ':taggable:0.6.1'
		build ':jquery:1.3.2.4'
		build ':mail:0.9'
		build ':quartz:0.4.1'
		build ':spring-security-core:1.1.2'
		build ':spring-security-ldap:1.0.3'
		build(':svn:1.0.2') {
			export = false
		}
		
	}
}