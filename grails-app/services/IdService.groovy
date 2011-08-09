class IdService {
	
	def patientService
	
	def samplesForListId(listId) {
		def listValues = getGdocIdsForList(listId)
		
		return sampleNamesForGdocIds(listValues)
	}
	
	def reportersForListId(listId) {
		def list = UserList.get(listId)
		
		def listValues = list.listItems.collect {item ->
			item.value
		}
		return listValues
	}
	
	def sampleNamesForGdocIds(gdocIds) {
		def results = patientService.patientsForGdocIds(gdocIds)
		def sampleIds = []
		results.each { subject ->
			subject.biospecimens.each { specimen ->
				sampleIds << specimen.name
			}
			subject.children.each { child ->
				child.biospecimens.each { specimen ->
					sampleIds << specimen.name
				}
			}
		}
		def ids = []
		log.debug "just the sampleIds: " + sampleIds
		sampleIds = sampleIds.flatten().grep { it }
		
		return sampleIds.intersect(allSamples())
	}
	
	
	def gdocIdsForSampleNames(sampleNames){
		def c = Biospecimen.createCriteria()
	    def	samples = c.listDistinct {
			'in'("name", sampleNames)
		}
		if(samples){
			Set gdocIds = samples.collect{ sample ->
				sample.subject.gdocId
			}
			return gdocIds.flatten()
		}
		return samples
	}
	
	def getGdocIdsForList(listId) {
		def list = UserList.get(listId)
		
		def listValues = list.listItems.collect {item ->
			item.value.toLong()
		}
		return listValues
	}
	
	def sampleIdsForFile(fileName) {
		def samples = Sample.findAllByFile(fileName)
		if(!samples)
			return new ArrayList()
		def ids = samples.collect { it.name }
		return ids
	}
	
	def allSamples() {
		log.debug "all samples: " + Sample.findAll().collect { it.name }
		return Sample.findAll().collect { it.name }
	}
}