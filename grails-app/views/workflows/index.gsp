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
		 <g:javascript>
		 	$(document).ready(function() {
		 		
		 	
		 	});
		 </g:javascript>
    </head>
    <body>
		<br><br>
		<g:if test="${flash.message}">
			<div class="alert alert-info">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				${flash.message}
			</div>		
		</g:if>

		<div class="hero-unit">
		  <h1>Welcome!</h1>
		  <p>&nbsp;</p>
		  <p >Do you have a <span style="border-bottom: 1px blue dotted; cursor: help" data-toggle="tooltip" title="Study" id="study">study</span> you are interested in exploring?</p>
		  <p>
		  	<g:link class="btn btn-primary btn-large" style="color:#FFF" action="chooseStudy" >Yes</g:link>
		  	<g:link class="btn btn-large" action="choosePath">No</g:link>
		  </p>
		</div>
    </body>
</html>