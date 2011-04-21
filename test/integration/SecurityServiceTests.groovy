import org.springframework.mock.jndi.SimpleNamingContextBuilder
import javax.security.auth.login.Configuration
import javax.security.auth.login.AppConfigurationEntry
import javax.naming.*
import javax.naming.directory.*
import javax.naming.ldap.*
import javax.net.ssl.*
import org.springframework.jndi.*
import javax.naming.spi.*


class SecurityServiceTests extends BaseSecurityTest {

static transactional = false
def invitationService	
	/**
	void testUsersGroupsAndNames(){
		def groups = []
		def groupNames = []
		//get all groups for a user
		def user = GDOCUser.findByUsername("kmr75")
		groupNames = user.getGroupNames()
		//get all users in that group
		groupNames.each{ group ->
				println "group $group"
		}
		groups = user.getGroups()
		//get all users in that group
		groups.each{ group ->
				println "group $group"
		}
	}
	
	//grabs group for user...do a 'refresh' on user object to possibly get more current view of this
	void testGroupsUsers(){
		def users = []
		def group = CollaborationGroup.findByName("PUBLIC")
		users = group.getUsers()
		users.each{ user ->
			println "user " + user.lastName
		}
	}
	
	//grabs group for user...do a 'refresh' on user object to possibly get more current view of this
	void testFindCollaborationManager(){
		def groupName = "PUBLIC"
		def manager = securityService.findCollaborationManager(groupName)
		if(manager){
			println "manager found for group $groupName, " + manager.username
			assertTrue(manager.username == "mah253")
		}
		else{
			println "manager not found"
		}
		if(securityService.isUserGroupManager(manager.username, groupName)){
			println "is group manager verifiued this"
		}
		else{
			println "manager not verified"
		}
	}
	**/
	
	void testGetSharedItems() {
		println "find all items"
		securityService.getSharedItemIds("rossokr@gmail.com","UserList",true)
	}
	
	/**
	void testCreateAndDeleteCollaborationGroup() {
		def testFailed = false
		try {
			def protectionGroup = securityService.createCollaborationGroup("kmr75", "testkmon group", "some description")
			assertTrue(protectionGroup.id != null)
		} catch(Exception e) {
			e.printStackTrace()
			testFailed = true
		} finally {
			securityService.deleteCollaborationGroup("kmr75", "testkmon group")
		}
		if(testFailed)
			fail("Exception during group create")
	}
	/**
	void testDeleteCollaborationGroupWithInvites() {
		try {
			def invite = invitationService.requestAccess("kmr75","acs224","KEVINS GROUP4")
		} catch(Exception e) {
			e.printStackTrace()
		} finally {
			securityService.deleteCollaborationGroup("kmr75", "KEVINS GROUP4")
		}
	}
	
	void testFailDeleteCollaborationGroup() {
		try {
			securityService.deleteCollaborationGroup("kmr75", "DEVELOPERS")
			fail("Should have thrown exception")
		} catch(Exception e) {
			assertTrue("exception caught", true)
		}
	}
	
	void testShare(){
		def protectionGroup = securityService.createCollaborationGroup("kmr75", "share group", "some description")
		println "created group $protectionGroup.name"
		def list = UserList.get("520144")
		println "found list $list.name"
		def groups = []
		groups << protectionGroup.name
		if(securityService.share(list,groups)){
			def groupsShared = securityService.groupsShared(list)
			println groupsShared
		}
	}
	
	
	void testAddAndRemoveUserToCollaborationGroup() {
		def testFailed = false
		try {
			def protectionGroup = securityService.createCollaborationGroup("kmr75", "user add group", "some description")
			assertTrue(protectionGroup.id != null)
			println "created group $protectionGroup.name"
			securityService.addUserToCollaborationGroup("kmr75", "acs224", "user add group")
			
			def groups = securityService.getCollaborationGroups("acs224")
			println "groups after add" + groups
			assertTrue(groups.contains("user add group"))
			
		} catch(Exception e) {
			e.printStackTrace()
			testFailed = true
		} finally {
			try {
				securityService.removeUserFromCollaborationGroup("kmr75", "acs224", "user add group")
				def groups = securityService.getCollaborationGroups("acs224")
				println "groups after remove" + groups
				assertFalse(groups.contains("user add group"))
			} catch(Exception e) {
				e.printStackTrace()
				testFailed = true
			} finally {
				securityService.deleteCollaborationGroup("kmr75", "user add group")
			}
		}
		if(testFailed)
			fail("Exception during group create")		
	}
	
	void testAddRoleForUser(){
		def user = GDOCUser.findByUsername("kmr75")
		println "all memberships " + user.memberships
		securityService.createMembership("kmr75","DEVELOPERS",SecurityService.GROUP_MANAGER)
		
	}
	
	
	
	void testCreateDeleteUser(){
		def username = "test75"
		def password = "test"
		def firstName = "fn"
		def lastName = "ln"
		def email = "test75@georgetown.edu"
		def organization = "Georgetown University"
		def department = "LOMBARDI COMPREHENSIVE CANCER CENTER"
		def title = "title"
		def newUser = securityService.createNewUser(username, password, firstName,lastName,email,organization, title,department)
		assertNotNull(newUser)
		println "attempt to delete gdoc user " + newUser.id
		assertTrue(securityService.removeUser(newUser.id.toString()))
	}
	
	void testCreateDeleteGUUser(){
		def username = "ncstest2"
		def department = "LOMBARDI COMPREHENSIVE CANCER CENTER"
		def newUser = securityService.validateNetId(username,department)
		assertNotNull(newUser)
		println "attempt to delete gdoc user " + newUser.id
		assertTrue(securityService.removeUser(newUser.id.toString()))
	}
	**/
	
}