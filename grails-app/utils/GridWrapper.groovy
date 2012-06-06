import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject

class GridWrapper {
	
	def columns
	def rawData
	def currentData
	def dataMapper
	
	public GridWrapper(columnData, data, itemMapper) {
		columns = columnData
		rawData = data
		buildData(rawData)
		dataMapper = itemMapper
	}
	
	def getData(params) {
		
		def data = []
		def rows = params.rows.toInteger()
		def currPage = params.page.toInteger()
		def startIndex = ((currPage - 1) * rows)
		def endIndex = (currPage * rows)
		def sortColumn = params.sidx
		if(endIndex > rawData.size()) {
			endIndex = rawData.size()
		}
		if(rawData instanceof JSONObject) {
			def cell = [id: "error", cell: [rawData.error, "", ""]]
			data << cell
		} else {
			currentData = currentData.sort { r1, r2 ->
				if(params.sord != 'asc') {
					if(!r1[sortColumn])
						return -1
					if(!r2[sortColumn])
						return 1
					else 
						return r1[sortColumn].compareTo(r2[sortColumn])
				} else {
					if(!r1[sortColumn])
						return 1
					if(!r2[sortColumn])
						return -1
					else
						return r2[sortColumn].compareTo(r1[sortColumn])
				}
			}
			currentData.getAt(startIndex..<endIndex).each {
				def cell = dataMapper(it)
				data << cell
			}
		}
		def jsonObject = [
			page: currPage,
			total: Math.ceil(currentData.size() / rows),
			records: currentData.size(),
			rows:data
		]
		return jsonObject as JSON
	}
	
	def buildData(data) {
		def tempItems = []
		if(!(data instanceof JSONObject)) {
			data.each { item ->
				def tempData = [:]
				columns.each {
					tempData[it.name] = it['converter'](item[it.name])
				}
				tempItems << tempData
			}
		}
		currentData = tempItems
	}
	
	def export(response) {
		response.setHeader("Content-disposition", "attachment; filename=data_export.csv")
		response.contentType = "application/octet-stream" 

		def outs = response.outputStream 
		def cols = [:] 
		outs << columns.collect{it.title}.join(",") + "\n"
		currentData.each { data ->
			def temp = []
			columns.each {
				if(!data[it.name])
					temp << ''
				else
					temp << "\"" + data[it.name] + "\""
			}
			outs << temp.join(",")
		    outs << "\n"
		}
		outs.flush()
		outs.close()
	}
}