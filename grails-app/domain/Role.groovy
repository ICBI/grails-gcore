class Role {
	static mapping = {
			table 'GDOC_ROLE'
			version false
			id column:'ROLE_ID'
			name column:'NAME'
	}
	
	String name
	
	static constraints = {
		name(blank:false,unique:true)
	}
	
	public String toString(){
		if(this.@name){
			return this.@name
		}
	}
}