
class UserListItem {
	
	static mapping = {
		table 'USER_LIST_ITEM'
		parentList column: 'LIST_ID'
	}
	
	static searchable = {
	    parentList reference: true
	}

	static belongsTo = UserList
	UserList parentList
	String value

}
