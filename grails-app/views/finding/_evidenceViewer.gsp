<g:javascript library="jquery"/>

<g:if test="${principal}">
	<g:set var="uiId" value="${evidence.id+'_principal'}" />
	<g:if test="${evidence.userList}">
		<div>
		
		<span> 
		<%--g:if test="${(session.sharedListIds.contains(evidence.userList.id)) || evidence.userList.author.username == session.userId}"--%>
			<g:set var="listItems" value="${evidence.userList.listItems.collect{it.value}}" />
			<div style="float:middle"><b><g:message code="findings.userList" />:</b>
			<a href="#" onclick="toggle('${uiId}');return false;" style="cursor: pointer;">${evidence.userList.name}
			<img class="${uiId}_toggle"src="${createLinkTo(dir: 'images', file: 'expand.gif')}" />
			<img class="${uiId}_toggle" src="${createLinkTo(dir: 'images', file: 'collapse.gif')}"
			width="13"
			height="14" border="0" alt="${message(code: 'panel.showHide')}" title="${message(code: 'panel.showHide')}" style="display:none" />
			</a>
			</div>
			<div id="${uiId}_content" style="border:0px solid black;display:none;padding-bottom:5px">
			<span>${listItems}</span><br />
			<g:if test="${evidence.userList.tags.contains('patient')}">
				<a href="#" onclick="return false"><g:message code="findings.viewClinical"/></a>
			</g:if>
			</div>

			</span>
		<%--/g:if--%>


		<span><i>*${evidence.description}</i></span>
		</div>
	</g:if>
	
</g:if>
<g:else>
	<g:set var="uiId" value="${evidence.id}" />
</g:else>

<g:if test="${evidence.url}">
 	<div style="float:middle"><b><g:message code="findings.article" />:</b>
	<span><a href="${evidence.url}" target="_blank">${evidence.url}</a></span>
	</div>
</g:if>

<g:if test="${evidence.userList?.studies}">
	<b><g:message code="findings.associatedStudies" /> </b>
	<g:each in="${evidence.userList.studies}" var="study">
		<g:link controller="studyDataSource" action="show" id="${study.id}">${study.shortName}</g:link>
	</g:each>
</g:if>



<g:if test="${evidence.relatedFinding}">
	<div>
	<span><b><g:message code="findings.relatedFinding" /></b>(<g:link action="show" id="${evidence.relatedFinding.id}">view finding</g:link>): <span style="font-size:.8em">${evidence.relatedFinding.title}</span>
	<span>*${evidence.description}</span>
	</div>
</g:if>