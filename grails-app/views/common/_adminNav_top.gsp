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
	<ul id="adminNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:navigationLink name="${appName} Home" controller="workflows" />
		</li>
		<li>
			<a class="sf-with-ul" href="#">Users<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:link controller="GDOCUser">Search for user</g:link>
				</li>
				<li>
					<g:link controller="GDOCUser" action="create">Create new user</g:link>
				</li>	
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#">Collaboration Groups<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
					<li>
						<g:link controller="collaborationGroup">Search for Groups</g:link>
					</li>
					<li>
						<g:link controller="collaborationGroup" action="create">Create New Groups</g:link>
					</li>
					<li>
						<g:link controller="invitation">View Invitations</g:link>
					</li>
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#">Protected Artifacts<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:link controller="protectedArtifact">Search for artifacts</g:link>
				</li>
				<li>
					<g:link controller="protectedArtifact" action="create">Create artifacts</g:link>
				</li>	
			</ul>
		</li>
	</ul>

</div>