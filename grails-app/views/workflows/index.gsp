<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>

		<STYLE type="text/css">
		A:link {color:#336699}
		A:visited {color:#336699}
		A:hover {color:#334477}
		   #tooltip {
		text-align:left;
		font-size: 100%;
		min-width: 90px;
		max-width: 180px;
		}
		 </STYLE>
		 <g:javascript>
		 	$(document).ready(function() {
		 	});
		 </g:javascript>
    </head>
    <body>
    <div class="welcome-title">G-DOC Plus Launch Pad!</div>
    <g:if test="${flash.message}">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${flash.message}
        </div>
    </g:if>
    	<div class="desc"> Welcome! The G-DOC Plus Launch Pad is your one-stop resource for learning more about G-DOC and getting started on the platform.</div>
		<div class="content-wrap">
	     	<div class="features">
	     	    <g:render template="/common/launchpad"/>
	     	</div>
        </div>
    </body>
</html>