import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject
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
			def query = ['gene_list': symbols, 'annotation_file': "Geneset.db.V1.txt"]
			def results = ServiceUtil.call("service/gene_enrichment/", query)
			def columns = [
				[name: "pathwayNames", title: "Pathway", converter: {item -> item.split("--")[0] }],
				[name: "pvalues", title: "p-value", converter: {item ->  item.toDouble() }],
				[name: "overlaps", title: "Overlapping Genes", converter: {item -> item.split(",") }]
			]
			def gridWrapper = new GridWrapper(columns, results, { dataItem ->
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