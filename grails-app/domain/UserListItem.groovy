
class UserListItem {
	
	static mapping = {
		table 'USER_LIST_ITEM'
	}
	
	static searchable = {
	    parentList reference: true
	}

	static belongsTo = UserList
	UserList parentList
	String value

}
