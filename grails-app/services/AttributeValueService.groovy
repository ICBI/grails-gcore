import org.springframework.jdbc.core.JdbcTemplate
class AttributeValueService {
	def dataSource
	
	def findUpperRange(typeId,study){
		def jdbcTemplate = new JdbcTemplate(dataSource) 
		def upper = jdbcTemplate.queryForList("select max(to_number(a.value)) from $study"+".Subject_Attribute_Value a where a.Attribute_TYPE_ID = " + typeId) //AttributeValue.executeQuery("select max(to_number(a.value)) from AttributeValue a where a.type.id = ?",[typeId])
		def t = upper[0].values() as List
		return new Double(t[0])
	}
	
	def findLowerRange(typeId,study){
		def jdbcTemplate = new JdbcTemplate(dataSource) 
		def lower = jdbcTemplate.queryForList("select min(to_number(a.value)) from $study"+".Subject_Attribute_Value a where a.Attribute_TYPE_ID = " + typeId)
		def t = lower[0].values() as List
		return new Double(t[0])
	}
	
}