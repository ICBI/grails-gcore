import org.codehaus.groovy.grails.web.converters.marshaller.json.DomainClassMarshaller
import org.codehaus.groovy.grails.web.converters.exceptions.ConverterException
import org.codehaus.groovy.grails.commons.GrailsDomainClassProperty
import org.codehaus.groovy.grails.commons.GrailsDomainClass
import grails.converters.JSON
import gov.nih.nci.caintegrator.analysis.messaging.ExpressionLookupResult

public class ExpressionLookupResultMarshaller extends DomainClassMarshaller {

	public boolean supports(Object object) {
		return (object instanceof ExpressionLookupResult)
	}
	
	public void marshalObject(Object value, JSON json) {
		log.debug "CONVERTING JSON 2 ${value}"
		/*
		json.build{
			taskId(value.taskId)
			dataVectors {
				value.dataVectors.each {
					name(it.name)
					dataPoints(it.dataPoints)
				}
			}
		}
		*/
		def item = value
		def result = [:]
		def items = []
		result["taskId"] = item.taskId
		item.dataVectors.each { 
			def vector = [:]
			vector["name"] = it.name
			vector["dataPoints"] = it.dataPoints
			items << vector
		}
		result["dataVectors"] = items
		json.value(result)
	}
}