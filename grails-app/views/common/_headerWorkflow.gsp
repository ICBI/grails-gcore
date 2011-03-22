
<jq:plugin name="autocomplete"/>



<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
<a href="/${appName()}"><img src="${createLinkTo(dir:'images',file:'gdocHeader.png')}" border="0" alt="G-DOC logo" /></a>
</td><td valign="bottom" style="text-align:right;padding:7px">
<span style="color:white"><g:formatDate format="EEE MMM d, yyyy" date="${new Date()}"/></span><br />

<sec:ifLoggedIn>

<div style="float:right;color:#f2f2f2">
	<div>Logged in as: ${session.userId}</div>
	<div>
		<g:if test="${session.isGdocAdmin}">
		<g:link style="color:#f2f2f2" controller="admin">Admin</g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span>
		</g:if>
		<%--g:link controller="registration" action="passwordReset" style="color:#f2f2f2">change password</g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span--%>
		<g:link style="color:#f2f2f2" action="index" controller="logout" update="success">Logout</g:link>
	</div>
</div>
</sec:ifLoggedIn>



</td>
</tr></table>