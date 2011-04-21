<html>
    <head>
        <title>GDOC - Administration</title>
		<meta name="layout" content="adminReport" />
		<g:javascript library="jquery"/>   
		<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.styledButton.js" plugin="gcore"/>
		<g:jqgrid />
		<g:javascript>
			var selectedIds = [];
			var selectAll = false;
			var currPage = 1;
			$(document).ready(function(){
				$("#selectuserButton").click(function() {
				  if($("#userField").val() == ""){
					alert("Please select a user below to view details");
					return false;
				   }
				});
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
					sortname: 'id', 
					viewrecords: true, 
					sortorder: "desc", 
					//multiselect: true, 
					caption: "User Search Results",
					onSelectAll: function(all, checked) {
						selectAll = checked;
						selectedIds = [];
					},
					onPaging: function(direction) {
						if($("#searchResults").getGridParam('selarrrow')) {
								selectedIds[currPage] = $("#searchResults").getGridParam('selarrrow');
						}


					},
					onSelectRow: function(rowid) {
							$("#userField").val(rowid);
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

							if(ids.length == $("#searchResults").getGridParam("rowNum")) {
								$("#cb_jqg").attr('checked', true);
							}
						}

					},
					onSortCol: function() {
						selectAll = false;
						selectedIds = [];
					}
				});
			});
			</g:javascript>
    </head>
    <body>
		
		<div id="centerContent">
			<p style="font-size:14pt;padding:10px">GDOC - User Search</p><br />
			<g:if test="${!session.uresults}">
				No results found.
			</g:if>
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<g:else>
				<div style="padding:5px;display:block">
					<span style="vertical-align:5px"> 
						<label for="user">Select a user to view all details.</label>
						<g:form controller="GDOCUser" action="show">
							<g:hiddenField name="id" id="userField" value="" />
							<g:submitButton name="submit" id="selectuserButton" value="View Selected User" />
						</g:form>
						
					</span>
					
					
				</div>
				<table id="searchResults" class="scroll" cellpadding="0" cellspacing="0"></table>
				<div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
			</g:else>
			
			
		</div>
		
	</body>
	
</html>