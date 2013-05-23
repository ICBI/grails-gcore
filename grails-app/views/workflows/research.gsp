<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<!-- styling -->
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'scrollable-navig.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'dialog.css')}"/>
		<STYLE type="text/css">
		A:link {color:#336699}
		A:visited {color:#336699}
		A:hover {color:#334477}
		   #tooltip {
		text-align:left;
		font-size: 100%;
		min-width: 90px;
		max-width: 180px;
		}
		 </STYLE>
    </head>
    <body>
				<jq:plugin name="ui"/>
				<jq:plugin name="autocomplete"/>
					<jq:plugin name="tooltip"/>
				<g:javascript>



				  $(document).ready(function(){
					$('.info').tooltip({showURL: false});
				   	$("#q").autocomplete("/${appName()}/search/relevantTerms",{
							max: 130,
							scroll: true,
							multiple:false,
							matchContains: true,
							dataType:'json',
							parse: function(data){
								var array = jQuery.makeArray(data);
								for(var i=0;i<data.length;i++) {
				 					var tempValue = data[i];
									var tempResult = data[i];
									array[i] = { data:data[i], value: tempValue, result: tempResult};
							    }
								return array;
							},
				            formatItem: function(data, i, max) {
										return data;
									},

							formatResult: function(data) {
										return data;
									}
					});


				  });


				</g:javascript>
				<div style="width:85%">
			
				
				
				
				
				
				<div id="centerContent">
					
						
						<!-- root element for scrollable -->
				</div>
				<g:render template="/workflows/content" />
					
					<br/>
				</div>
    </body>
</html>