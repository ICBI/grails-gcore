import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User

class CustomUserDetails extends GrailsUser {

	final GDOCUser user

    CustomUserDetails(String username, String password, boolean enabled,
 		boolean accountNonExpired, boolean credentialsNonExpired,
		boolean accountNonLocked,
 		Collection<GrantedAuthority> authorities,
		long id, GDOCUser user) {

	super(username, password, enabled, accountNonExpired,
	    credentialsNonExpired, accountNonLocked, authorities, id)
	
	this.user = user

    }
}