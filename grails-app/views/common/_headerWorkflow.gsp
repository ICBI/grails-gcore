
<jq:plugin name="autocomplete"/>



<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
<a href="/${appName()}"><img src="${createLinkTo(dir:'images',file:'gdocHeader.png')}" border="0" alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a>
</td><td valign="bottom" style="text-align:right;padding:7px">
<span style="color:white"><g:formatDate format="EEE MMM d, yyyy" date="${new Date()}"/></span><br />

<sec:ifLoggedIn>

<div style="float:right;color:#f2f2f2">
	<div><g:message code="header.loggedInAs"/>: ${session.userId}</div>
	<div>
		<g:if test="${session.isGdocAdmin}">
		<g:link style="color:#f2f2f2" controller="admin"><g:message code="header.admin"/></g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span>
		</g:if>
		<g:link controller="registration" action="passwordReset" style="color:#f2f2f2"><g:message code="header.changePassword"/></g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span>
		<g:link style="color:#f2f2f2" action="index" controller="logout" update="success"><g:message code="header.logout"/></g:link>
	</div>
</div>
</sec:ifLoggedIn>



</td>
</tr></table>