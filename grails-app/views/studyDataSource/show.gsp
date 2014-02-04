<html>
<head>
    <meta name="layout" content="maxSpaceLayout" />
    <title>${currStudy.shortName} <g:message code="study.details"/></title>
</head>
<body>
    <div class="welcome-title"><g:message code="study.title"/></div>
	<div class="desc1">${currStudy.shortName} <g:message code="study.details"/></div>

    <g:form controller="StudyDataSource" action="setStudy">
        <g:hiddenField name="study" id="study" value="${currStudy.id}" />
        <g:submitButton class="btn btn-primary" name="Select Study" value="Select Study" />
    </g:form>

	<div id="centerContent" style="margin-right:45px">
		<g:panel id="studyPanel" title="Study Details" styleClass="welcome">
		<table class="table" width="100%">
			<tr>
				<td class="label-bis" width="20%"><g:message code="study.name"/></td>
				<td>${currStudy.shortName}&nbsp;&nbsp;&nbsp;(<g:message code="study.id"/>:${currStudy.id})</td>
			</tr>
			<tr>
				<td class="label-bis" ><g:message code="study.abstract"/></td>
				<td>${currStudy.abstractText}</td>
			</tr>
			<tr>
				<td class="label-bis" ><g:message code="study.pi"/></td>
				<td>
					<g:each in="${currStudy.pis}" var="pi">
						${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/>
					</g:each>
				</td>
			</tr>
			<tr>
				<td class="label-bis" ><g:message code="study.disease"/></td>
				<td>${currStudy.disease}</td>
			</tr>
			<tr>
				<td class="label-bis" ><g:message code="study.poc"/></td>
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
		<table class="table" width="100%">
			<g:if test="${currStudy.content}">
				<tr>
					<td>
						<g:each in="${currStudy.content}" var="content">
							&nbsp;|&nbsp;${content.type}
						</g:each>
					</td>
				</tr>
			</g:if>

		</table>
		</g:panel>
	</div>
	</body>
	
</hmtl>