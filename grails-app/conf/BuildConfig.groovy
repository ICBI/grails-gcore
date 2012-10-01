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
		compile("org.liquibase.ext:liquibase-oracle:1.2.0") 
	}
	
	plugins {
		compile ':recaptcha:0.5.2'
		compile ':searchable:0.5.5'
		compile	':taggable:0.6.1'
		compile	':mail:0.9'
		compile ':quartz:0.4.1'
		compile	':spring-security-core:1.2.7.3'
		compile	':spring-security-ldap:1.0.5'
		compile	':hibernate:2.1.1'
		runtime	':tomcat:2.1.1'
		build ':release:2.0.4'
		build(':svn:1.0.2') {
			export = false
		}
		
	}
}