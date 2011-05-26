import org.springframework.security.ldap.userdetails.*
import org.springframework.security.core.authority.GrantedAuthorityImpl
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.ldap.core.DirContextAdapter
import org.springframework.ldap.core.DirContextOperations
import org.springframework.security.core.GrantedAuthority
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.security.core.userdetails.UsernameNotFoundException

class CustomLdapUserDetailsMapper implements UserDetailsContextMapper {

    private static final List NO_ROLES = [new GrantedAuthorityImpl(SpringSecurityUtils.NO_ROLE)]

    

    UserDetails mapUserFromContext(DirContextOperations ctx, String username, Collection<GrantedAuthority> authority) {

		GDOCUser.withTransaction { status ->
			    // Try and match the authenticated LDAP user to an existing database User.
		    def user = GDOCUser.findByUsername(username)
			if (!user) {
				throw new UsernameNotFoundException('User not found', username)
			}
	        else{
		 		// Now simply create and return an instance of CustomUserDetails
				if(!user.password){
					//println "this authenticated ldap user lacks a stored password"
					user.password = "N/A"
				}
		    	return new CustomUserDetails(user.username, user.password, user.enabled, 
					!user.accountExpired, !user.passwordExpired, !user.accountLocked, authority ?: NO_ROLES, user.id, user)
			}
	    }
	}

    void mapUserToContext(UserDetails user,
			  DirContextAdapter ctx) {
	// unused 
    }
}