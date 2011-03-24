import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser
import org.codehaus.groovy.grails.plugins.springsecurity.GrailsUserDetailsService
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.security.core.authority.GrantedAuthorityImpl
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UsernameNotFoundException

class CustomUserDetailsService implements GrailsUserDetailsService{
    /**
     * Some Spring Security classes (e.g. RoleHierarchyVoter) expect at least one role, so
     * we give a user with no granted roles this one which gets past that restriction but
     * doesn't grant anything.
     */
	def securityService
    static final List NO_ROLES = [new GrantedAuthorityImpl(SpringSecurityUtils.NO_ROLE)]
    UserDetails loadUserByUsername(String username, boolean loadRoles) throws UsernameNotFoundException {
        return loadUserByUsername(username)
    }

    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        GDOCUser.withTransaction { status ->
			log.debug "inside customeUserDetailService"
			def guUser = securityService.isNetId(username)
			if(guUser){
				log.debug "user has netId, fail for common authentication"
				throw new UsernameNotFoundException('User not found', username)
			}
            GDOCUser user = GDOCUser.findByUsername(username)
            if (!user) {
				throw new UsernameNotFoundException('User not found', username)
			}
            else{
				return new CustomUserDetails(user.username, user.password, user.enabled, 
									!user.accountExpired, !user.passwordExpired, !user.accountLocked, NO_ROLES, user.id, user)
			}	
        }
    }
}