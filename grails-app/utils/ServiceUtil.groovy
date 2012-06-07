import grails.converters.JSON
import org.apache.commons.httpclient.HttpClient
import org.apache.commons.httpclient.HttpStatus
import org.apache.commons.httpclient.methods.PostMethod
import org.apache.commons.httpclient.methods.GetMethod
import org.apache.commons.httpclient.methods.RequestEntity
import org.apache.commons.httpclient.methods.StringRequestEntity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import groovy.util.logging.*

@Log
class ServiceUtil {
	
	static call(service, query) {
		HttpClient httpClient = new HttpClient();
		def ngsUrl = CH.config.grails.ngsUrl
		def response
		PostMethod post = new PostMethod("${ngsUrl}/${service}");
  		try {   
			String jsonValue = query as JSON
			post.addRequestHeader("Content-Type", "application/json");
			RequestEntity requestEntity = new StringRequestEntity(jsonValue, "application/json", "UTF-8");
			log.info "send "+jsonValue
			post.setRequestEntity(requestEntity);
			int statusCode = httpClient.executeMethod(post);
			if (statusCode != HttpStatus.SC_OK) {
			     log.error("post method failed: " + post.getStatusLine());
			 } else {
			     byte[] httpResponse = post.getResponseBody();
			     response = new String(httpResponse);
			
			}
		} catch (Exception e) {
			log.error e
			throw e
		}
		return JSON.parse(response as String)
	}
}