<html>
    <head>
        <title><g:message code="collaborationGroups.title" /></title>
		<meta name="layout" content="report" />
		<g:javascript library="jquery" plugin="jquery"/>   
		<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.styledButton.js" plugin="gcore"/>
		<g:jqgrid />
		<g:javascript>
		$(document).ready( function () {
			 // this is unfortunately needed due to a race condition in safari
			 // limit the selector to only what you know will be buttons :)
			$("span.bla").css({
				 'padding' : '3px 20px',
				 'font-size' : '12px'
			});
			$("span.bla").styledButton({
				'orientation' : 'alone', // one of {alone, left, center, right} default is alone
				'role' : 'button', // one of {button, checkbox, select}, default is button. Checkbox/select change some other defaults
				'defaultValue' : "foobar", // default value for select, doubles as default for checkboxValue.on if checkbox, default is empty
				'name' : 'testButton', // name to use for hidden input field for checkbox and select so form can submit values
				// enable a dropdown menu, default is none
				'clear' : true // in firefox 2 the buttons have to be floated to work properly, set this to true to have them display in a new line

			});
		} );

		function showSaveSpinner(show) {
				if(show == true){
					$("#saveSpinner").css("visibility","visible");
					success();
				}else{
					$("#saveSpinner").css("visibility","hidden");
					jQuery('#message').css("display","block");
					success(); 
				}
		}
		</g:javascript>
		<g:javascript>
			var selectedIds = [];
			var selectAll = false;
			var currPage = 1;
			$(document).ready(function(){
				var users = "";
				$("#searchResults").jqGrid({ 
					url:'viewUsers', 
					datatype: "json", 
					colNames:${session.ucolumnNames}, 
					colModel:${session.ucolumnJson}, 
					height: 350, 
					rowNum:25, 
					rowList:[25,50], 
					//imgpath: gridimgpath, 
					pager: $('#pager'), 
					sortname: 'User ID', 
					viewrecords: true, 
					sortorder: "asc", 
					multiselect: true, 
					caption: "User Search Results",
					onSelectAll: function(all, checked) {
						selectAll = checked;
						selectedIds = [];
						$("#users").val("allUsers");
					},
					onPaging: function(direction) {
						if($("#searchResults").getGridParam('selarrrow')) {
								selectedIds[currPage] = $("#searchResults").getGridParam('selarrrow');
						}
					},
					gridComplete: function() {
						currPage = $("#searchResults").getGridParam("page");
						var ids = selectedIds[currPage];
						if(selectAll) {
							selectAllItems();
						} else if(ids) {
							for(var i = 0; i < ids.length; i++) {
								$("#searchResults").setSelection(ids[i]);
							}

							if(ids.length == jQuery("#searchResults").getGridParam("rowNum")) {
								$("#cb_jqg").attr('checked', true);
							}
						}

					},
					onSortCol: function() {
						selectAll = false;
						selectedIds = [];
					}
				});
				
				$("#searchResults").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:false, refresh: false});
				$("#inviteButton").click( function() { 
					var s; 
					if($("#searchResults").getGridParam('selarrrow')) {
							selectedIds[currPage] = $("#searchResults").getGridParam('selarrrow');
					}
					s = selectedIds;
					$("#users").val(s);
					return true;
				});
			});
			
			function selectAllItems() {
				$('#searchResults tbody tr').each(function() {
					$("#searchResults").setSelection(this.id);
				});
				$("#cb_jqg").attr('checked', true);
			}
			function success() {
				$('#list_name').val("");
				window.setTimeout(function() {
				  $('#message').empty().hide();
				}, 2500);


			}
		
			</g:javascript>
    </head>
    <body>
		
		<div id="centerContent" style="padding:25px">
			<p style="font-size:14pt;"><g:message code="collaborationGroups.searchHeading" args="${ [appTitle()] }" /></p>
			<span><g:message code="collaborationGroups.instruction" /></span>
			<br />
			<g:if test="${!session.uresults}">
				<g:message code="collaborationGroups.noUsersFound" />
			</g:if>
			<g:else>
				<g:if test="${session.managedMemberships}">
				<g:if test="${flash.error}">
					<div class="errorDetail" style="font-size:.8em;width:85%;">${flash.error}</div>
				</g:if>
				<g:if test="${flash.cmd instanceof InviteCollabCommand}">
					<div class="errorDetail"><g:renderErrors bean="${flash.cmd?.errors}" as="list" /></div>
				</g:if>
				<g:if test="${flash.message}">
					<br />
					<span id="message" class="message" style="margin-top:10px">${flash.message}</span>
				</g:if>
				<br /><br />
				<table class="studyTable" style="font-size:1.05em;width:400px">
					<tr>
						<td><g:message code="collaborationGroups.name" />:
						
							<g:form action="inviteUsers">
							<g:select name="collaborationGroupName" from="${session.managedMemberships}"
						          noSelection="${['':message(code:'collaborationGroups.chooseGroup')]}"
								  optionValue="name"
								  optionKey="name" />
							<g:hiddenField name="users" id="users" />
							
						</td>
					</tr>
					<tr>
						<td>
						<table id="searchResults" class="scroll" cellpadding="0" cellspacing="0"></table>
						<div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
						</td>
					</tr>
					<tr>
						<td colspan="2"><g:submitButton class="actionButton" id="inviteButton" style="float:right" name="inviteButton" value="${message(code: 'collaborationGroups.sendInvite')}" /></g:form></td>
					</tr>
					</table>
					</g:if>	
			</g:else>
			
			
		</div>
		
	</body>
	
</html>