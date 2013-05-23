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
	<ul id="adminNavigations" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:navigationLink name="${g.appTitle()} Home" controller="workflows" />
		</li>
		<li>
			<g:navigationLink name="${message(code: 'admin.nav.home')}" controller="admin" />
		</li>
		<li>
			<a class="sf-with-ul" href="#"><g:message code="admin.nav.users" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:link controller="GDOCUser"><g:message code="admin.nav.viewAllUsers" /></g:link>
				</li>
				<li>
					<g:link controller="GDOCUser" action="create"><g:message code="admin.nav.createNewUsers" /></g:link>
				</li>	
				<li>
					<g:link controller="membership" action="list"><g:message code="admin.nav.manageMemberships" /></g:link>
				</li>
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#"><g:message code="admin.nav.groups" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
					<li>
						<g:link controller="collaborationGroup"><g:message code="admin.nav.viewAllGroups" /></g:link>
					</li>
					<li>
						<g:link controller="collaborationGroup" action="create"><g:message code="admin.nav.createNewGroup" /></g:link>
					</li>
					<li>
						<g:link controller="invitation"><g:message code="admin.nav.viewInvitations" /></g:link>
					</li>
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#"><g:message code="admin.nav.artifacts" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:link controller="protectedArtifact"><g:message code="admin.nav.viewAllArtifacts" /></g:link>
				</li>
				<li>
					<g:link controller="protectedArtifact" action="create"><g:message code="admin.nav.createNewArtifact" /></g:link>
				</li>	
			</ul>
		</li>	
		<li>
			<a class="sf-with-ul" href="#"><g:message code="admin.nav.roles" /><span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<g:link controller="role"><g:message code="admin.nav.viewAllRoles" /></g:link>
				</li>
				<li>
					<g:link controller="role" action="create"><g:message code="admin.nav.createNewRole" /></g:link>
				</li>	
			</ul>
		</li>
	</ul>
</div>