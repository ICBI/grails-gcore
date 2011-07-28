<html>
    <head>
        <meta name="layout" content="maxSpaceLayout" />
		</script>
        <title>${currStudy.shortName} <g:message code="study.details"/></title>         
    </head>
    <body>
	<p style="font-size:14pt">${currStudy.shortName} <g:message code="study.details"/></p>
	<br/>
	<div id="centerContent" style="margin-right:45px">
		<g:panel id="studyPanel" title="Study Details" styleClass="welcome">
		<table class="studyTable" width="100%">
			<tr>
				<td class="label" width="20%"><g:message code="study.name"/></td>
				<td>${currStudy.shortName}&nbsp;&nbsp;&nbsp;(<g:message code="study.id"/>:${currStudy.id})</td>
			</tr>
			<tr>
				<td class="label" ><g:message code="study.abstract"/></td>
				<td>${currStudy.abstractText}</td>
			</tr>			
			<tr>
				<td class="label" ><g:message code="study.pi"/></td>
				<td>
					<g:each in="${currStudy.pis}" var="pi">
						${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/>
					</g:each>
				</td>
			</tr>
			<tr>
				<td class="label" ><g:message code="study.disease"/></td>
				<td>${currStudy.disease}</td>
			</tr>			
			<tr>
				<td class="label" ><g:message code="study.poc"/></td>
				<td>
					<g:each in="${currStudy.pocs}" var="poc">
						${poc.firstName} ${poc.lastName}<br/>
					</g:each>
				</td>
			</tr>
		</table>
		</g:panel>
		<br/>
		<g:panel id="studyPanel" title="Data Type Details" styleClass="welcome" >
		<table class="studyTable" width="100%">
			<g:if test="${currStudy.content}">
				<tr>
					<td>
						<g:each in="${currStudy.content}" var="content">
							&nbsp;|&nbsp;${content.type}
						</g:each>
					</td>
				</tr>
			</g:if>
			<tr>
				<th><g:message code="gcore.dataType"/></th>
				<th><g:message code="study.elements"/></th>
				<th><g:message code="study.search"/></th>
			</tr>
			<tr>
				<g:if test="${clinicalElements}">
					<td><g:message code="study.clinicalData"/></td>
					<td>${clinicalElements.size} <g:message code="study.clinicalElements"/></td>
					<td>
						<g:if test="${allowAccess}">
							<g:link controller="clinical"><g:message code="study.search"/></g:link>
						</g:if>
						<g:else>
							<g:message code="study.noAccess"/>
						</g:else>
					</td>
				</g:if>
				<g:else>
					<td colspan="2"><g:message code="study.noElements"/></td>
					<td><g:message code="study.noSearch"/></td>
				</g:else>
			</tr>
		</table>
		</g:panel>
	</div>
	</body>
	
</hmtl>