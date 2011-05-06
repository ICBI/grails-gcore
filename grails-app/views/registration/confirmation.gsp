<html>
<head>
	<meta name="layout" content="splash" />
	<title><g:message code="registration.confirmation"/></title>
	
</head>
<body>
	<br /><br />
	<g:if test="${flash.message}">
			<div class="message" style="margin:0 auto;">${flash.message}</div>
	</g:if>
	<g:else>
			<div style="margin:0 auto;" align="center"><g:message code="registration.return"/> <g:link controller="home"><g:message code="registration.home" args="${[appTitle()]}"/></g:link></div>
	</g:else>
	
</body>

</html>
