import java.util.regex.Matcher
import java.util.regex.Pattern
import grails.validation.Validateable

@Validateable
class ModifyAnalysisAttributesCommand {
	
	def savedAnalysisService
	
	String newName
	String id
	String description
	String userId
	
	
	static constraints = {
		newName(size:0..15, matches:/^[^<^>^;^%^"]*$/,validator: {val, obj ->
			if(obj.userId && obj.id && obj.newName){
				if(obj.savedAnalysisService.isDuplicateAnalysis(obj.userId,obj.id,obj.newName))
					return "savedAnalysis.rename"
			}
		})
		description(size:0..300, matches:/^[^<^>^;^%^"]*$/)
	}
	
}