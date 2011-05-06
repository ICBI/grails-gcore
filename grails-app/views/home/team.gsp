<html>
    <head>
        <title><g:message code="home.teamTitle" /></title>
		<meta name="layout" content="splash" />
		<g:javascript library="jquery"/>
		
    </head>
    <body>
	
		<div id="centerContent" style="margin:0pt auto;width:65%;padding-bottom:20px">
			<p style="font-size:14pt"><b><g:message code="home.teamHeading" args="${[appTitle()]}"/></b></p><br/>
			<g:render template="/home/members" />
			
		</div>
		
	</body>
	
</html>