import org.codehaus.groovy.grails.validation.Validateable

@Validateable
class CreateCollabCommand {

	String collaborationGroupName
	String description
	
	static constraints = {
		collaborationGroupName(blank:false)
	}
	
}