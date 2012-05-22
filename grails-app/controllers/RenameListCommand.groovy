import java.util.regex.Matcher
import java.util.regex.Pattern
import org.codehaus.groovy.grails.validation.Validateable

@Validateable
class RenameListCommand {

	def userListService
	
	String newName
	String id
	String description
	String userId
	
	
	static constraints = {
		newName(blank:false,size:0..15, matches:/^[^<^>^;^%^"]*$/,validator: {val, obj ->
			if(obj.userId && obj.id && obj.newName){
				if(obj.userListService.isDuplicateList(obj.userId,obj.id,obj.newName))
					return "savedAnalysis.rename"
			}
		})
		description(size:0..300, matches:/^[^<^>^;^%^"]*$/)
	}
	
}