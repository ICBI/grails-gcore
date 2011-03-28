import gov.nih.nci.caintegrator.analysis.messaging.ExpressionLookupRequest
import gov.nih.nci.caintegrator.analysis.messaging.PrincipalComponentAnalysisRequest
import gov.nih.nci.caintegrator.analysis.messaging.ChromosomalInstabilityIndexRequest
import gov.nih.nci.caintegrator.analysis.messaging.HeatMapRequest
import gov.nih.nci.caintegrator.analysis.messaging.SampleGroup
import gov.nih.nci.caintegrator.analysis.messaging.ReporterGroup
import gov.nih.nci.caintegrator.enumeration.*
import org.springframework.jms.core.JmsTemplate
import org.springframework.jms.core.MessageCreator
import org.springframework.web.context.request.RequestContextHolder as RCH

class AnalysisService {

	def receiveQueue
	def jmsTemplate
	def savedAnalysisService
	def annotationService
	def idService
	def extensionService
	 
	def strategies = [
		(AnalysisType.CLASS_COMPARISON): { sess, cmd ->
			return null
		},
		(AnalysisType.GENE_EXPRESSION): { sess, cmd ->
			def request = new ExpressionLookupRequest(sess, "ExpressionLookup_" + System.currentTimeMillis())
			request.dataFileName = cmd.dataFile
			def sampleGroup = new SampleGroup()
			sampleGroup.addAll(idService.sampleIdsForFile(cmd.dataFile))
			def reporterGroup = new ReporterGroup()
			reporterGroup.addAll(cmd.reporters)
			request.reporters = reporterGroup
			request.samples = sampleGroup
			return request
		},
		(AnalysisType.KM_GENE_EXPRESSION): { sess, cmd ->
			
			return null
		},
		(AnalysisType.PCA): { sess, cmd ->
			return null
		},
		(AnalysisType.HEATMAP): { sess, cmd ->

		},
		(AnalysisType.CIN): { sess, cmd ->
			return null
		}
	]
	
	def sendRequest(sessionId, command, tags) {
		def request
		log.debug "in send request"
		try {
			def userId = RCH.currentRequestAttributes().session.userId
			log.debug "sending message: $userId"
			request = extensionService.buildRequest(userId, command)
			log.debug request
			def item = ["status": "Running", "item": request]
			def newAnalysis = savedAnalysisService.addSavedAnalysis(userId, item, command, tags)
			jmsTemplate.send([
				createMessage: { Object[] params ->
					def session = params[0]
					def message = session.createObjectMessage(request)
					message.setJMSReplyTo(receiveQueue)
					return message
				}
			] as MessageCreator)
			log.debug "after send"
		} catch (Exception e) {
			log.error "Failed to send request for test " + e
		}
		return request.taskId
	}
	
}