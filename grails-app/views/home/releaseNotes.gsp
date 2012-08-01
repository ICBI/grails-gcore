<html>
    <head>
        <title>${g.appTitle()} - Release Notes</title>
		<meta name="layout" content="noHeaderLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		
    </head>
    <body>
	
		<div id="centerContent" style="margin:0pt auto;width:65%;padding-bottom:20px">
			<p style="font-size:14pt"><b>What's New in ${g.appTitle()}</b></p><br/>
			<g:render template="/home/releaseNotesDetail" />
		</div>
		
	</body>
	
</html>