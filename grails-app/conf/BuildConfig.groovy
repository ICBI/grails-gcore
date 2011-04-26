//grails.plugin.repos.distribution.gcore="https://svn-bccfr.uis.georgetown.edu/svn/gdoc/gcore-plugins/"
//grails.plugin.repos.discovery.gcore="https://svn-bccfr.uis.georgetown.edu/svn/gdoc/gcore-plugins/"

/*grails.project.dependency.resolution = {
	repositories {
		grailsPlugins()
		grailsHome()
		grailsRepo "https://svn-bccfr.uis.georgetown.edu/svn/gdoc/gcore-plugins/"
		grailsCentral()
	}
}*/
// war file setup
grails.war.resources = {stagingDir ->
	delete(file: "$stagingDir/WEB-INF/lib/jbossall-client.jar")
	delete(file: "$stagingDir/WEB-INF/lib/javax.jms.jar")
	delete(file: "$stagingDir/WEB-INF/lib/commons-collections-2.1.1.jar")
	delete(file: "$stagingDir/WEB-INF/lib/jboss-jca.jar")
	delete(file: "$stagingDir/WEB-INF/lib/ojdbc14.jar")
}
