import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject
import org.apache.commons.httpclient.HttpClient
import org.apache.commons.httpclient.HttpStatus
import org.apache.commons.httpclient.methods.PostMethod
import org.apache.commons.httpclient.methods.GetMethod
import org.apache.commons.httpclient.methods.RequestEntity
import org.apache.commons.httpclient.methods.StringRequestEntity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import java.text.DecimalFormat


class GeneEnrichmentController {
	
	def enrichGeneList = {
		session.enrichResults = null
		render(view:"results")
	}
	
	def view = {
		if(!session.enrichResults) {
			def geneList = UserList.get(params.id)
			def symbols = geneList.listItems.collect { it.value }
			log.debug(symbols)
			HttpClient httpClient = new HttpClient();
			def ngsUrl = CH.config.grails.ngsUrl
			log.debug ngsUrl
			def query = ['gene_list': symbols]
			def response
			PostMethod post = new PostMethod("${ngsUrl}/service/gene_enrichment/");
	  		try {   
				String jsonValue = query as JSON
				post.addRequestHeader("Content-Type", "application/json");
				RequestEntity requestEntity = new StringRequestEntity(jsonValue, "application/json", "UTF-8");
				log.debug "send "+jsonValue
				post.setRequestEntity(requestEntity);
				int statusCode = httpClient.executeMethod(post);
				if (statusCode != HttpStatus.SC_OK) {
				     log.debug("post method failed: " + post.getStatusLine());
				 } else {
				     log.debug("post method succeeded from cloud: " + post.getStatusLine());
				     byte[] httpResponse = post.getResponseBody();
				     response = new String(httpResponse);
				}
			} catch (Exception e) {
				log.debug e
			}
			session.enrichResults = JSON.parse(response as String)
			print session.enrichResults
		}
		def rows = params.rows.toInteger()
		def currPage = params.page.toInteger()
		def startIndex = ((currPage - 1) * rows)
		def endIndex = (currPage * rows)
		def sortColumn = params.sidx
		def analysisResults = session.enrichResults
		if(endIndex > analysisResults.size()) {
			endIndex = analysisResults.size()
		}
		def data = []
		if(analysisResults instanceof JSONObject) {
			def cell = [id: "error", cell: [analysisResults.error, "", ""]]
			data << cell
		} else {
			analysisResults.each {
				def pathwayName = it.pathwayNames.split("--")[0]
				def overlapGenes = it.overlaps.split(",")
				def sciFormatter = new DecimalFormat("0.000E0")
				def pvalue = sciFormatter.format(it.pvalues.toDouble()).replace('E', ' x 10<sup>') + '</sup>'
				def genes = []
				overlapGenes.each { gene ->
					genes << "<a href=\"#\" class=\"geneLink\">${gene}</a>"
				}
				def cell = [id: it.pathwayNames, cell: [pathwayName, pvalue, genes.join(", ")]]
				data << cell
			}
		}
		def jsonObject = [
			page: 1,
			total: 1,
			records: session.enrichResults.size(),
			rows:data
		]
		render jsonObject as JSON
	}
}