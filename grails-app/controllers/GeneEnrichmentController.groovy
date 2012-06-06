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
		session.gridData = null
		render(view:"results")
	}
	
	def view = {
		if(!session.gridData) {
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
			def columns = [
				[name: "pathwayNames", title: "Pathway", converter: {item -> item.split("--")[0] }],
				[name: "pvalues", title: "p-value", converter: {item ->  item.toDouble() }],
				[name: "overlaps", title: "Overlapping Genes", converter: {item -> item.split(",") }]
			]
			def gridWrapper = new GridWrapper(columns, JSON.parse(response as String), { dataItem ->
				def pathwayName = dataItem.pathwayNames
				def overlapGenes = dataItem.overlaps
				def sciFormatter = new DecimalFormat("0.000E0")
				def pvalue = sciFormatter.format(dataItem.pvalues.toDouble()).replace('E', ' x 10<sup>') + '</sup>'
				def genes = []
				overlapGenes.each { gene ->
					genes << "<a href=\"#\" class=\"geneLink\">${gene}</a>"
				}
				def cell = [id: dataItem.pathwayNames, cell: [pathwayName, pvalue, genes.join(", ")]]
				return cell
			})
			session.gridData = gridWrapper
		}

		render session.gridData.getData(params)
	}
	
	def download = {
		session.gridData.export(response)
	}
}