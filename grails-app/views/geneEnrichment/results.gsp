<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="report" />

        <g:javascript library="jquery"/>
		<g:jqgrid />
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.contextmenu.css', plugin: 'gcore')}"/>
		<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.contextmenu.js" plugin="gcore"/>
		<g:javascript src="geneLink.js" plugin="gcore"/>
		<g:javascript>
		$(document).ready( function () {
			jQuery("#searchResults").jqGrid({ 
				url:'<%= createLink(action:"view",controller:"geneEnrichment", id:"${params.id}") %>', 
				datatype: "json", 
				colNames: ["Pathway", "p-value", "Overlapping Genes"], 
				colModel: [
			   		{name:'pathway',index:'pathwayNames', width: '300'},
			   		{name:'pvalue',index:'pvalues', width: '100'},
					{name: 'overlaps', index: 'overlaps', width: '300', sortable: false }
				], 
				height: 400, 
				rowNum:50, 
				rowList:[25,50], 
				width: 700,
				pager: jQuery('#pager'), 
				sortname: 'pvalues', 
				viewrecords: true, 
				sortorder: "desc", 
				multiselect: false, 
				caption: "Gene Enrichment Results",
				gridComplete: function() {
					$('.geneLink').geneLink({'advancedMenu': false});
				},
				beforeSelectRow: function() {
					return false;
				}

			});
			jQuery("#searchResults").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:false, refresh: false,position:'left'});
			jQuery("#searchResults").jqGrid('navButtonAdd','#pager',{
			       caption:"Export results", 
			       onClickButton : function () { 
				       $('#download').submit();
			       },
				   position:"last"
			});
		});
		
		</g:javascript>
        <title>Gene Enrichment</title>  
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'grids.css')}"/>
       <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/cupertino',  file: 'jquery-ui-1.7.1.custom.css')}" />	
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'ui.jqgrid.css')}" />	

    </head>
    <body>
		
		<br/>
		<br/>
		<div id="centerContent" align="left">
			<table id="searchResults" class="scroll" cellpadding="0" cellspacing="0"></table>
			<div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
		</div>
		<div id="centerContent">
			<br/>
			<table id="searchResults" class="scroll" cellpadding="0" cellspacing="0" style="position:absolute; z-index: 1000;"></table>
			<div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
			<br/>
			<br/>
		</div>
		<g:form name="download" action="download">
		</g:form>
    </body>
</html>
