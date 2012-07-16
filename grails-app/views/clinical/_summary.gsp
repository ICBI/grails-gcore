<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
<g:javascript library="jquery"/>
<jq:plugin name="tooltip"/>
<jq:plugin name="ui"/>
<g:javascript>
	$(document).ready(function (){
		displayFilterTable();
	});
	
	function displayFilterTable(){
		//console.log("display/configure table");
		//find all unique classes
		var uniqueClasses = [];
		$('[class*="rowspan_"]').each(function() {
			var myClass = $(this).attr("class");
			var myClassArray = myClass.split("_");
			var classRootName = ""
			for(var j=0;j<myClassArray.length-1;j++){
				if(myClassArray[j]!="rowspan"){
					if (j==1){
						classRootName = classRootName+myClassArray[j];
					}else{
						classRootName = classRootName+"_"+myClassArray[j];
					}
					
				}
			}
			var alreadyPresent = false;
			for(var i=0;i<uniqueClasses.length;i++){
				if(classRootName == uniqueClasses[i]){
					alreadyPresent = true;
					break;
				}
			}
			if(!(alreadyPresent)){
				uniqueClasses.push(classRootName);
			}
		});
		for(var i=0;i<uniqueClasses.length;i++){
			//console.log(uniqueClasses[i]);
		}
		var attrArray = [];
		for(var j=0;j<uniqueClasses.length;j++) {
		   var classRoot = uniqueClasses[j];
		   var find = "rowspan_"+classRoot;
			//console.log("find "+find);
			
			var rowspan = 1;
			$("[class*='"+find+"']").each(function() {
				//split and find rowspan
				var thisClass = $(this).attr("class");
				//put elements in array
				attrArray.push(thisClass);
				var thisArray = thisClass.split("_");
				var this_rowspan = thisArray[thisArray.length-1];
				var rs = parseInt(this_rowspan);
				//console.log(thisArray);
				if(rs > rowspan){
					rowspan = rs;
				}	
			});
			console.log("final rowspan of "+classRoot + "="+rowspan);
			//set parent rowspan
			$("[class*="+classRoot+"_parent]").each(function() {
				$(this).css("border-bottom","0px solid black");
				//$(this).attr("rowspan",rowspan);
			});
			//remove spanned elements
			console.log("to remove="+attrArray);
			if(attrArray.length > 0){
				//console.log("remove spanned elements");
				for(var i=0;i<attrArray.length;i++){
					$("."+attrArray[i]).css("border-top","0px solid blue");
					$("."+attrArray[i]).css("border-bottom","0px solid blue");
					$("."+attrArray[i]).html("");
				}
			}
			
		}
	}
</g:javascript>

<g:if test="${countMap}">

<g:set var="criteriaSize" value="${comboCounts.keySet().size()}" />
<% Map valuesMap = new HashMap(); %>
<table border="0" class="filterTable">
<tr>
<g:each in="${columns}" var="${name}">
	<g:if test="${comboCounts.keySet().contains(name)}">
		<th>${session.attNamesMap[name]}</th>
	</g:if>
	<g:else>
		<th>${name}</th>
	</g:else>
</g:each>
</tr>
<g:each in="${columnResults}" var="${resultMap}">
<g:set var="idArray" value="${resultMap['resultId'].split('--')}" />
<tr>
	<g:each in="${columns}" var="${name}" status="i">
	
	<g:set var="finalId" value="${''}" />
		<g:if test="${!valuesMap}">
			<g:if test="${comboCounts.keySet().contains(name)}">
				<% 
					for(int j=0;j<=i;j++){
						if(j!=i){
							finalId += idArray[j]+"_";
						}else{
							finalId += idArray[j];
						}
					}
					valuesMap.put(finalId,1); 
					
				%>
			</g:if>
			<td rowspan="1" class="${(finalId+'_parent').replace('(','').replace(')','').replace('/','')}">${resultMap[name]}</td>
		</g:if>
		<g:else>
			<%
				if(i < criteriaSize-1){
					for(int j=0;j<=i;j++){
						if(j!=i){
							finalId += idArray[j]+"_";
						}else{
							finalId += idArray[j];
						}
							
					}
					
				}
			%>
			<g:if test="${(valuesMap[finalId]) && (valuesMap[finalId])>0}">
				<g:if test="${comboCounts.keySet().contains(name)}">
					<% 
					
					valuesMap.put(finalId,(valuesMap.get(finalId)+1)); 
					
					
					%>
					<g:if test="${(i+1 == criteriaSize)}">
						<td>${resultMap[name]} </td>
					</g:if>
					<g:else>
						<td rowspan="1" class="${('rowspan_'+finalId+'_'+valuesMap[finalId]).replace('(','').replace(')','').replace('/','')}">${resultMap[name]}</td>
					</g:else>
				</g:if>
				
			</g:if>	
			<g:else>
				<g:if test="${comboCounts.keySet().contains(name)}">
					<g:if test="${(i+1 == criteriaSize)}">
						<td>${resultMap[name]}</td>
					</g:if>
					<g:else>
					<% 
						valuesMap.put(finalId,1);
					%>
					<td rowspan="1" class="${(finalId+'_parent').replace('(','').replace(')','').replace('/','')}">${resultMap[name]}</td>
					</g:else>
				</g:if>
				<g:else>
					<td><a href="#">${resultMap[name]}</a></td>
				</g:else>
			</g:else>	
		</g:else>
		
		
	</g:each>
</tr>
</g:each>
<tr>
	<td colspan="${columns.size()-countMap.size()}">Total</td>
	<g:each in="${columns}" var="${name}">
		<g:if test="${countMap[name]}">
			<td><a href="#">${countMap[name]}<a/></td>
		</g:if>
	</g:each>
</tr>
</table>

	
</g:if>

