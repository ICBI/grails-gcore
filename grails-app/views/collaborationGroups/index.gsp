<html>
    <head>
        <meta name="layout" content="collabLayout" />

	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="ui"/>
        <title><g:message code="collaborationGroups.title" /></title>         
    </head>
    <body>
		
		<g:javascript>
		var page = "index"
		$(document).ready(function(){
			$('#centerTabs').tabs({ selected: 0 });
			
			if(page == "create") {
				$('#centerTabs').tabs('select', 1);
			}
			if(page == "invite") {
				$('#centerTabs').tabs('select', 2);
			}
			if(page == "all") {
				$('#centerTabs').tabs('select', 3);
			}
		});
		
		function toggleUsers(criteria,showHide) {
			$('#'+criteria).slideToggle();
				if($('#'+showHide).html() == "Show users"){
						$('#'+showHide).html("Hide users");
				}else if($('#'+showHide).html() == "Hide users"){
							$('#'+showHide).html("Show users");
				}
		}
		</g:javascript>
		
		<g:if test="${flash.cmd instanceof CreateCollabCommand}">
			<g:javascript>
				var page = "create"
			</g:javascript>
		</g:if>
		<g:if test="${flash.cmd instanceof InviteCollabCommand}">
			<g:javascript>
				var page = "invite"
			</g:javascript>
		</g:if>
		<g:if test="${params.unauthorizedGroup || params.requestGroupAccess}">
			<g:javascript>
				var page = "all"
			</g:javascript>
		</g:if>
		
		<p style="font-size:14pt"><g:message code="collaborationGroups.title" /></p>
		<div id="centerContent">
			<br/>
			<g:if test="${controllerName != 'workflows' && flash.message}">
				<div class="message" style="font-size:.8em;width:85%;">${flash.message.encodeAsHTML()}</div>
			</g:if>
			<g:if test="${flash.error}">
				<div class="errorDetail" style="font-size:.8em;width:85%;">${flash.error.encodeAsHTML()}</div>
			</g:if>
			<div class="tabDiv">
				<div id="centerTabs" class="tabDiv">
				    <ul>
				        <li><a href="#fragment-4"><span><g:message code="collaborationGroups.myGroups" /></span></a></li>
				        <li><a href="#fragment-5"><span><g:message code="collaborationGroups.createGroup" /></span></a></li>
						<li><a href="#fragment-6"><span><g:message code="collaborationGroups.inviteUsers" /></span></a></li>
						<li><a href="#fragment-7"><span><g:message code="collaborationGroups.requestAccess"/></span></a></li>
				    </ul>
					
					 <div id="fragment-4">
	<g:render template="/collaborationGroups/collabTable" model="${['managedMemberships':managedMemberships,'otherMemberships':otherMemberships]}" plugin="gcore"/>
					</div>
				
					<div id="fragment-5">
						<g:render template="/collaborationGroups/createGroupForm" plugin="gcore"/>	
					</div>
					
					<div id="fragment-6">
						<g:render template="/collaborationGroups/inviteUsersForm" plugin="gcore"/>
					</div>
					
					<div id="fragment-7">
						<g:render template="/collaborationGroups/allCollabTable" model="${['allMemberships':allMemberships]}" plugin="gcore"/>
					</div>
					
				</div>
			</div>
			<br /><br />
		</div>
		
		</body>
		
</html>