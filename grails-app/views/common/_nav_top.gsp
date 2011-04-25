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
		</li>
			<li>
				<a class="sf-with-ul" href="#">My G-DOC<span class="sf-sub-indicator"> »</span></a>
				<ul style="display: none; visibility: hidden;">
						<li>
							<a href="${createLink(controller: 'notification')}">Notifications</a>
							<a href="${createLink(controller: 'userList')}">Saved Lists</a>
							<a href="${createLink(controller: 'savedAnalysis')}">Saved Analysis</a>
							<g:link controller="collaborationGroups">Manage My Groups</g:link>
						</li>
				</ul>
			</li>
		<li>
			<g:link controller="help">Help</g:link>
		</li>		
	</ul>

</div>