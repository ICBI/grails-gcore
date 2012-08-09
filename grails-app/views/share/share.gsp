

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title><g:message code="share.title"/></title>
	<g:javascript library="jquery" plugin="jquery"/>
	<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'thickbox.js')}"></script>
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
	
</head>
<div class="body">
			
			<div class="clinicalSearch">
	<g:if test="${params.failure}">
	<div class="errorMessage" style="color:red">${flash.message}</div><br />
	</g:if>
	<g:if test="${params.success}">
		<div class="successMessage" style="color:#007000">${flash.message}</div><br />
	</g:if>
	<g:if test="${groups}">
		<div class="taskMessage" style="width:85%;font-size:.9em"><g:message code="share.sharedWith" args="${[params.name, groups.size()]}"/></div><br />
	</g:if>
	
	<g:if test="${params.id} || ${flash.cmd?.itemId}">
	
	<g:if test="${!(session.myCollaborationGroups.minus('PUBLIC'))}">
		<p><g:message code="share.sorry"/></p>
	</g:if>
	<g:else>
	<p class="pageHeading">
		<g:message code="share.title"/> 
		<g:if test="${params?.name}">
		'${params?.name}'?
		</g:if>
		<g:if test="${flash.cmd?.name}">
		'${flash.cmd?.name}'?
		</g:if> 
	</p>
	<div class="errorDetail">
		<g:renderErrors bean="${flash.cmd?.errors}" field="groups" />
		<%--g:renderErrors bean="${flash.cmd?.errors}" field="type" /--%>
	</div>
	<div><g:message code="share.select"/> '<span style="color:blue">${params.name}</span>' </div><br />
	<g:form name="shareForm" on404="alert('not found!')" update="[success:'smessage',failure:'error']" 
	    action="shareItem" url="${[controller:'share',action:'shareItem']}"
		onComplete="alert(${flash.message})">
	  	<g:each in="${session.myCollaborationGroups.sort()}" var="group">
			<g:if test="${group != 'PUBLIC'}">
				<input type="checkbox" name="groups" value="${group}" />${group}<br />
			</g:if>
		</g:each>
	<g:if test="${params.type}">
		<g:hiddenField name="type" value="${params.type}" />
	</g:if>
	<g:if test="${flash.cmd?.type}">
		<g:hiddenField name="type" value="${flash.cmd.type}" />
	</g:if>
	<g:if test="${params.name}">
		<g:hiddenField name="name" value="${params.name}" />
	</g:if>
	<g:if test="${flash.cmd?.name}">
		<g:hiddenField name="name" value="${flash.cmd.name}" />
	</g:if>
	<g:if test="${params.id}">
		<g:hiddenField name="itemId" value="${params.id}" />
	</g:if>
	<g:if test="${flash.cmd?.itemId}">
		<g:hiddenField name="itemId" value="${flash.cmd.itemId}" />
	</g:if>
	
	  <br />
	  <input type="submit" value="share" />
	</g:form>
	</g:else>
</g:if>
	</div>
 </div>
</body>
</html>
