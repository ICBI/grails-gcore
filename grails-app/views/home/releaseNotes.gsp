<html>
    <head>
        <title>${g.appTitle()} - Release Notes</title>
		<meta name="layout" content="noHeaderLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		
    </head>
    <body>

    <div class="welcome-title"> What's New in ${g.appTitle()}</div>

    <div class="features">
       <g:render template="/home/releaseNotesDetail" />
	</div>

    </body>
	
</html>