<g:javascript library="jquery"/>
<g:form action="createCollaborationGroup">
<g:if test="${flash.cmd instanceof CreateCollabCommand}">
	<div class="errorDetail" ><g:renderErrors bean="${flash.cmd?.errors}" field="collaborationGroupName" /></div>
</g:if>
<table class="studyTable" style="font-size:1.05em;width:400px">
	<tr>
		<td><g:message code="collaborationGroup.name" />:</td>
		<td><g:textField name="collaborationGroupName" size="27" maxlength="27" /></td>
	</tr>
	<tr>
		<td><g:message code="collaborationGroup.description" />:</td>
		<td><g:textArea name="description" maxlength="75" /></td>
	</tr>
	<tr>
		<td colspan="2"><g:submitButton name="createCollaborationGroup" class="actionButton" style="float:right" value="${message(code: 'gcore.create')}" /></td>
	</tr>
</table>
</g:form>
