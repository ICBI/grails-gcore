import org.codehaus.groovy.grails.validation.Validateable

@Validateable
class RegistrationCommand {

	String netId
	String department
	String password
	
	static constraints = {
		netId(blank:false)
		password(blank:false)
	}
	
}