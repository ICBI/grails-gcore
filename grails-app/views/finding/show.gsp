<%@ page import="org.springframework.util.ClassUtils" %>
<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="findings.finding" /> ${params?.id}</title>  
 		<g:javascript library="jquery" plugin="jquery"/>
      	<jq:plugin name="tooltip"/>
		<jq:plugin name="ui"/>
		<g:javascript>
			function toggle(element){
				$('#'+element+'_content').slideToggle();
				$('.'+element+'_toggle').toggle();
			}
		</g:javascript>
    </head>
    <body>
	<div class="welcome-title"><g:message code="findings.title" /></div>
	<br/>
	
	<div id="centerContent" class="features">
		<g:if test="${finding}">
			<table class="viewerTable table" style="width: 95%;">
				<tbody><tr>
					<td style="background-color: #D9EDF7;"><b><g:message code="findings.findingTitle" /> </b>:<i>${finding.title}</i></td>
				</tr>
				<g:if test="${finding.principalEvidence}">
				<tr>
					<td><b><g:message code="findings.principalEvidence" /> </b>:
					<g:render template="/finding/evidenceViewer" model="${['evidence':finding.principalEvidence,'principal':true]}" plugin="gcore"/></td>
				</tr>
				</g:if>
				<tr>
					<td><b><g:message code="findings.curator" /> </b>: ${finding.author?.firstName}&nbsp;${finding.author?.lastName}</td>
				</tr>

				<tr>
					<td><b><g:message code="findings.datePosted" /> </b>: <g:formatDate date="${finding.dateCreated}" format="M/dd/yyyy"/></td>
				</tr>


				<tr>
					<td><b><g:message code="findings.description" /> </b>:<br />
						${finding.description}</td>
				</tr>
				<g:if test="${finding.supportingEvidence}">
				<tr>
					<td><b><g:message code="findings.supportingEvidence" /> </b>:<br />
						<g:each in="${finding.supportingEvidence}" var="evidence">
						    <br />
			                <g:render template="/finding/evidenceViewer" model="${['evidence':evidence]}" plugin="gcore"/>
						</g:each>
					</td>
				</tr>
				</g:if>

				</tbody>
			</table><br>
		</g:if>
		<g:else>
			<p style="font-size:12pt"><g:message code="findings.noFindingFound" /> : ${params.id}</p>
		</g:else>
	</div>
	
	</body>
</html>