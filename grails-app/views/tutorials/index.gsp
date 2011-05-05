<html>
    <head>
        <title><g:message code="tutorial.title" args="${[appLongName()]}"/></title>
		<meta name="layout" content="main" />
		<g:javascript library="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<!-- styling -->
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'scrollable-navig.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'dialog.css')}"/>
		
    </head>
    <body>
	
		<div id="centerContent" style="margin:0pt auto;">
			<p style="font-size:14pt"><g:message code="tutorial.download" args="${[appTitle()]}"/></p>
			<div>
				<p style="font-size:12pt"><g:message code="tutorial.using"/></p>
			   	<ul>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/usingQS1.mp4"/><g:message code="tutorial.using"/> <g:message code="tutorial.part"/> #1</a></li>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/usingQS2.mp4"/><g:message code="tutorial.using"/> <g:message code="tutorial.part"/> #2</a></li>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/usingQS3.mp4"/><g:message code="tutorial.using"/> <g:message code="tutorial.part"/> #3</a></li>
				</ul>
				
			</div>
			<br />
			<div>
				<p style="font-size:12pt"><g:message code="tutorial.example"/></p>
			   	<ul>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/exampleAnalysis1.mp4" /><g:message code="tutorial.example"/> <g:message code="tutorial.part"/> #1</a></li>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/exampleAnalysis2.mp4" /><g:message code="tutorial.example"/> <g:message code="tutorial.part"/> #2</a></li>
					<li style="list-style-type:square;margin-left:25px"><a href="${grailsApplication.config.videosPath}/exampleAnalysis3.mp4" /><g:message code="tutorial.example"/> <g:message code="tutorial.part"/> #3</a></li>
				</ul>
				
			</div>
			
			
		</div>
	
	</body>
	
	
</html>