<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		
		<STYLE type="text/css">
		A:link {color:#336699}
		A:visited {color:#336699}
		A:hover {color:#334477}
		   #tooltip {
		text-align:left;
		font-size: 100%;
		min-width: 90px;
		max-width: 180px;
		.workflowBox {
			
		}
		 </STYLE>
    </head>
    <body>
		<br><br>
		<div class="hero-unit">
		  <h1>Welcome!</h1>
		  <p>&nbsp;</p>
		  <p >Do you have a study you are interested in exploring?</p>
		  <p>
		  	<g:link class="btn btn-success btn-large" style="color:#FFF" action="chooseStudy" >Yes<br><small>Take me to study selection page</small></g:link>
		  	<g:link class="btn btn-danger btn-large" style="color:#FFF" action="choosePath">No<br><small>I don't know what this means</small></g:link>
		  </p>
		</div>
    </body>
</html>