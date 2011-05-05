<html>
    <head>
        <meta name="layout" content="maxSpaceLayout" />
		</script>
        <title><g:message code="study.title"/></title>         
    </head>
    <body>
	<p style="font-size:14pt"><g:message code="study.title"/></p>
	<br/>
	
	<div id="centerContent" class="welcome" style="width: 90%">
		<g:panel id="studyPanel" title="My Studies" styleClass="welcome" collapse="true">
				<table class="studyTable">
					<tr>
						<th><g:message code="study.name"/></th>
						<th style="width:25%"><g:message code="study.description"/></th>
						<th><g:message code="study.pi"/></th>
						<th><g:message code="study.disease"/></th>
						<th><g:message code="study.poc"/></th>
					</tr>
					<g:each in="${myStudies}" var="study">
					<tr>
						<td><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
						<td>${study.longName}</td>
						<td>
							<g:each in="${study.pis}" var="pi">
								${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
							</g:each>
						</td>
						<td>${study.disease}</td>
						<td>
							<g:each in="${study.pocs}" var="poc">
								${poc.firstName} ${poc.lastName}<br/><br/>
							</g:each>
						</td>
					</tr>
					</g:each>
				</table>
		</g:panel>
		<br/>
		<g:panel id="studyPanel2" title="Other Studies" styleClass="welcome" collapse="true">
		<table class="studyTable">
			<tr>
				<th><g:message code="study.name"/></th>
				<th style="width: 25%"><g:message code="study.description"/></th>
				<th><g:message code="study.pi"/></th>
				<th><g:message code="study.disease"/></th>
				<th><g:message code="study.poc"/></th>
			</tr>
			<g:each in="${otherStudies}" var="study">
			<tr>
				<td><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
				<td>${study.longName}</td>
				<td>
					<g:each in="${study.pis}" var="pi">
						${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
					</g:each>
				</td>
				<td>${study.disease}</td>
				<td>
					<g:each in="${study.pocs}" var="poc">
						${poc.firstName} ${poc.lastName}<br/><br/>
					</g:each>
				</td>
			</tr>
			</g:each>
		</table>
		</g:panel>
	</div>
	</body>
	
</hmtl>