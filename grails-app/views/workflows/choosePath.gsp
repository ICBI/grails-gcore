<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<g:javascript>
			$(document).ready(function() {
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
    			<li><g:link controller="variantSearch" action="index" params="[chooseStudy: 'yes']">Variant Search</g:link></li>
    			<li><g:link controller="dicom" action="index" params="[chooseStudy: 'yes']">DICOM Viewer</g:link></li>
    		</ul>
    	</div>
    	<div id="translational_text">
    		<p><strong>Search</strong></p>
    		<ul>
    			<li><g:link controller="clinical" action="index" params="[chooseStudy: 'yes']">Clinical/Subject search</g:link></li>
    			<li><g:link controller="moleculeTarget" action="index" params="[chooseStudy: 'yes']">Compounds/Drug target search</g:link></li>
    			<li><g:link controller="geneExpression" action="index" params="[chooseStudy: 'yes']">Gene Expression search</g:link></li>   			
    		</ul>
    		<p><strong>Analyze</strong>
    		<ul>
    			<li><g:link controller="cin" action="index" params="[chooseStudy: 'yes']">Chromosomal Instability Index</g:link></li>
    			<li><g:link controller="pca" action="index" params="[chooseStudy: 'yes']">Classification</g:link></li>
    			<li><g:link controller="groupComparison" action="index" params="[chooseStudy: 'yes']">Group Comparison</g:link></li>
    			<li><g:link controller="heatMap" action="index" params="[chooseStudy: 'yes']">HeatMap Viewer</g:link></li>
    			<li><g:link controller="km" action="index" params="[chooseStudy: 'yes']">KM Clinical Plot</g:link></li>
    			<li><g:link controller="kmGeneExp" action="index" params="[chooseStudy: 'yes']">KM Gene Expression Plots</g:link></li>
    		</ul>
    	</div>
    	<div id="population_text">
    		<ul>
    			<li><g:link controller="phenotypeSearch" action="index" params="[chooseStudy: 'yes']">Phenotype Search</g:link></li>
    		</ul>
    	</div>
    
    </div>			

	<br><br>
	<div class="hero-unit" >
		<p style="padding-left: 0px" class="lead">No problem, tell us what you are interested in...</p>
		<br>
		<p style="padding-left: 0px">
			<small>* Each of the following three paths will lead you to a different set of tools</small><br>
			<small>* Click on each of the three icons to see what you can do within each of those portals</small>
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