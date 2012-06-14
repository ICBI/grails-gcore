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
	changeSet(author: "acs224", id: "make-attribute-fields-nullable") {
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  columnName: 'QUALITATIVE')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  columnName: 'CONTINUOUS')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  columnName: 'VOCABULARY')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  columnName: 'ORACLE_DATATYPE')	
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  columnName: 'CLASS')		
	}
	
	changeSet(author: "acs224", id: "drop-check-attribute") {
		dropCheck(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE',  constraintName: 'ATT_TYPE_GDOC_PREFERRED_CC')
	}
	
	changeSet(author: "acs224", id: "update-vocabs") {
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_VOCABULARY',  columnName: 'DEFINITION')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_VOCABULARY',  columnName: 'INSERT_USER')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_VOCABULARY',  columnName: 'INSERT_DATE')
		dropNotNullConstraint(schemaName: 'COMMON', tableName: 'ATTRIBUTE_VOCABULARY',  columnName: 'INSERT_METHOD')
		
	}
	
	changeSet(author: "acs224", id: "modify-vocab") {
		modifyDataType(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE', columnName: "SHORT_NAME", newDataType: "VARCHAR2(100)") 
	}
	
}
