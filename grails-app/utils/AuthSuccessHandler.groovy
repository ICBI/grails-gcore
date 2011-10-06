import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils;
 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
public class AuthSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
 
    @Override
    protected String determineTargetUrl(HttpServletRequest request,
                                            HttpServletResponse response) {
 
        def desiredPage = request.getParameter(getTargetUrlParameter());
		if(desiredPage){
			println "forward to " + desiredPage
			return defaultTargetUrl + "?desiredPage="+desiredPage
		}
		else{
			return defaultTargetUrl
		}
    }
 
    
}