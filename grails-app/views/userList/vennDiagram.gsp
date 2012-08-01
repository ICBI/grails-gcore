<html>
    <head>
        <meta name="layout" content="report" />
        <title><g:message code="userList.vennTitle"/></title>     
		<g:render template="/common/flex_header" plugin="gcore"/>
		<g:javascript library="jquery" plugin="jquery"/>
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
					$("#toolSpinner").css("visibility","visible");
					cleanup();
				}else{
					$("#toolSpinner").css("visibility","hidden");
					$("#message").css("display","block");
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
		//console.log('${vennJSON}');
		return '${vennJSON}';
	}
	
	</g:javascript>
	<br/>
	<p style="font-size:14pt"><g:message code="userList.results"/></p>
	
	</body>
	
</hmtl>