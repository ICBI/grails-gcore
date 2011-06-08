<html>
<head>
	<title>Modify List</title>
	<g:javascript library="jquery"/>
	<jq:plugin name="DOMWindow"/>
	
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
	<script type="text/javascript">
		function refreshListPage(){
			window.parent.location.replace(window.parent.location.pathname);
		}
	</script>
	<body>
	<div style="background-color:#f2f2f2;width:100%">
		<p style="font-size:1em;display:inline-table">
			<g:if test="${flash.cmd?.oldName}">
				<g:message code="userList.renameList" args="${ [flash.cmd.oldName] }" />
			</g:if>
			<g:if test="${params?.name}">
				<g:message code="userList.renameList" args="${ [params.name] }" />
			</g:if>
		</p>	
	</div><br />
<div id="editNameContent" align="left" class="clinicalSearch"> 
	<div id="saveForm">
		<g:if test="${flash.message}">
		<div class="message">${flash.message.encodeAsHTML()}</div>
		<div class="taskMessage"><g:message code="userList.refreshing"/></div>
		
		<script>refreshListPage();</script>
		</g:if>
		<g:if test="${flash.error}">
		<div class="errorDetail">${flash.error.encodeAsHTML()}</div>
		</g:if>
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}" />

		</div>
		<g:form action="renameList" >
		
		<table style="width:55%;background-color:#f2f2f2">
			
		<tr>
			<td><g:message code="userList.listName"/>:
			</td>
			<td>
				<g:if test="${flash.cmd?.oldName}">
					<g:hiddenField name="oldName" value="${flash.cmd.oldName}" />
				</g:if>
				<g:if test="${params?.name}">
					<g:hiddenField name="oldName" value="${params.name}" />
				</g:if>
				<g:if test="${flash.cmd?.id}">
					<g:hiddenField name="id" value="${flash.cmd.id}" />
				</g:if>
				<g:if test="${params?.id}">
					<g:hiddenField name="id" value="${params.id}" />
				</g:if>
				<g:textField name="newName" size="15" maxlength="15" value="${flash.cmd?.newName}"/>
				
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:right">
				<input type="button" class="closeEditWindow" value="${message(code:'userList.cancel')}" style="padding-right:5px"/>
				<g:submitButton name="submit" id="submitButton" value="${message(code: 'userList.save')}"/>
			</td>
		</tr>
	</table>
		
		</g:form><br />
		<span class="closeEditWindow" style="float:right;padding-top:5px">
			<a href="javascript:parent.$('#DOMWindowID').closeDOMWindow();"><g:message code="userList.close"/></a></span>
	</div>
	
	
</div>
</body>
</html>