<g:javascript library="jquery" plugin="jquery"/>
<g:if test="${flash.cmd instanceof DeleteCollabUserCommand}">
	<div class="errorDetail"><g:renderErrors bean="${flash.cmd?.errors}" field="users" /></div>
</g:if>

<table>
	<tr><td style="padding-right:15px;padding-bottom:15px" valign="top">
		<table class="studyTable" style="font-size:1.05em;width:375px">
			<tr><th colspan="2" style="background-color:#FFFFCC"><g:message code="collaborationGroups.managedGroups" /></th></tr>
			<tr><th><g:message code="collaborationGroups.name" /></th>
				<th><g:message code="collaborationGroups.members" /></th>
			</tr>
<g:if test="${managedMemberships}">			
<g:each in="${managedMemberships}" var="manMembership">
	<tr>
	<td valign="top">${manMembership.name.encodeAsHTML()}</td>
	<td style="width:75%">
		<g:if test="${manMembership.users}">
<a href="#" id="${manMembership.id}_showHide" style="color:#FF6F0F;text-decoration:underline;font-weight:normal"        				onClick="toggleUsers('${manMembership.id}_usersDiv','${manMembership.id}_showHide');return false;"><g:message code="collaborationGroups.showUsers" /></a></g:if>
		
		<div id="${manMembership.id}_usersDiv" style="display:none;height:130px;overflow: scroll;">
			<g:if test="${manMembership.users}">
			<g:form name="${manMembership.id}_removeUserForm" action="deleteUsersFromGroup">
			<g:hiddenField name="collaborationGroupName" value="${manMembership.name.encodeAsHTML()}" />
			<ul>
				<g:each in="${manMembership.users}" var="user">
						<g:if test="${user.username != session.userId}">
							<li style="padding:3px 3px 3px 3px">
								<g:checkBox name="users" value="${user.username}" checked="false" />
								&nbsp;${user.firstName}&nbsp;${user.lastName}
							</li>
						</g:if>
				</g:each>
			</ul>
			<g:submitButton class="actionButton" style="float:center;width:105px" onclick="return confirm('Are you sure?');" name="deleteUser" value="${message(code: 'collaborationGroups.removeUsers')}" />
			</g:form>
			</g:if>	
			<g:else><g:message code="collaborationGroups.noUsers" /></g:else>
			<g:form action="deleteGroup" method="post">
				<g:hiddenField name="group" value="${manMembership.id}" />
				<g:submitButton name="deleteGroup" class="actionButton" style="width:150px" onclick="return confirm('Are you sure?');" value="${message(code: 'collaborationGroups.deleteGroup')}" />
			</g:form>		
		</div>
	</td>
	</tr>
</g:each>
</g:if>
<g:else>
<tr><td colspan="2">
<g:message code="collaborationGroups.noGroupsManaged" />
</td></tr>
</g:else>
</table>
</td>

<td style="padding-left:10px" valign="top" rowspan="2">

</td></tr>

<tr><td colspan="2" style="padding-right:15px">
	<table class="studyTable" style="font-size:1.05em;width:375px">
		<tr><th style="background-color:#FFFFCC" colspan="2"><g:message code="collaborationGroups.memberGroups" /></th></tr>
		<tr><th><g:message code="collaborationGroups.name" /></th>
			<th><g:message code="collaborationGroups.members" /></th>
		</tr>
<g:if test="${otherMemberships}">						
<g:each in="${otherMemberships}" var="otherMembership">
	<g:if test="${otherMembership.name != 'PUBLIC'}">
	<tr>
	<td valign="top">${otherMembership.name.encodeAsHTML()}<br /><br />
		<g:form name="${otherMembership.id}_removeMyselfForm" action="deleteUsersFromGroup">
		<g:hiddenField name="collaborationGroupName" value="${otherMembership.name.encodeAsHTML()}" />
		<g:hiddenField name="users" value="${session.userId}" />
		<g:submitButton name="deleteMyself" class="actionButton" style="float:right" onclick="return confirm('Are you sure?');" value="${message(code: 'collaborationGroups.leaveGroup')}" />
		</g:form>
	</td>
	<td style="width:75%" valign="top">
		<g:if test="${otherMembership.users}">
<a href="#" id="${otherMembership.id}_showHide" style="color:#FF6F0F;text-decoration:underline;font-weight:normal"        				onClick="toggleUsers('${otherMembership.id}_usersDiv','${otherMembership.id}_showHide');return false;"><g:message code="collaborationGroups.showUsers" /></a></g:if>
		
		<div id="${otherMembership.id}_usersDiv" style="display:none;height:130px;overflow: scroll;">
			<g:if test="${otherMembership.users}">
			<ul>
				<g:each in="${otherMembership.users}" var="user">
					<g:if test="${user.username != session.userId}">
						<li style="padding:3px 3px 3px 3px">${user.firstName}&nbsp;${user.lastName}</li>
					</g:if>
				</g:each>
			</ul>
			</g:if>
			
		</div>
	</td>
	</tr>
	</g:if>
	<g:else><g:message code="collaborationGroups.noUsers" /></g:else>
</g:each>
</g:if>
<g:else>
<tr><td colspan="2">
<g:message code="collaborationGroups.notAMember" />
</td></tr>
</g:else>
</table>
</td><td>&nbsp;</td></tr>
</table>
