class AnnotationService {
	
	
	def findReportersForGene(gene) {
		def reporters = searchForReportersByGene(gene)
		if(!reporters) {
			def aliasGene = findGeneByAlias(gene)
			if(aliasGene)
				reporters = searchForReportersByGene(aliasGene.symbol)
		}
		def reporterNames = reporters.collect {
			it.name
		}
		log.debug "REPORTERS ${reporterNames}"
		return reporterNames
	}
	
	def findReportersForGeneAndFile(gene, file) { 
		def platform = findPlatformForFile(file)
		def platformReporters = findReportersByPlatform(platform)
		def geneReporters = findReportersForGene(gene)
		platformReporters.retainAll(geneReporters)
		log.debug "GOT REPORTERS FOR PLATFORM $platformReporters"
		return platformReporters
	}
	
	def findReportersForFile(file) { 
		def platform = findPlatformForFile(file)
		log.debug "PLATFORM: $platform"
		def platformReporters = findReportersByPlatform(platform)
		log.debug "GOT REPORTERS FOR PLATFORM $platformReporters"
		return platformReporters
	}
	
	def findGeneForReporter(reporterId) {
		def reporter = Reporter.findByName(reporterId)
		if(reporter)
			return reporter.geneSymbol
		else 
			return null
	}
	
	def findReportersForGeneList(listName) {
		def list = UserList.findByName(listName)
		
		def listValues = list.listItems.collect {item ->
			item.value
		}
		return findAllReportersForGenes(listValues)
	}
	
	def getReportersForGeneList(listName) {
		def list = UserList.findByName(listName)
		
		def listValues = list.listItems.collect {item ->
			item.value
		}
		return getAllReportersForGenes(listValues)
	}
	
	def findReportersForReporterList(listName) {
		def list = UserList.findByName(listName)

		def listValues = list.listItems.collect {item ->
			item.value
		}
		return listValues
	}
	
	def getReportersForReporterList(listName) {
		def reporterIds = findReportersForReporterList(listName)
		return findReportersByName(reporterIds)
	}
	
	def findGeneByAlias(alias) {
		def geneAlias = GeneAlias.findBySymbol(alias.toUpperCase())
		//log.debug "found geneAlias $geneAlias.symbol"
		if(geneAlias) {
			geneAlias = GeneAlias.findByGeneAndOfficial(geneAlias.gene, true)
			//log.debug "found official geneAlias $geneAlias.symbol , $geneAlias.gene"
		}
		return geneAlias
	}
	
	def findReportersByPlatform(platformName) {
		def criteria = ArrayDesign.createCriteria()
		def reporters = criteria {
			projections {
				reporters {
					property('name')
				}
			}
			eq("platform", platformName)
		}
		return reporters
	}
	
	def findAllReportersForGenes(genes) {
		def queryClosure = { tempIds -> 
			def c = Reporter.createCriteria()
			return c.listDistinct {
				projections {
					property('name')
				}
				'in'("geneSymbol", tempIds)
			}
		}
		def results = QueryUtils.paginateResults(genes, queryClosure)
		log.debug "GOT ${results.size} reporters"
		return results
	}
	
	def findAllGenesForReporters(reporters) {
		def queryClosure = { tempIds -> 
			def c = Reporter.createCriteria()
			return c {
				projections {
					distinct(["name", "geneSymbol"])
				}
				'in'("name", tempIds)
			}
		}
		def results = QueryUtils.paginateResults(reporters, queryClosure)
		def resultMap = [:]
		results.each {
			resultMap[it[0]] = it[1]
		}
		return resultMap
	}
	
	def getAllReportersForGenes(genes) {
		def queryClosure = { tempIds -> 
			def c = Reporter.createCriteria()
			return c.listDistinct {
				'in'("geneSymbol", tempIds)
			}
		}
		def results = QueryUtils.paginateResults(genes, queryClosure)
		log.debug "GOT ${results.size} reporters"
		return results
	}
	
	def findReportersByName(reporters) {
		def queryClosure = { tempIds -> 
			def c = Reporter.createCriteria()
			return c.listDistinct {
				'in'("name", tempIds)
			}
		}
		def results = QueryUtils.paginateResults(reporters, queryClosure)
		log.debug "GOT ${results.size} reporters"
		return results
	}
	
	def searchForReportersByGene(gene) {
		def criteria = Reporter.createCriteria()
		def reporters = criteria.list{
			eq("geneSymbol", gene.toUpperCase())
		}
		return reporters
	}
	
	def findPlatformForFile(fileName) {
		def criteria = Sample.createCriteria()
		def platform = criteria {
			projections {
				design {
					distinct('platform')
				}
			}
			eq("file", fileName)
		}
		return platform[0]
	}
}