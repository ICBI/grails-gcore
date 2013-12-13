<html>
    <head>
        <meta name="layout" content="maxSpaceLayout" />
		</script>
        <title><g:message code="study.title"/></title>         
    </head>
    <body>
	<div class="welcome-title"><g:message code="study.title"/></div>
	<div class="desc">My G-DOC Studies</div>
	<div class="desc1">Below is an overview of your studies in G-DOC. You can explore each study, view the details and use the available tools to analyse and search the data. Public studies are also shown in this list.</div>
    <br/>
	<div id="centerContent" class="welcome">
		<g:panel id="studyPanel" title="My Studies" styleClass="welcome" collapse="true" >
				<table class="studyTable" style="background:white;">
					<tr >
						<th><g:message code="study.name"/></th>
						<th style="width:5%"><g:message code="study.id"/></th>
						<th style="width:25%"><g:message code="study.description"/></th>
						<th><g:message code="study.pi"/></th>
						<th><g:message code="study.disease"/></th>
						<th><g:message code="study.subjectType"/></th>
						<th><g:message code="study.poc"/></th>
					</tr>
					<g:each in="${myStudies}" var="study">
					<tr>
						<td><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
						<td>${study.id}</td>
						<td>${study.longName}</td>
						<td>
							<g:each in="${study.pis}" var="pi">
								${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
							</g:each>
						</td>
						<td>${study.disease}</td>
						<td>${study.subjectType?.replace("_"," ")}</td>
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
	<div class="desc">Other G-DOC Studies</div>
    <div class="desc1">Below is an overview of private G-DOC studies. You can explore each study, view the details and use the available tools to analyse and search the data.</div>
	<div id="centerContent" class="welcome">
		<g:panel id="studyPanel2" title="Other Studies" styleClass="welcome" collapse="true">
		<table class="studyTable"  style="background:white;">
			<tr>
				<th><g:message code="study.name"/></th>
				<th style="width: 25%"><g:message code="study.description"/></th>
				<th><g:message code="study.pi"/></th>
				<th><g:message code="study.disease"/></th>
				<th><g:message code="study.subjectType"/></th>
				
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
				<td>${study.subjectType?.replace("_"," ")}</td>
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