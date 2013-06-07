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
				
					<jq:plugin name="tooltip"/>
				
				<div style="width:85%">
			
				
				
				
				
				
				<div id="centerContent" style="display: inline-block;">
						
						<div style="margin-top:20px;padding-bottom:20px">
							<h3 align="center" style="padding-bottom:10px"> Georgetown Database of Cancer and Disease</h3>
							<g:if test="${flash.message}">
								<div align="center" class="message" style="width:75%;margin:0 auto;text-align:left">${flash.message}</div>
								${flash.message = null}
							</g:if>
							<g:if test="${inviteMessage && requestMessage}">
								<div align="center" class="taskMessage" style="width:75%;margin:0 auto;text-align:left"><g:message code="workflows.youHave" /> <g:link controller="collaborationGroups">${inviteMessage} and ${requestMessage}</g:link> <g:message code="workflows.requiring" /></div>
							</g:if>
							<g:if test="${inviteMessage && !requestMessage}">
								<div align="center" class="taskMessage" style="width:75%;margin:0 auto;text-align:left"><g:message code="workflows.youHave" /> <g:link controller="collaborationGroups">${inviteMessage}</g:link> <g:message code="workflows.requiring" /></div>
							</g:if>
							<g:if test="${!inviteMessage && requestMessage}">
								<div align="center" class="taskMessage" style="width:75%;margin:0 auto;text-align:left"><g:message code="workflows.youHave" /> <g:link controller="collaborationGroups">${requestMessage}</g:link> <g:message code="workflows.requiring" /></div>
							</g:if>
							<p style="font-size:.9em">
							G-DOC offers several workflows lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget diam nisi. Sed eget velit odio. Phasellus at nibh nisi, non euismod ligula. Aliquam volutpat ipsum ullamcorper tellus condimentum eu lacinia elit posuere. Curabitur non felis sed diam rutrum eleifend. Nam suscipit dictum magna eget placerat. Suspendisse potenti. Duis tincidunt eros eu lorem viverra tincidunt.
							</p>
							<br>
							<p style="font-size:.9em">
							Aliquam volutpat ipsum ullamcorper tellus condimentum eu lacinia elit posuere. Curabitur non felis sed diam rutrum eleifend.  Aliquam volutpat ipsum ullamcorper tellus condimentum eu lacinia elit posuere. Curabitur non felis sed diam rutrum eleifend. 
							</p>
						</div>
						
						<div style="margin: 0 auto;width: 95%;">
						<g:link action="research" style="text-decoration:none" class="wf_button">
						<div class="gradButton gray workflowBox" href="#">
							<img src="${createLinkTo(dir: 'images',  file: 'pm.png')}" />
							<h4>Personalized Medicine</h4>
							<p style="font-size:.8em;padding:0px">Patients' molecular diagnostics and clinical data.</p>
						</div>
						</g:link>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<g:link action="research" style="text-decoration:none" class="wf_button">
						<div class="gradButton gray workflowBox">
							<img src="${createLinkTo(dir: 'images',  file: 'tr.png')}" />
							<h4>Translational Research</h4>
							<p style="font-size:.8em;padding:0px">Analytic tools and workflows to enable discovery.</p>
						</div>
						</g:link>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<g:if test="${session.nextGenPlugin}">
							<g:link action="popgen" style="text-decoration:none" class="wf_button">
							<div class="gradButton gray workflowBox">
								<img src="${createLinkTo(dir: 'images',  file: 'pop.png')}" />
								<h4>Population Genetics</h4>
								<p style="font-size:.8em;padding:0px">Race-based, genomic reporting and comparison.</p>
							</div>
							</g:link>
						</g:if>
						<g:else>
							<g:link action="popgen" style="text-decoration:none" class="wf_button" onclick="alert('This functionality requires the Next-Gen Plugin');return false;">
							<div class="gradButton gray workflowBox">
								<img src="${createLinkTo(dir: 'images',  file: 'pop.png')}" />
								<h4>Population Genetics</h4>
								<p style="font-size:.8em;padding:0px">Race-based, genomic reporting and comparison.</p>
							</div>
							</g:link>
						</g:else>
						
						</div>
						<br/>
						
						<!-- root element for scrollable -->
				</div>
				
					</div>
    </body>
</html>