<html>
    <head>
        <title><g:message code="home.teamTitle" args="${[appTitle()]}" /></title>
		<meta name="layout" content="noHeaderLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		
    </head>
    <body>
    <div class="welcome-title"><g:message code="home.teamHeading" args="${[appTitle()]}"/></div>
		<div class="features">
			<g:render template="/home/members"/>
		</div>
		
	</body>
	
</html>