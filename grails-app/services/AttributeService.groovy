class AttributeService {

    boolean transactional = true

    def createAll(attributes) {
		attributes.each {
			if(!CommonAttributeType.findByShortName(it.shortName)) {
				def att = new CommonAttributeType(it)
				if(!att.save(flush:true))
					log.debug att.errors
			}
		}
    }

	def addVocabsToAttribute(shortName, vocabs) {
		def attribute = CommonAttributeType.findByShortName(shortName)
		if(!attribute)
			return
		vocabs.each { item ->
			if(!attribute.vocabs.find { it.term == item.term}) {
				def vocab = new AttributeVocabulary(item)
				attribute.addToVocabs(vocab)
				if(!vocab.save(flush: true))
					log.debug vocab.errors
			}
		}
	}
	
	def inspectAttributes(study) {
		StudyContext.setStudy(study)
		def values = AttributeValue.executeQuery("SELECT DISTINCT a, t from AttributeValue a, CommonAttributeType t where a.commonType = t ")
		def attributes = mapClinicalValues(values)
		attributes.each {
			updateAttribute(it)
		}
	}
	
	def updateAttribute(attribute) {
		def toUpdate = CommonAttributeType.findByShortName(attribute.shortName)
		if(!toUpdate) {
			throw new Exception("Attribute ${attribute.shortName} does not exist!")
		}
		if(attribute.vocabulary) {
			def terms = []
			attribute.terms.each {
				terms << [term: it, termMeaning: it]
				addVocabsToAttribute(attribute.shortName, terms)
			}
		} else {
			if(!toUpdate.upperRange || (attribute.upperRange > toUpdate.upperRange)) {
				toUpdate.upperRange = attribute.upperRange
			}
			if(!toUpdate.lowerRange || (attribute.lowerRange < toUpdate.lowerRange)) {
				toUpdate.lowerRange = attribute.lowerRange
			}
		}
		toUpdate.vocabulary = attribute.vocabulary
		if(!toUpdate.save(flush:true))
			log.debug toUpdate.errors
	}
	
	def mapClinicalValues(values) {
		def clinicalMap = [:]
		values.each {
			if(!clinicalMap[it[1].shortName])
				clinicalMap[it[1].shortName] = new HashSet()
			clinicalMap[it[1].shortName].add(it[0].value)
		}
		def clinicalAttributes = []
		clinicalMap.each { k, v ->
			def attribute = [shortName: k]
			def isVocab = false
			def isNumber = v.every { it.isDouble() }
			if(isNumber) {
				attribute['upperRange'] = v.max().toDouble()
				attribute['lowerRange'] = v.min().toDouble()
			} else {
				isVocab = true
				attribute['terms'] = v
			} 
			attribute['vocabulary'] = isVocab
			clinicalAttributes << attribute
		}
		return clinicalAttributes
	}
}
