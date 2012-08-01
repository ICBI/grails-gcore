<g:javascript library="jquery" plugin="jquery"/>
<div style="padding-right:10px">
<table class="studyTable" style="font-size:.85em;">
<tr><th style="background-color:#FFFFCC"><g:message code="notifications.invites.heading" /> (<span style="font-style:italic"><g:message code="notifications.invites.last90" /></span>)</th></tr>
<tr><td>
	<g:set var="availableInvites" value="false" />
	<g:if test="${session.invitations}">
	<g:if test="${session.invitations['inv'] || session.invitations['req'] || session.invitations['reqAndMan'] || session.invitations['invNotMan']}">
		<g:if test="${session.invitations['inv']}">
			<g:each in="${session.invitations['inv']}" var="inInvite">
			<g:if test="${inInvite.status == InviteStatus.PENDING}">
			<g:set var="availableInvites" value="true" />
			<div class="inviteDiv" style="border:1px solid red"><g:message code="notifications.invites.requestedToYou" args="${[inInvite.requestor.firstName,inInvite.requestor.lastName,inInvite.requestor.email,inInvite.group.name]}" />
				&nbsp;&nbsp;&nbsp; 
				<g:link action="grantAccess" controller="collaborationGroups" id="${inInvite.id}" params="[user:inInvite.requestor.username,group:inInvite.group.name]"><g:message code="notifications.invites.grantAccess" /></g:link>
				&nbsp;&nbsp;&nbsp;
				<g:link action="rejectInvite" controller="collaborationGroups" id="${inInvite.id}" params="[user:inInvite.requestor.username,group:inInvite.group.name]"><g:message code="notifications.invites.rejectAccess" /></g:link>
				</div>
			</g:if>
			</g:each>
	   </g:if>
		<g:if test="${session.invitations['invNotMan']}">
			<g:each in="${session.invitations['invNotMan']}" var="inInvite">
			<g:if test="${inInvite.status == InviteStatus.PENDING}">
			<g:set var="availableInvites" value="true" />
			<div class="inviteDiv" style="border:1px solid red"><g:message code="notifications.invites.inviteToYou" args="${[inInvite.requestor.firstName,inInvite.requestor.lastName,inInvite.group.name]}" /> 
				&nbsp;&nbsp;&nbsp; <br />
				<g:message code="notifications.invites.received" /><g:formatDate format="EEE MMM d, yyyy" date="${inInvite.dateCreated}"/><br />
				<g:link action="addUser" controller="collaborationGroups" id="${inInvite.id}" params="[user:session.userId,group:inInvite.group.name]"><g:message code="notifications.invites.acceptInvitation" /></g:link>
				&nbsp;&nbsp;&nbsp;
				<g:link action="rejectInvite" controller="collaborationGroups" id="${inInvite.id}" params="[user:session.userId,group:inInvite.group.name]"><g:message code="notifications.invites.rejectAccess" /></g:link>
				</div>
			</g:if>
			<g:if test="${inInvite.status == InviteStatus.WITHDRAWN}">
			<g:set var="availableInvites" value="true" />
			<div class="inviteDiv"><g:message code="notifications.invites.withdrawn" args="${[inInvite.group.name]}" /> 
				&nbsp;&nbsp;&nbsp; <br />
				<g:message code="notifications.invites.received" /><g:formatDate format="EEE MMM d, yyyy" date="${inInvite.dateCreated}"/><br />
				</div>
			</g:if>
			</g:each>
		</g:if>
	   	<g:if test="${session.invitations['req']}">
			<g:set var="availableInvites" value="true" />
			<g:each in="${session.invitations['req']}" var="reqInvite">
			<div class="inviteDiv"><g:message code="notifications.invites.requestedFromYou" args="${[reqInvite.group.name,reqInvite.status]}" /><br />
				<g:message code="notifications.invites.sent" /><g:formatDate format="EEE MMM d, yyyy" date="${reqInvite.dateCreated}"/> | <g:message code="notifications.invites.updated" /><g:formatDate format="EEE MMM d, yyyy" date="${reqInvite.lastUpdated}"/>
			</div>
			</g:each>
	  	</g:if>
	  	<g:if test="${session.invitations['reqAndMan']}">
			<g:set var="availableInvites" value="true" />
			<g:each in="${session.invitations['reqAndMan']}" var="reqInvite">
			<div class="inviteDiv"><g:message code="notifications.invites.inviteFromYou" args="${[reqInvite.invitee.username,reqInvite.group.name,reqInvite.status]}" /><br />
			sent:<g:formatDate format="EEE MMM d, yyyy" date="${reqInvite.dateCreated}"/> | <g:message code="notifications.invites.updated" /><g:formatDate format="EEE MMM d, yyyy" date="${reqInvite.lastUpdated}"/>
			</div>
			</g:each>
		</g:if>
	</g:if>
	</g:if>
	<g:if test="${availableInvites=='false'}">
<g:message code="notifications.invites.nonePending" />
	</g:if>
</td></tr>
</table>
</div>
