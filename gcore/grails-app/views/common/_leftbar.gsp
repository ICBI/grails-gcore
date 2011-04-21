
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
			<g:navigationLink name="Home" controller="workflows" />
		</li>
		<li>
			<a class="sf-with-ul" href="#">Search<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:searchLinks menu="true"/>
				</li>		
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#">Analyze<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
					<li>
						<g:analysisLinks menu="true"/>
					</li>
			</ul>
		<li>
			<g:link controller="help">Help</g:link>
		</li>		
	</ul>
</div>

<div id="navigation-block">
	<ul id="mygdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:link controller="notification">Notifications</g:link>
		</li>
		<li>
			<g:link name="View My Saved Lists" controller="userList">Saved Lists</g:link>
		</li>
		<li>
			<g:link name="View My Saved Analysis" controller="savedAnalysis">Saved Analysis</g:link>
		</li>
		<li>
			<g:link name="Collaboration Groups" controller="collaborationGroups">Manage my groups / Request access</g:link>
		</li>
</div>







