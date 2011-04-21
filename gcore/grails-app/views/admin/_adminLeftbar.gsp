
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
	<ul id="mygdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:link controller="#">Users</g:link>
		</li>
		<li>
			<g:link name="Groups" controller="#">Groups</g:link>
		</li>
		<li>
			<g:link name="Protected Artifacts" controller="protectedArtifact">Protected Artifacts</g:link>
		</li>
		<li>
			<g:link name="Invitations" controller="#">Invitations</g:link>
		</li>
</div>







