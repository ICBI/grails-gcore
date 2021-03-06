<html>
<head>
	<title>Modify List</title>
	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="DOMWindow"/>
	
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
	<g:javascript>
		function refreshListPage(){
			window.parent.location.replace(window.parent.location.pathname);
		}
	</g:javascript>
	<body>
	<div style="background-color:#f2f2f2;width:100%">
		<p style="font-size:1em;display:inline-table">
				<g:message code="userList.modifyList" args="${ [params.mode] }" />
				<g:if test="${params?.mode=='View'}">
					<span>
					<g:link action="listModify" params="[id:params.id,name:params.name,mode:'Modify']" style="padding-right:5px">
					<g:message code="gcore.edit" />
					</g:link>
					</span>	
				</g:if>
		</p>
	</div><br />
<div id="editNameContent" align="left" class="clinicalSearch"> 
	<div id="saveForm">
		<g:if test="${flash.message}">
		<g:javascript>$("#toolSpinner").css("visibility","visible");</g:javascript>
		<div class="message">${flash.message.encodeAsHTML()}</div>
		<g:javascript>refreshListPage();</g:javascript>
		</g:if>
		<g:if test="${flash.error}">
		<div class="errorDetail">${flash.error.encodeAsHTML()}</div>
		</g:if>
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}" />

		</div>
		<g:form action="modifyListAttributes" >
		
		<table class="listTable" style="width:95%;background-color:#f2f2f2;border:0px">
			
		<tr>
			<td><g:message code="userList.listName"/>:
			</td>
			<td colspan="2" style="width:25%">
				
					<g:hiddenField name="id" value="${id}" />
					<g:if test="${params?.mode=='View'}">
						<g:if test="${name}">
							<div style="width:200px;white-space: wrap;overflow:auto">${name}</div>
						</g:if>
						<g:else>
							<g:message code="userList.noName"/>
						</g:else>
					</g:if>
					<g:else>
						<g:textField name="newName" size="15" maxlength="15" value="${name}"/>
					</g:else>
					<g:hiddenField name="userId" value="${session.userId}" />
				
			</td>
		</tr>
		<tr>
			<td valign="top"><g:message code="userList.description"/>:
			</td>
			<td colspan="2" style="width:25%">

				<g:if test="${params?.mode=='View'}">
						<g:if test="${description}">
							<div style="width:200px;white-space: wrap;overflow:auto">${description}</div>
						</g:if>
						<g:else>
							<g:message code="userList.noDescription"/>
						</g:else>
				</g:if>
				<g:else>
					<g:textArea name="description" rows="8" columns="40" value="${description}" />
				</g:else>
			</td>
		</tr>
		<g:if test="${params?.mode=='Modify'}">
		<tr>
			<td style="width:25%">
					<span id="toolSpinner" style="visibility:hidden"><img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Wait'/></span>
			</td>
			<td style="text-align:right">
				<input type="button" class="closeEditWindow" onclick="javascript:parent.$('#DOMWindowID').closeDOMWindow();" value="${message(code:'userList.cancel')}" style="padding-right:5px"/>
				<g:submitButton name="submit" id="submitButton" value="${message(code: 'userList.save')}"/>
			</td>
			
		</tr>
		</g:if>
	</table>
		
		</g:form><br />
		
		<span class="closeEditWindow" style="float:right;padding-top:5px">
			<a href="javascript:parent.$('#DOMWindowID').closeDOMWindow();"><g:message code="userList.close"/></a></span>
	</div>
	
	
</div>
</body>
</html>