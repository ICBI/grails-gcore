<%@ page import="Operation" %>
<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<g:javascript>
			<g:set var="operations" value="${session.supportedOperations}" />
			function confirmContinue(element) {			
				var choice = confirm("This operation is not supported by the study you have selected. If you continue, you will be forced to select another study. Continue?");
				return choice;				
			}
		
			$(document).ready(function() {

				<g:if test="${operations}">
					jQuery("a[supported='false']").css("color", "gray");
					jQuery("a[supported='false']").css("cursor", "not-allowed");
					jQuery("a[supported='false']").attr("onclick", "return confirmContinue(this)");
					jQuery("a[supported='false']").each(function(){
						$(this).attr("href", this.href+"?chooseStudy=true")
						$(this).append("&nbsp;<i class=\"icon-ban-circle\"></i>");
					});
				</g:if>
				
				$("#personalized").attr("data-content", $("#personalized_text").html());
				$("#translational").attr("data-content", $("#translational_text").html());
				$("#population").attr("data-content", $("#population_text").html());
			
				$("#personalized").popover({
				html: true, placement:'top', trigger: 'click', 
				title:  '<span>Personalized Medicine&nbsp;&nbsp;</span><button type="button" class="close" onclick="$(&quot;#personalized&quot;).popover(&quot;hide&quot;);">&times;</button>'});
				
				$("#translational").popover({html: true, placement:'top', trigger: 'click', 
				title:  '<span>Translational Medicine&nbsp;&nbsp;</span><button type="button" class="close" onclick="$(&quot;#translational&quot;).popover(&quot;hide&quot;);">&times;</button>'});				
				
				$("#population").popover({html: true, placement:'top', trigger: 'click', 
				title:  '<span>Population Genetics&nbsp;&nbsp;</span><button type="button" class="close" onclick="$(&quot;#population&quot;).popover(&quot;hide&quot;);">&times;</button>'});
				
				//$('.workflowBox').on("mouseenter", function () {$(this).popover("show");});
				
			
			});
		</g:javascript>

		<STYLE type="text/css">
		A:link {color:#336699}
		A:visited {color:#336699}
		A:hover {color:#334477}
		   #tooltip {
		text-align:left;
		font-size: 100%;
		min-width: 90px;
		max-width: 180px;
		.workflowBox {
			
		}
		 </STYLE>
    </head>
    <body>

    <div style="display: none">
    	<div id="personalized_text">
    		<ul>
    			<li><g:link controller="variantSearch" action="index" data-toggle="tooltip" title="not supproted" supported="${operations?.contains(Operation.VARIANT_SEARCH)}">${Operation.VARIANT_SEARCH.name}</g:link></li>
    			<li><g:link controller="dicom" action="index" supported="${operations?.contains(Operation.DICOM)}">${Operation.DICOM.name}</g:link></li>
    		</ul>
    	</div>
    	<div id="translational_text">
    		<p><strong>Search</strong></p>
    		<ul>
    			<li><g:link controller="clinical" action="index" supported="${operations && operations.contains(Operation.CLINICAL)}">${Operation.CLINICAL.name}</g:link></li>
    			<li><g:link controller="moleculeTarget" action="index" supported="${operations && operations.contains(Operation.TARGET)}">${Operation.TARGET.name}</g:link></li>
    			<li><g:link controller="geneExpression" action="index" supported="${operations && operations.contains(Operation.GENE_EXPRESSION)}">${Operation.GENE_EXPRESSION.name}</g:link></li>   			
    		</ul>
    		<p><strong>Analyze</strong>
    		<ul>
    			<li><g:link controller="cin" action="index" supported="${operations && operations.contains(Operation.CIN)}">${Operation.CIN.name}</g:link></li>
    			<li><g:link controller="pca" action="index" supported="${operations && operations.contains(Operation.PCA)}">${Operation.PCA.name}</g:link></li>
    			<li><g:link controller="groupComparison" action="index" supported="${operations && operations.contains(Operation.GROUP_COMPARISON)}">${Operation.GROUP_COMPARISON.name}</g:link></li>
    			<li><g:link controller="heatMap" action="index" supported="${operations && operations.contains(Operation.HEAT_MAP)}">${Operation.HEAT_MAP.name}</g:link></li>
    			<li><g:link controller="km" action="index" supported="${operations && operations.contains(Operation.KM)}">${Operation.KM.name}</g:link></li>
    			<li><g:link controller="kmGeneExp" action="index" supported="${operations && operations.contains(Operation.KM_GENE_EXP)}">${Operation.KM_GENE_EXP.name}</g:link></li>
    		</ul>
    	</div>
    	<div id="population_text">
    		<ul>
    			<li><g:link controller="phenotypeSearch" action="index" supported="${operations && operations.contains(Operation.PHENOTYPE_SEARCH)}">${Operation.PHENOTYPE_SEARCH.name}</g:link></li>
    		</ul>
    	</div>
    
    </div>			

	<br><br>
	<div class="hero-unit" >
		<p style="padding-left: 0px" class="lead">${flash.choosePath}</p>
		<br>
		<p style="padding-left: 0px">
		<g:if test="${session.study}">
			<small>* Your study may not support all the tools</small><br>
			<small>&dagger; Tools which are not supported are grayed out</small><br>
			<small>&Dagger; If you click on a tool which is not supported (grayed out), you will be forced to select another study which supports the tools</small>
		</g:if>
		<g:else>
			<small>* Each of the following three paths will lead you to a different set of tools</small><br>
			<small>&dagger; Click on each of the three icons to see what you can do within each of those portals</small>		
		</g:else>
		</p>
	</div>
	
	<br>
	<div>
		<div id="personalized" class="gradButton gray workflowBox" href="#" rel="popover" data-content="" >
			<img src="${createLinkTo(dir: 'images',  file: 'pm.png')}" />
			<h4>Personalized Medicine</h4>
			<p style="font-size:.8em;padding:0px">Patients' molecular diagnostics and clinical data.</p>
		</div>

		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<div id="translational" class="gradButton gray workflowBox" rel="popover" data-content="">
			<img src="${createLinkTo(dir: 'images',  file: 'tr.png')}" />
			<h4>Translational Research</h4>
			<p style="font-size:.8em;padding:0px">Analytic tools and workflows to enable discovery.</p>
		</div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<g:if test="${session.nextGenPlugin}">
			<div id="population" class="gradButton gray workflowBox" rel="popover" data-content="">
				<img src="${createLinkTo(dir: 'images',  file: 'pop.png')}" />
				<h4>Population Genetics</h4>
				<p style="font-size:.8em;padding:0px">Race-based, genomic reporting and comparison.</p>
			</div>
		</g:if>
		<g:else>
			<g:link action="popgen" style="text-decoration:none" class="wf_button" onclick="alert('This functionality requires the Next-Gen Plugin');return false;">
			<div class="gradButton gray workflowBox">
				<img src="${createLinkTo(dir: 'images',  file: 'pop.png')}" />
				<h4>Population Genetics</h4>
				<p style="font-size:.8em;padding:0px">Race-based, genomic reporting and comparison.</p>
			</div>
			</g:link>
		</g:else>
	</div>


    </body>
</html>