<g:javascript library="jquery" plugin="jquery"/>
<jq:plugin name="DOMWindow"/>
	<g:javascript>
	function showToolsSpinner(show) {
		if(show == true){
			$("#toolSpinner").css("visibility","visible");
			cleanup();
		}else{
			$("#toolSpinner").css("visibility","hidden");
			cleanup(); 
		}
	}
	function showPageSpinner(show,className) {
		var pageSpinner = className+"_pageSpinner";
		if(show == true){
			$("#"+pageSpinner).css("visibility","visible");
		}else{
			$("#"+pageSpinner).css("visibility","hidden");
			$('.geneLink').geneLink({'advancedMenu': false, 'multiple': true});
			$('.micrornaLink').geneLink({'menuType': 'microrna', 'advancedMenu': false, 'multiple': true});
			$('.copynumberLink').geneLink({'menuType': 'copynumber', 'advancedMenu': false, 'multiple': true});
		}
	}
	
	function cleanup() {
				window.setTimeout(function() {
				  $('#listName').val("");
				  $("#userListIds").val(null);
				  $('.message').remove();
				}, 1500);
			}	
	function finishDelete(value){
		$("#userListIds option[value='"+ value +  "']").remove();
		cleanup();
	}
	
	</g:javascript>
	<g:javascript>
	$(document).ready( function () {
			$('.editWindow').openDOMWindow({ 
				    height:350, 
					width:400, 
					eventType:'click', 
					windowSource:'iframe', 
					windowPadding:0, 
					loader:1, 
					loaderImagePath:'animationProcessing.gif', 
					loaderHeight:16, 
					loaderWidth:17
			    });
			$('.closeEditWindow').closeDOMWindow({eventType:'click'});

	} );
	$(document).ready( function () {
			$('.checkall').click(function () {
					$(this).parents('fieldset:eq(0)').find(':checkbox').attr('checked', this.checked);
				});


	} );
	
	</g:javascript>
	
	<g:if test="${flash.message}">
	<div class="message">${flash.message.encodeAsHTML()}</div>
	</g:if>
	<g:if test="${flash.error}">
	<div class="errorDetail">${flash.error.encodeAsHTML()}</div>
	</g:if>
	
	<g:if test="${userListInstanceList.size()>0}">
	
	<fieldset style="border:0px solid black">
	
	<div style="padding-bottom: 10px;"><input type="checkbox" class="checkall"> <g:message code="userList.checkAll"/></div>

	
	<table class="listTable" width="100%" cellpadding="5">
		<tr>
			<td style="background-color:white;">
				<g:each in="${userListInstanceList}" status="i" var="userListInstance">
				
				
				<div id="${userListInstance.id}_div" style="collapse:true;border:0px solid red;margin-bottom:5px;padding:3px 3px 3px 3px">
					
					<g:if test="${session.userId.equals(userListInstance.author.username)}">
					<div style="border:0px solid black;width:2%;float:left;padding-right:10px"><g:checkBox class="the_checkbox" name="deleteList"
						 value="${userListInstance.id}" checked="false"/></div>
					</g:if>
					
					<div id="${userListInstance.id}_title" style="border:0px solid black;height: 30px;">
					<div style="border:0px solid black;float:left;">	
	<span class="${userListInstance.id}_name" id="${userListInstance.id}_name" style="font-weight:bold;padding-left:5px;padding-right:5px">${fieldValue(bean:userListInstance, field:'name').encodeAsHTML()} </span>
	
						
							
					</div>
					<g:if test="${userListInstance.listItems.size() <= 100}">
					<div id="${userListInstance.id}_toggleContainer" style="border:0px solid black;vertical-align: top">
						<span>(${userListInstance.listItems.size()} items)</span>
						<div id="${userListInstance.id}_tog" style="float:right;border:0px solid black;height:20px; cursor: pointer;"
						onclick="toggle('${userListInstance.id}');">
						<img class="${userListInstance.id}_toggle"src="${createLinkTo(dir: 'images', file: 'expand.gif')}"
						width="13"
						height="14" border="0" alt="Show/Hide" title="Show/Hide" 
		onclick="if($('#${userListInstance.id}_listItems').length == 0){var classn = this.className;
{${remoteFunction(action:'getListItems',id:userListInstance.id,onLoading:'showPageSpinner(true,classn)',onComplete:'showPageSpinner(false,classn)',update:userListInstance.id+'_content')}return false;}}"/>
						
						<img class="${userListInstance.id}_toggle" src="${createLinkTo(dir: 'images', file: 'collapse.gif')}"
						width="13"
						height="14" border="0" alt="Show/Hide" title="Show/Hide" style="display:none" />
						<span id="${userListInstance.id}_toggle_pageSpinner" style="visibility:hidden;display:inline"><img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Wait'/></span>
						<span style="border:0px solid black;">

							<g:formatDate date="${userListInstance.dateCreated}" format="h:mm M/dd/yyyy"/>
						</span>
						</div>
					</div>
					</g:if>
					<g:else>
						* <g:message code="userList.exceeds"/> *
						<span style="float:right;border:0px solid black;">

							<g:formatDate date="${userListInstance.dateCreated}" format="h:mm M/dd/yyyy"/>
						</span>
					</g:else>
					
					</div>
					<g:if test="${session.userId.equals(userListInstance.author.username)}">
					<div style="border:0px solid black;width:25%;float:right">
						<g:link action="listModify" params="[id:userListInstance.id,name:userListInstance.name,mode:'View']" style="padding-right:5px" class="editWindow">	
							<img alt="edit analysis" title="View/Modify List" src="${createLinkTo(dir: 'images', file: 'zoom_in.png')}"  border="0" /></g:link>
						
						<g:if test="${!userListInstance.tags.contains('_temporary')}">
						<g:link class="thickbox" name="Share &nbsp; ${userListInstance.name}" action="share" controller="share" 
params="[id:userListInstance.id,name:userListInstance.name,type:'USER_LIST',keepThis:'true',TB_iframe:'true',height:'375',width:'450',title:'someTitle']"><img alt="share list or view groups previously shared to" title="Share list" style="height: 18px;padding-right:5px" src="${createLinkTo(dir: 'images', file: 'share.png')}" border="0"/></a></g:link>
						</g:if>
						<g:link action="export" style="padding-right:5px;text-decoration:none" id="${userListInstance.id}">
							<img alt="export list" border="0" title="Export list" src="${createLinkTo(dir: 'images', file: 'export.png')}" />
						</g:link>		
						<g:if test="${userListInstance.tags.contains('gene')}">
							<g:cytoscapeLink style="padding-right:5px;text-decoration:none" id="${userListInstance.id}" src="${createLinkTo(dir: 'images', file: 'chart_line.png')}" title="View Cancer-Gene Index network"/>&nbsp;
							<g:link class="enrich" action="enrichGeneList" controller="geneEnrichment" style="padding-right:5px;" id="${userListInstance.id}" >
								<img alt="enrich gene list" border="0" title="Enrich Gene List" src="${createLinkTo(dir: 'images', file: 'enrich.png')}" />
							</g:link>
						</g:if>
		<%--a href="javascript:void(0)" onclick="if(confirm('Are you sure?')){var classn ='${userListInstance.id}_toggle';${remoteFunction(action:'deleteList',onLoading:'showPageSpinner(true,classn)',onComplete:'showPageSpinner(false,classn)', id:userListInstance.id,update:'allLists',onSuccess:'finishDelete(\''+userListInstance.id+'\')')}return false;}">
						<img alt="delete list" title="Delete list" src="${createLinkTo(dir: 'images', file: 'cross.png')}"/></a--%>
					</div>
					</g:if>
					<g:else>
					<div style="border:0px solid black;width:60%;float:right">	
						<g:message code="userList.sharedBy"/>: ${userListInstance.author.firstName}&nbsp;${userListInstance.author.lastName}&nbsp;(author)
						<g:link action="export" style="padding-right:5px;text-decoration:none" id="${userListInstance.id}">
						<img alt="export list" border="0" title="Export list" src="${createLinkTo(dir: 'images', file: 'export.png')}" />
						</g:link>
						<g:if test="${userListInstance.tags.contains('gene')}">
						<g:cytoscapeLink style="padding-right:5px;text-decoration:none" id="${userListInstance.id}" src="${createLinkTo(dir: 'images', file: 'chart_line.png')}" title="View Cancer-Gene Index network"/>&nbsp;&nbsp;
						<g:link class="enrich" action="enrichGeneList" controller="geneEnrichment" style="padding-right:5px;" id="${userListInstance.id}" >
							<img alt="enrich gene list" border="0" title="Enrich Gene List" src="${createLinkTo(dir: 'images', file: 'enrich.png')}" />
						</g:link>
						</g:if>
					</div>
					</g:else>

				
				<div id="${userListInstance.id}_content" style="border:0px solid black;display:none;padding-bottom:5px">
				</div>
				<div style="border-bottom:0px solid grey;background-color:#f3f3f3;padding-bottom:5px;">
					<g:if test="${userListInstance.studies.size()>0}">
					<g:message code="userList.studies"/>: 
						${userListInstance.studyNames().join(", ")}<br/>
					</g:if>
					<g:if test="${userListInstance.groups}">
					<g:message code="userList.groups"/>: 
						${userListInstance.groups.join(", ")}<br/>
					</g:if>
					<g:if test="${userListInstance.tags.size()>0}">
					<g:if test="${userListInstance.tags.contains('_temporary')}">
					<span style="color:red;padding:3px"><g:message code="userList.note" args="${[appTitle()]}"/></span>
					</g:if>
					<g:else>
					<g:message code="userList.tags"/>: ${userListInstance.tags.join(", ")}
					
					</g:else>
					</g:if>
					
					
				</div>
		</div>
	</g:each>
</td>
</tr>
</table>



<div id="enrichmentResults" style="display:none"> 
	<div style="color:#000"> 
	<p style="text-align:center; line-height:80px">Drag Me! Click html page behind me to close me.</p> 
	</div>
</div>

<g:javascript library="jquery" plugin="jquery"/>
</fieldset>
</g:if>
<g:else>
<p><g:message code="userList.noList"/>
	<g:if test="${session.listFilter}">
		<span>${session.listFilter} <g:message code="userList.days"/></span><br />
		<g:message code="userList.expand"/>
	</g:if>
	
	</p>
</g:else>
