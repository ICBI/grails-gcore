
<g:javascript>
jQuery(document).ready(function()
{
	jQuery("ul.sf-menu").superfish({ 
		animation: {height:'show'},   // slide-down effect without fade-in 
		delay:     1200               // 1.2 second delay on mouseout 
	});
	jQuery('.genePatternLink').click(function() {
		jQuery('#gpForm').submit();
		return false;
	})
});
</g:javascript>
<jq:plugin name="hoverIntent"/>
<jq:plugin name="superfish"/>
<div id="navigation-block">
	<ul id="gdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:navigationLink name="${message(code: 'nav.home', args: [appTitle()])}" controller="workflows" />
		</li>
		<li>
			<g:navigationLink name="${message(code: 'nav.studies', args: [appTitle()])}" controller="studyDataSource" />
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
		<li>
			<g:link controller="help"><g:message code="nav.help" /></g:link>
		</li>		
	</ul>
</div>

<div id="navigation-block">
	<ul id="mygdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:link controller="notification"><g:message code="nav.notifications" /></g:link>
		</li>
		<li>
			<g:link name="View My Saved Lists" controller="userList"><g:message code="nav.savedLists" /></g:link>
		</li>
		<li>
			<g:link name="View My Saved Analysis" controller="savedAnalysis"><g:message code="nav.savedAnalyses" /></g:link>
		</li>
		<li>
			<g:link name="Collaboration Groups" controller="collaborationGroups"><g:message code="nav.groups" /></g:link>
		</li>
</div>







