class GDOCUser {
    static mapping = {
		table 'GDOC_USER'
		version false
		id column:'user_id'
		username column: "login_name", unique: true
		firstName column: "first_name"
		lastName column: "last_name"
		options column: 'user_id'
	}
	
	static searchable = [except: 'lastLogin']
	
	String username
	String firstName
	String lastName
	String password
	String email
	String department
	String organization
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	Date lastLogin
	Date dateCreated
	Date lastUpdated
	
	static constraints = {
		username(blank:false)
		firstName(blank:false)
		lastName(blank:false)
		password(blank:false)
		email(blank:false)
		organization(blank:false)
		department(nullable:true)
		lastLogin(nullable:true)
	}
	
	static mappedBy = [invitations:'invitee',requestorInvites:'requestor']	
	static hasMany = [memberships:Membership,comments:Comments, analysis:SavedAnalysis, invitations:Invitation, requestorInvites:Invitation, lists:UserList, options: UserOption]
    static transients = ['groups','groupNames']

	public Object getGroupNames() {
		if(this.@memberships) {
			def groups = []
			def groupNames = new HashSet()
			groups = this.@memberships.collect{it.collaborationGroup}
			if(groups){
				groups.each{
							groupNames << it.name
				}
			}
			return groupNames
		}
	}
	public Object getGroups() {
		if(this.@memberships) {
			def groups = []
			groups = this.@memberships.collect{it.collaborationGroup}
			return groups as Set
		}
	}
}