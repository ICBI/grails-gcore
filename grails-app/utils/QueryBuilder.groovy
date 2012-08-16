class QueryBuilder {

	static def build = { params, formKey, dataTypes, ranges, advancedQuery ->
		log.debug "build query for $formKey"
		def criteria = [:]
		params.each { key, value ->
			if(key.contains(formKey) && value) {
				if(key.contains("range_")) {
					def minMax = [:]
					minMax["min"] = value.split(" - ")[0].toDouble()
					minMax["max"] = value.split(" - ")[1].toDouble()
					def attrName = key.substring(key.indexOf("range_") + 6)
					def range = dataTypes.find {
						it.shortName == attrName
					}
					if(advancedQuery){
						def lowerRange = ranges[attrName]["lowerRange"]
						def upperRange = ranges[attrName]["upperRange"]
						if(minMax["min"] != lowerRange.toInteger() || minMax["max"] != upperRange.toInteger()) {
							criteria[key.replace(formKey + "range_", "")] = minMax
						}
						log.debug "advanced criterai " + criteria
					}else{
						criteria[key.replace(formKey + "range_", "")] = minMax
					}
						
				} else if (key.contains("vocab_")){
						if(value.metaClass.respondsTo(value, 'join')){
							def values = []
							value.each{
								values << it
							}
							criteria[key.replace(formKey + "vocab_", "")] = values 
						}
						else{
							value = value.replace("'", "")
							criteria[key.replace(formKey + "vocab_", "")] = value
						}
						
				} else if (value.metaClass.respondsTo(value, 'join')) {
					if(value[0] || value[1]) {
						def minMax = [:]
						minMax["min"] = value[0]
						minMax["max"] = value[1]
						if(!value[0]) {
							minMax["min"] = Integer.MIN_VALUE
						} else if(!value[1]) {
							minMax["max"] = Integer.MAX_VALUE
						}
						criteria[key.replace(formKey, "")] = minMax
					}
				} else {
					value = value.replace("'", "")
					criteria[key.replace(formKey, "")] = value
				}
			} else if(key == "timepoint" && value) {
				println "adding timepoint $value"
				criteria[key] = value
			}
		}
		return criteria
	}

}