<br/>
<g:javascript library="jquery" plugin="jquery"/>
<g:javascript>
	function showOption(){
		if($("#listAction option:selected").val()=='venn'){
			$("#name").css("display","none");
		}
		else{
			$("#name").css("display","inline");
		}
	}
	function validate(){
		if(!($("#userListIds option:selected").size() > 1)){
			alert("Please select at least 2 lists");
			return false;
		}else if($("#listAction option:selected").val()=='diff'){
			if($("#userListIds option:selected").size() != 2){
				alert("Please select 2 lists to view difference");
				return false;
			}
		}else if($("#listAction option:selected").val()=='venn'){
			if($("#userListIds option:selected").size() > 4){
				alert("Please select no more than 4 lists to view Venn diagram");
				return false;
			}else{
				$("#listToolForm").submit();
			}
		}
	}
	
	$(document).ready(function() {
		$(".selectpicker").selectpicker();
		
	});

</g:javascript>

<div class="features">
    <p style="font-size:16px;font-weight:bold;margin-left: -20px;margin-top: -10px;">List Tools</p>
    <br/>
	<g:if test="${toolsLists}">
		<div>
 		<g:form name="listToolForm" update="allLists" onLoading="showToolsSpinner(true)"
		    onComplete="showToolsSpinner(false)" action="tools" url="${[action:'tools']}" method="post">
		<span style="margin-bottom:5px;"><g:message code="userList.listAction"/> <br />
		<g:select name="listAction" class="selectpicker" from="${['Venn Diagram','Intersect Lists','Join Lists', 'Difference']}" 
				keys="${['venn','intersect','join','diff']}" onchange="showOption(this)" /></span><br />
		<span id="name" style="display:none;margin-top:5px;"><g:message code="userList.listName"/>: <br /><g:textField name="listName" size="17" maxlength="15"/></span>
		<g:select style="margin-top:5px;width:180px" name="userListIds"
				  from="${toolsLists}"
		          optionKey="id" 
				  optionValue="name"
				  multiple="true"
				  size="12"
				  />
		<g:actionSubmit class="btn" value="Submit"  action="tools" onclick="return validate()"/>

		</g:form>
		<span id="toolSpinner" style="visibility:hidden"><img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Wait'/></span>
	 </div>
	</g:if>
	<g:else>
	<g:message code="userList.tools"/>
	</g:else>
</div>