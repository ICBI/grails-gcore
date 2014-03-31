<html>
    <head>
        <meta name="layout" content="main" />
        <title><g:message code="findings.title" args="${ [appTitle()] }" /></title>
    </head>
    <body>
    <div class="welcome-title"><g:message code="findings.title" /></div>
	<div class="desc"><g:message code="findings.mostRecent" /></div>
	<br/>

	<div id="centerContent" class="features">
		<g:each in="${findings}" var="finding">
			<table class="viewerTable" style="width: 95%;">
				<tbody><tr>
					<td style="background-color: #D9EDF7;"><b><g:message code="findings.findingTitle" /></b>:<i>${finding.title}</i></td>
				</tr>


				<tr>
					<td><b><g:message code="findings.curator" /></b>: ${finding.author?.firstName}&nbsp;${finding.author?.lastName}</td>
				</tr>

				<tr>
					<td><b><g:message code="findings.datePosted" /></b>: <g:formatDate date="${finding.dateCreated}" format="M/dd/yyyy"/></td>
				</tr>


				<tr>
					<td><g:link action="show" id="${finding.id}"><g:message code="findings.viewDetails" /></g:link></td>
				</tr>

				</tbody>
			</table><br>
		</g:each>
	</div>
	
	</body>
</html>