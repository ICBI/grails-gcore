<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		
		<g:javascript>
			$(document).ready(function() {
				if($("#view").find('li').size() == 0) $("#view").hide();
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
				<br><br>
				<div class="hero-unit" style="float: inline-block;">
				  <g:if test="${session.study}">
				  	<div style="padding-left: 0px;" class="lead">You have picked the study: ${session.study.shortName}*
				  		<p style="font-size: 14px"></p>
					  	<a class="btn" href="<g:createLink action="chooseStudy" params="[showAll:'yes']" />">Change my study</a>
					  	<a class="btn" href="<g:createLink action="choosePath" />">Help me pick another study</a>
				  	</div>
				  	<p style="font-size: 11px"> * ${session.study.longName}</p>
				  </g:if>
				  <p style="padding-left: 0px;" class="lead">
				  ${flash.operationNotSupported}<br><br>
				  Based upon the study you picked, here is a list of
				  tools you can use:</p>
				  
				  <% def operations = session.supportedOperations.groupBy {it.type} %>
              		<g:each in="${operations.keySet()}" var="type">
	              		<div id="${type.toLowerCase()}">${type}
		              		<ul>
		             		<g:each in="${operations[type]}" var="operation">
		             			<li><a href="${createLink(controller: operation.controller, action: operation.action)}"><small>${operation.name}</small></a>
		             		</g:each>
	             		</ul>
	             		</div>         		
             		</g:each>				  

				  <%--<div id="search">Search
					  <ul>
					  	<li><g:link controller="genomeBrowser" action="index"><small>Browse Genome</small></g:link></li>
					  	<g:if test="${session.study.hasClinicalData()}"><li><g:link controller="clinical" action="index"><small>Clinical/Subject</small></g:link></li></g:if>
					  	<li><g:link controller="moleculeTarget" action="index"><small>Compound/Drug Targets</small></g:link></li>
					  	<g:if test="${session.study.hasGenomicData() && session.dataSetType.contains('GENE EXPRESSION')}"><li><g:link controller="geneExpression" action="index"><small>Gene Expression</small></g:link></li></g:if>
					  	<g:if test="${session.study.hasImagingData()}"><li><g:link controller="dicom" action="index"><small>DICOM Viewer</small></g:link></li></g:if>
					  	<g:if test="${session.study.hasWgsData()}"><li><g:link controller="phenotypeSearch" action="index"><small>Phenotype Search</small></g:link></li></g:if>
					  	<g:if test="${session.study.hasWgsData()}"><li><g:link controller="variantSearch" action="index"><small>Variant Search</small></g:link></li></g:if>
					  </ul>
				  </div>
				  
				  <div id="analyze">Analyze
					  <ul>
					  	<g:if test="${session.study.hasCopyNumberData()}"><li><g:link controller="cin" action="index"><small>Chromosomal Instability Index</small></g:link></li></g:if>
					  	<li><g:link controller="pca" action="index"><small>Classification</small></g:link></li>
					  	<g:if test="${session.files && session.study.hasDynamicData()}"><li><g:link controller="groupComparison" action="index"><small>Group Comparison</small></g:link></li></g:if>
					  	<li><g:link controller="heatMap" action="index"><small>HeatMap Viewer</small></g:link></li>
					  	<g:if test="${session.endpoints}"><li><g:link controller="km" action="index"><small>KM Clinical Plot</small></g:link></li></g:if>
					  	<g:if test="${session.endpoints && session.study.hasGenomicData() && session.dataSetType.contains('GENE EXPRESSION')}"><li><g:link controller="kmGeneExp" action="index"><small>KM Gene Expression Plots</small></g:link></li></g:if>
					  </ul>
				  </div>--%>
				</div>			
				 
    </body>
</html>