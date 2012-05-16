import java.util.regex.Matcher
import java.util.regex.Pattern
import org.codehaus.groovy.grails.validation.Validateable

@Validateable
class RenameListCommand {

	String oldName
	String newName
	String id
	
	static constraints = {
		newName(size:0..15,blank:false, matches:/^[^<^>^;^%^"]*$/,validator: {val, obj ->
			if(obj.newName == obj.oldName) 
				return "userList.renameNameSame"
		})
	}
	
}