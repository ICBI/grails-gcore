class MoleculeTarget{
	static mapping = {
		table 'DRUG.MOLECULE_TARGET'
	}
	
	static searchable = {
		alias "targets"
	    molecule component: true
		protein component: true
		structures component: true
		targetRelationships component: true
		dateCreated index: 'no'
		lastUpdated index: 'no'
	}
	
	String bindingData
	static belongsTo = [Molecule, Protein]
	
	static hasMany = [structures: Structure, targetRelationships:TargetRelationships]
	Molecule molecule
	Protein protein
	Date dateCreated
	Date lastUpdated
	static constraints = {
		molecule(nullable:false)
		protein(nullable:false)
	}
	
	public String toString() {
		if(this.@protein && this.@molecule) {
			return this.@id + "-" + this.@protein.gene.id
		}
	}
	
}