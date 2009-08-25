<html>
    <head>
        <meta name="layout" content="report" />
        <title>Venn Diagram</title>     
		<g:render template="/common/flex_header"/>
		<g:javascript library="jquery"/>
		<jq:plugin name="tooltip"/>
		<jq:plugin name="ui"/>
    </head>
    <body>
			<g:javascript>
				$(document).ready(function (){
					$('.info').tooltip({showURL: false});
				});
			</g:javascript>
			
			<g:javascript>
			function showToolsSpinner(show) {
				if(show == true){
					$("#message").css("display","block");
					$("#toolSpinner").css("visibility","visible");
					cleanup();
				}else{
					$("#toolSpinner").css("visibility","hidden");
					cleanup(); 
				}
			}
			function cleanup() {
						window.setTimeout(function() {
						  $('#name').val("");
						  $('.message').remove();
						}, 1500);
					}	
			</g:javascript>
	
	<g:javascript>
	
	function getVenn(){
		return '${vennJSON}';
	}
	
	</g:javascript>
	<br/>
	<p style="font-size:14pt">Venn Diagram Results</p>
	
		<br/>	
				<g:flex component="VennDiagram" width="500px" height="300px" />
		<br /><br />
		<g:if test="${intersectedIds.allCircles.circleInt.get(0).intValue()>0}">
		
		<div id="message" class="message" style="display:none"></div>
	<table style="padding:10px">
	<tr><td valign="top">
		<g:panel id="myVennDataPanel" title="Venn Diagram Data" styleClass="prefsData" panelColor="userLogPanelTitle" 				contentClass="myPanelContent">
		<p><span id="intColor" style="margin-right:3px">
			<g:if test="${intersectedIds.size()==3}">
			<img src="${createLinkTo(dir:'images',file:'int2.png')}" />
			</g:if>
			<g:if test="${intersectedIds.size()==4}">
			<img src="${createLinkTo(dir:'images',file:'int3.png')}" />
			</g:if>
			</span>
			intersecting items : ${intersectedIds.allCircles.items.flatten().size()} 
			<span class="info"style="cursor:pointer;text-decoration:underline" title="${intersectedIds.allCircles.items.flatten()}" border="0" />view</span>
			</p>
		<p style="margin-left:20px">intersection: ${intersectedIds.allCircles.circleInt.get(0).intValue()}%</p>
		</g:panel>	
	</td>
	<td valign="top">
	<g:panel id="myVennPanel" title="Save intersection as list?" styleClass="prefs" panelColor="userLogPanelTitle" contentClass="myPanelContent">
	<g:formRemote name="vennIntersectForm" update="message" onLoading="showToolsSpinner(true)"
	    onComplete="showToolsSpinner(false)" action="saveFromQuery" url="${[action:'saveFromQuery']}">
	<span>List Name: <g:textField name="name" /></span><br />
	<g:hiddenField name="author.username" value="${session.userId}" />
	<g:hiddenField name="ids" value="${intersectedIds.allCircles.items.flatten()}" />
	<g:actionSubmit value="create list"  action="saveFromQuery" />
	</g:formRemote>	
	
	<span id="toolSpinner" style="visibility:hidden"><img src='/gdoc/images/spinner.gif' alt='Wait'/></span>
	</g:panel>
	</td>
	
	</tr></table>
	</g:if>		
	</body>
	
</hmtl>