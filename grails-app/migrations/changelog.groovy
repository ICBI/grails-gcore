databaseChangeLog = {

	changeSet(author: "kmr75 (generated)", id: "1329337589498-4") {
			addColumn(schemaName: 'GUIPERSIST', tableName: 'SAVED_ANALYSIS') {
				column(name: 'name', type: 'varchar2(255)') {
					constraints(nullable: 'true')
				}
				column(name: 'description', type: 'varchar2(600)') {
					constraints(nullable: 'true')
				}
			}
	 }
	changeSet(author: "kmr75 (generated)", id: "1337700794087-62") {
			addColumn(schemaName: 'GUIPERSIST', tableName: 'USER_LIST') {
				column(name: 'description', type: 'varchar2(600)') {
					constraints(nullable: 'true')
				}
			}
   }
}
