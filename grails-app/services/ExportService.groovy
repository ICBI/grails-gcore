class ExportService {
	
	def exportList(out, listId) {
		def list = UserList.get(listId)
		def items = list.listItems
		def output = ""
		if(items.metaClass.respondsTo(items,'join')){
			items.each{ item ->
				output += item.value + "\n"
			}
		}else { 
				output += item.value + "\n"
		}
		
		out << output
	}

}