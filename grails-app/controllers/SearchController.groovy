import grails.converters.*
import org.springframework.util.ClassUtils
import org.compass.core.engine.SearchEngineQueryParseException
import java.util.regex.Matcher
import java.util.regex.Pattern
import java.util.Arrays

class SearchController {
	def searchableService

	def index = {
		 def invalidChars = ['*','?','~','[',']','"','+','-','<','>']
		 if (!(params.q?.trim()) || invalidChars.contains(params.q)) {
			log.debug "no params or invalid params"
			flash.message = "no params or invalid params"
			return [:]
		 }
		else{
			try {
			def tbdResults = []
			def suggs = []
            def searchResult = []
			log.debug "search string = $params.q" + "*"
            log.debug "searchableService: "+searchableService
           /* Study.reindex()
            Finding.reindex()
            MoleculeTarget.reindex()
            Protein.reindex()
            Molecule.reindex()
            Structure.reindex()*/
            //TargetRelationships.reindex()
            //searchableService.reindex()
			if(!params.offset){
                log.debug params.offset
                log.debug "Searching :" +params.q


               // searchResult = searchableService.search(params.q+"*", [result:'searchResult',offset:0,max:10,order: "asc"])

               searchResult = searchableService.search([result:'searchResult',defaultOperator:"and",offset:0,max:10,order: "asc"], {
                    must({
                      //  queryString(params.q+"*"+" AND (alias: studies OR alias: Finding)")
                        queryString(params.q+"*"+" AND (alias: studies OR alias: targets OR alias: Finding)")
                       })
               })

			}else{
                log.debug params.offset
                log.debug "Searching :" +params.q

              //  searchResult = searchableService.search(params.q+"*", [result:'searchResult',offset:params.offset,max:10,order: "asc"])
                searchResult = searchableService.search([result:'searchResult',defaultOperator:"and",offset:params.offset,max:10,order: "asc"], {
                    must({
                       // queryString(params.q+"*"+" AND (alias: studies OR alias: Finding)")
                        queryString(params.q+"*"+" AND (alias: studies OR alias: targets OR alias: Finding)")
                    })
                })
            }
                log.debug "got results with null targets=" + searchResult.results


                def array1 = searchResult.results.toArray();
                log.debug "count =" + array1.length
                for (int i = 0; i < array1.length; i++) {
                    log.debug "i is: "+i+", object is: "+array1[i]+", id is: "+array1[i]
                    if(array1[i].getClass() ==  MoleculeTarget) {
                        array1[i] = array1[i].getClass().get(array1[i].id)
                        log.debug "results =" +  array1[i]
                        //log.debug i
                    }
                }
                searchResult.results = Arrays.asList(array1);


                log.debug "got results =" + searchResult.results
                log.debug "Search done!"
           if(!searchResult.results){
                    suggs = gatherTermFreqs(params.q)
                    if(suggs.size()>=5){
                        suggs = suggs.getAt(0..5)
                    }
                }
			return [searchResult:searchResult,suggs:suggs]
		 }
         catch (SearchEngineQueryParseException ex) {
			    return [parseException: true]
		         }
         catch (RuntimeException ex) {
				return [parseException: true]
		        }
		}

	}

	
	def relevantTerms = {
	log.debug "relevantTerms: "+params
		def searchResult = []
		if (!params.q?.trim()) { 
			render ""
		}else{
			 try { 
				searchResult = gatherTermFreqs(params.q)
				render searchResult as JSON
			 } catch (SearchEngineQueryParseException ex) { 
				log.debug ex
				render ""
			 }
		}
		
	}
	
	def userAutocomplete = {
		log.debug params
		def searchResult = []
		if (!params.q?.trim()) { 
			render ""
		}else{
			 try { 
				def terms = []
				terms << GDOCUser.termFreqs("firstName")
				terms << GDOCUser.termFreqs("lastName")
				terms << GDOCUser.termFreqs("username")
				terms.flatten().each{
					if(it.term.contains(params.q.trim()))
						searchResult << it.term
				}
				log.debug searchResult
				render searchResult as JSON
			 } catch (SearchEngineQueryParseException ex) { 
				log.debug ex
				render ""
			 }
		}
		
	}


    def gatherTermFreqs(query){
        def searchResult = []
        try {
            def terms = []
            terms << searchableService.termFreqs("longName")
            terms << searchableService.termFreqs("shortName")
            terms << searchableService.termFreqs("disease")
            terms << searchableService.termFreqs("abstractText")
            terms << GeneAlias.termFreqs("symbol",size:30000)
            terms << searchableService.termFreqs("lastName")
            terms << searchableService.termFreqs("title")
            terms.flatten().each{
                if(it.term.contains(query.trim()))
                    searchResult << it.term
            }
            //log.debug searchResult
            return searchResult
        } catch (SearchEngineQueryParseException ex) {
            log.debug ex
            return []
        }
    }

}