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
	
	changeSet(author: "kmr75", id: "added splitAttribute column") {
			addColumn(schemaName: 'COMMON', tableName: 'ATTRIBUTE_TYPE') {
				column(name: 'SPLIT_ATTRIBUTE', type: 'NUMBER(1)') {
					constraints(nullable: 'true')
				}
			}
   	}

	changeSet(author: "kmr75", id: "defaultValue for splitAttribute") {
	        grailsChange{
	            change{
	                sql.executeUpdate("UPDATE COMMON.ATTRIBUTE_TYPE SET SPLIT_ATTRIBUTE = 0 WHERE SPLIT_ATTRIBUTE IS NULL")
	            }
	        }
 	}

	changeSet(author: "kmr75", id: "re-load used_attributes study views") {
	    def studiez =  Study.findAllByShortNameNotEqual("DRUG")
		studiez.each{ study->
			def schemaName = study.shortName
			log.debug "run $schemaName"
			sql("CREATE OR REPLACE VIEW $schemaName"+".USED_ATTRIBUTES AS SELECT distinct c.attribute_type_id, c.short_name, c.long_name, c.definition, c.class, c.semantic_group, c.gdoc_preferred, c.cadsr_id, c.evs_id, c.qualitative, c.continuous, c.vocabulary, c.oracle_datatype, c.unit, c.upper_range, c.lower_range, s.type as target, c.split_attribute "+
				"FROM common.attribute_type c inner join $schemaName"+".subject_attribute_value v on v.attribute_type_id = c.attribute_type_id inner join $schemaName"+".subject s on v.subject_id = s.subject_id WITH READ ONLY;")
		}
 	}

	
}
