<html>
    <head>
        <meta name="layout" content="report" />
        <title><g:message code="clinical.searchResults" /></title>  
    	<style type="text/css">
	  	.aParent div {
		  float: left;
		  clear: none; 
		}
		.bParent div {
		  float: none;
		  clear: none; 
		}
	  </style>
		<g:javascript library="jquery" plugin="jquery"/>   
    </head>
    <body>
		<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.styledButton.js" plugin="gcore"/>
		<g:jqgrid />
	<g:javascript>
	
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
	
	<br/>
	
	<div class="bParent">
	
	<table border="0">
	<tr>
		<td style="width:300px;border:0px solid black">
			<div style="border:0px solid black;" class="bParent">
				<div id="studyPicker">
					<g:render template="/studyDataSource/studyPicker" plugin="gcore"/>
				</div>
				<div>
					<g:render template="/clinical/filter" plugin="gcore"/>
				</div>
			</div>
		</td>
		<td valign="top">
			<div style="border:0px solid black;padding-top:15px;margin-left:10%;width:100%" class="breadcrumbs">
				&nbsp;&nbsp;
			</div>
			<div style="border:0px solid black;padding-top:25px;margin-left:10%;display:inline-table" >
					<span>Current Split Attribute</span><br>
					<g:select class="splitAtt" name="user_switchAttribute" id="user_switchAttribute"
							noSelection="${['NONE':'None...']}" value="${session.splitAttribute}"
							from="${session.vocabList}" optionKey="shortName" optionValue="longName">
							
					</g:select>
			</div>
			<br/>
			<div style="border:0px solid black;width:100%;margin-left:10%;">
				<table border="0">
					
					<tr>
						<td id="filterResults">&nbsp;
							
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	</table>
	</div>

	</body>
	
</html>
