<g:javascript>
jQuery(document).ready(function()
{
	jQuery("ul.sf-menu").superfish({ 
		animation: {height:'show'},   // slide-down effect without fade-in 
		delay:     1200               // 1.2 second delay on mouseout 
	});
});
</g:javascript>
<g:javascript src="jquery/jquery.hoverIntent.js" plugin="gcore"/>
<g:javascript src="jquery/jquery.superfish.js" plugin="gcore"/>

<div id="top-navigation-block" width="100%" style="position: absolute; z-index: 100;">
	<ul id="gdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:navigationLink name="${message(code: 'nav.home', args: [appTitle()])}" controller="workflows" />
		</li>
		<li>
			<a class="sf-with-ul" href="#"><g:message code="nav.search" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:searchLinks menu="true"/>
				</li>		
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#"><g:message code="nav.analyze" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
					<li>
						<g:analysisLinks menu="true"/>
					</li>
			</ul>
		</li>
			<li>
				<a class="sf-with-ul" href="#"><g:message code="workflows.my" args="${ [appTitle()] }"/><span class="sf-sub-indicator"> »</span></a>
				<ul style="display: none; visibility: hidden;">
						<li>
							<a href="${createLink(controller: 'notification')}"><g:message code="nav.notifications" /></a>
							<a href="${createLink(controller: 'userList')}"><g:message code="nav.savedLists" /></a>
							<a href="${createLink(controller: 'savedAnalysis')}"><g:message code="nav.savedAnalyses" /></a>
							<g:link controller="collaborationGroups"><g:message code="nav.groups" /></g:link>
						</li>
				</ul>
			</li>
		<li>
			<g:link controller="help"><g:message code="nav.help" /></g:link>
		</li>		
	</ul>

</div>