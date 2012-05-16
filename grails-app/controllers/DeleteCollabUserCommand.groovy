import org.codehaus.groovy.grails.validation.Validateable

@Validateable
class DeleteCollabUserCommand {

	String collaborationGroupName
	String[] users
	
	static constraints = {
		users(validator: { val, obj ->
			if(!val) {
				return "custom.size"
			}
			else{
				return true
			}
			
		})
	}
	
}