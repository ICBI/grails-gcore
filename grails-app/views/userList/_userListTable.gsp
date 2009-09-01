<g:javascript library="jquery"/>
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
	function showPageSpinner(show) {
		if(show == true){
			$("#pageSpinner").css("display","inline");
		}else{
			$("#pageSpinner").css("display","none");
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

	<g:if test="${flash.message}">
	<div class="message">${flash.message}</div>
	</g:if>
	<span id="pageSpinner" style="display:none"><img src='/gdoc/images/spinner.gif' alt='Wait'/></span>
	<g:if test="${userListInstanceList.size()>0}">
 	<g:panel title="My Lists" styleClass="welcome" >
	<table class="listTable" width="100%" cellpadding="5">
		<tr>
			<td style="background-color:white;">
				<g:each in="${userListInstanceList}" status="i" var="userListInstance">
				<div id="${userListInstance.name}_div" style="collapse:true;border:0px solid red;margin-bottom:5px;padding:3px 3px 3px 3px">
				
					<div id="${userListInstance.name}_title" style="border:0px solid black;height: 20px; cursor: pointer;"
					onclick="toggle('${userListInstance.name}');">
					<div style="border:0px solid black;width:30%;float:left">	
						<b>${fieldValue(bean:userListInstance, field:'name')} </b>
						<span id="1spinner" style="display:none"><img src="${createLinkTo(dir: 'images', file: 'spinner.gif')}"/></span>
							
					</div>
					<div style="border:0px solid black;float:left; vertical-align: top">
						
						<img class="${userListInstance.name}_toggle"src="${createLinkTo(dir: 'images', file: 'expand.gif')}"
						width="13"
						height="14" border="0" alt="Show/Hide" title="Show/Hide" />
						<img class="${userListInstance.name}_toggle" src="${createLinkTo(dir: 'images', file: 'collapse.gif')}" 
						width="13"
						height="14" border="0" alt="Show/Hide" title="Show/Hide" style="display:none"/>
					</div>
					<span style="float:right"><g:formatDate date="${userListInstance.dateCreated}" format="h:mm M/dd/yyyy"/></span>
					</div>
					<g:if test="${session.userId.equals(userListInstance.author.loginName)}">
					<div style="border:0px solid black;width:20%;float:right">	
						<a href="javascript:void(0)" style="padding-right:5px">
						<img alt="edit list" title="Edit list" src="${createLinkTo(dir: 'images', file: 'pencil.png')}" /></a>
						
						
						<g:link class="thickbox" name="Share &nbsp; ${userListInstance.name} &nbsp; with collaboration groups?" action="share" controller="share" 
params="[id:userListInstance.id,name:userListInstance.name,type:'USER_LIST',keepThis:'true',TB_iframe:'true',height:'250',width:'400',title:'someTitle']"><img alt="share list" title="Share list" style="height: 18px;padding-right:5px" src="${createLinkTo(dir: 'images', file: 'share.png')}"/></a></g:link>
						<g:link action="export" style="padding-right:5px;" id="${userListInstance.id}">
							<img alt="export list" title="Export list" src="${createLinkTo(dir: 'images', file: 'export.png')}" />
						</g:link>
						<a href="javascript:void(0)" onclick="if(confirm('Are you sure?')){${remoteFunction(action:'deleteList',onLoading:'showPageSpinner(true)',onComplete:'showPageSpinner(false)', id:userListInstance.id,update:'allLists',onSuccess:'finishDelete(\''+userListInstance.id+'\')')}return false;}">
						<img alt="delete list" title="Delete list" src="${createLinkTo(dir: 'images', file: 'cross.png')}"/></a>
					</div>
					</g:if>
					<g:else>
					<div style="border:0px solid black;width:50%;float:right">	
						Shared by: ${userListInstance.author.firstName}&nbsp;${userListInstance.author.lastName}&nbsp;(author)
						<g:link action="export" style="padding-right:5px;" id="${userListInstance.id}">
							<img alt="export list" title="Export list" src="${createLinkTo(dir: 'images', file: 'export.png')}" />
						</g:link>
					</div>
					</g:else>

				
				<div id="${userListInstance.name}_content" style="border:0px solid black;display:none;padding-bottom:5px">
					<g:render template="/userList/userListDiv" model="${['userListInstance':userListInstance,'listItems':userListInstance.listItems]}"/>
				</div>
				<div style="border-bottom:1px solid grey;background-color:#f3f3f3;padding-bottom:5px">Tags:
					<g:if test="${userListInstance.tags.size()>0}">
					${userListInstance.tags}
					</g:if>
					<g:else>
					</g:else>
				</div>
		</div>
	</g:each>
</td>
</tr>
</table>
</g:panel>
</g:if>
<g:else>
<p>Currently, you have no saved lists.</p>
</g:else>
