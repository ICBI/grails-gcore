// Place your Spring DSL code here
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.apache.commons.dbcp.BasicDataSource
import javax.jms.Queue
import javax.jms.QueueConnectionFactory

beans = {
	userDetailsService(CustomUserDetailsService){
		securityService = ref("securityService")
	}

	ldapUserDetailsMapper(CustomLdapUserDetailsMapper) {}
}