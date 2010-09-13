<html>
    <head>
        <meta name="layout" content="main" />
		
	<g:javascript library="jquery"/>
	<%--script type="text/javascript" src="/gdoc/applets/marvin/marvin.js"></script--%>
	<jq:plugin name="ui"/>
	<jq:plugin name="autocomplete"/>
	<g:javascript>
	
	function exportMol() {
		alert('uo');
		var ffmt = "smiles:";
		var s = document.Editor.getSmiles();
		alert(s);
		//document.Editor.getMolFile();//document.MSketch.getMol(ffmt);
		//s = unix2local(s);
		if(s != "") {
			document.MolForm.smiles.value = s; 
			document.MolForm.submit();
		} else {
			alert("The drawing pallet is currently empty:\n"+
				"Click on the drawing pallet to add a molecular structure.\n");
			return false;
		}
		
	}
	
		var page = "index"
	  $(document).ready(function(){
			
			$('#centerTabs').tabs({ selected: 0 });
			
			if(page == "sketch") {
				$('#centerTabs').tabs('select', 1);
			}
		
	   	$("#entity").autocomplete("/gdoc/moleculeTarget/relevantTerms",{
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
        <title>Molecule Target - Search</title>         
    </head>
    <body>
	<p style="font-size:14pt">Search for Compounds</p><br />
	<g:if test="${flash.message}">
	<span class="message">${flash.message}</span>
	</g:if>
	<g:if test="${params.page == 'sketch'}">
		<g:javascript>
			var page = "sketch"
		</g:javascript>
	</g:if>
<div id="centerContent">
	
	<div class="tabDiv" style="border:1px solid silver">
		<div id="centerTabs" class="tabDiv" style="width:550px;height:450px;border:0px solid black">
		    <ul>
		        <li><a href="#fragment-4"><span>Input Search</span></a></li>
		        <li><a href="#fragment-5"><span>Sketch Search (beta)</span></a></li>
		    </ul>
			
			 <div id="fragment-4">

			<g:form url='[controller: "moleculeTarget", action: "searchLigands",method:"post"]' id="searchableForm" name="searchableForm" method="get">
			<div class="errorDetail">
				<g:renderErrors bean="${flash.cmd?.errors}" field="entity" />
			</div>    
			<table class="formTable">
				<tr><td>
					Enter name for a gene, protein, molecule (or SMILES):	</td><td><g:textField id="entity" name="entity" value="${params.entity}" size="10"/> </td></tr>
				<tr><td>Ligand Affinity: </td><td><g:textField disabled="true" name="ligandAffinity" value="${params.ligandAffinity}" size="10"/> </td></tr>
				<tr><td colspan="2">
					<div class="errorDetail">
						<g:renderErrors bean="${flash.cmd?.errors}" field="molWeightLow" />
					</div>
					<g:textField name="molWeightLow" value="${params.molWeightLow}" size="6"/>&nbsp;&lt;&nbsp;molecular weight&nbsp;&lt;&nbsp;<g:textField name="molWeightHigh" value="${params.molWeightHigh}" size="6"/></td>

					</tr>
				<tr><td colspan="2" style="text-align:right"><input type="reset" value="Reset" /> | <input type="submit" value="Search" />
				</table>

			</g:form>

			</div>
		
			<div id="fragment-5">
				<%--script LANGUAGE="JavaScript1.1">
				msketch_name = "MSketch";
				msketch_begin("/gdoc/applets/marvin/", 540, 400);
				msketch_param("molbg", "#ffffff");
				msketch_end();

				</script--%>
				<span class="applet">
				<applet code="org.openscience.jchempaint.applet.JChemPaintEditorApplet" archive="/gdoc/applets/jchemPaint/jchempaint-applet-core.jar"
						id="Editor"
				        width="500" height="400">
				<!--param name="load" value="applettests/big.mol"-->
				<param name="impliciths" value="true">
				<param name="codebase_lookup" value="false" />

				<PARAM name="onLoadTarget" value="statusFrame">
				<PARAM NAME="image" VALUE="hourglass.gif">
				<PARAM NAME="boxborder" VALUE="false">
				<PARAM NAME="centerimage" VALUE="true">
				</applet>
				<g:form name="MolForm" url='[controller: "moleculeTarget", action: "searchLigandsFromSketch"]'>
				<input value="Write SMILES String" onclick="exportMol()" type="button" style="display:none">
				<g:textField name="smiles" style="display:none"/>
				<g:submitButton name="search_molecules" value="search molecules" onclick="exportMol();return false;"/>
				
				<a href="javascript:alert(document.Editor.getSmiles())">show smiles</a>
				
				</g:form><br /><br />
				
				
				</span>
				<br><br>
				
				
			</div>	
		</div>
	</div>
</div>


<span>
	<g:if test="${search}">
    <g:if test="${ligands?.results}"><br />
	
	<div class="title"
     <div class="paging">
	      Page:
	      <g:set var="totalPages" value="${Math.ceil(ligands.total / ligands.max)}" />
	      <g:if test="${totalPages == 1}"><span class="currentStep">1</span></g:if>
	      <g:else>
			<g:paginate controller="moleculeTarget" action="page" total="${ligands.total}" prev="&lt; previous" next="next &gt;"/>
		  </g:else>
	          
	      
	    </div>
	</div>
  </span>
<div>



<g:if test="${ligands?.results}">
	
	<table class="resultTable">
	<g:each in="${ligands.results}" var="molecule">
	<g:if test="${molecule}">
	<g:set var="moleculePaths" value="${molecule.structures?.toArray().collect{it.structureFile.relativePath}}" />
		
		<g:set var="ligandImg" value="${moleculePaths.find{it.contains('.png')}}" />
	<tr><td style="border-bottom:1px solid orange" colspan="2"><div style="font-size:1em;"><strong>${molecule.name}</strong></div></td></tr>
	<g:if test="${molecule.protectionGroup}">
		<tr><td colspan="2"><div style="font-size:.9em;">This compound is accessible to ${molecule.protectionGroup.name}</div></td></tr>
	</g:if>	
	<tr>
	
		<td valign="top" style="width:40%;padding-left:20px">
			<table class="studyTable" style="width:100%">
				<tr>
					<th>Property</th>
					<th>Value</th>
				</tr>
				<tr>
					<td>Formula</td>
					<td>${molecule.formula}</td>
				</tr>
				<tr>
					<td>Molecular Weight</td>
					<td>${molecule.weight}</td>
				</tr>
				<tr>
					<td>Refractivity</td>
					<td>${molecule.refractivity}</td>
				</tr>
				<tr>
					<td>Solubility</td>
					<td>${molecule.solubility}</td>
				</tr>
				<tr>
					<td>PH</td>
					<td>${molecule.ph}</td>
				</tr>
			</table>
		</td>
		<td valign="top" style="width:40%;padding-left:20px">
			<table class="studyTable" style="width:100%">
				<tr>
						<th>Property</th>
						<th>Value</th>
				</tr>
				<tr>
					<td>Donor Atoms</td>
					<td>${molecule.donorAtoms}</td>
				</tr>
				<tr>
					<td>Acceptor Atoms</td>
					<td>${molecule.acceptorAtoms}</td>
				</tr>
				<tr>
					<td>ClogP</td>
					<td>${molecule.clogP}</td>
				</tr>
				<tr>
					<td>Rotatable Bonds</td>
					<td>${molecule.rotatableBonds}</td>
				</tr>
				<tr>
					<td>Chiral</td>
					<td>${molecule.chiral}</td>
				</tr>
				
			</table><br />
		</td>
		<td style="text-align:right">
			<img src="/gdoc/moleculeTarget/display?inputFile=${ligandImg}&dimension=2D" />
			</td>
		
	</tr>
	<tr><td colspan="2">
		<div style="float:left;padding:10px">
			<img src="${createLinkTo(dir:'images',file:'target.png')}" border="0" />
			Targets:
			<g:if test="${molecule.bindings}">
				<g:each in="${molecule.bindings}" var="target">
					<g:link action="show" id="${target.id}">
						<g:set var="targetProt" value="${target.protein.gene?.geneAliases?.toArray().collect{it.symbol}}" />
							${targetProt.join(",")}
					</g:link>
				</g:each>
			</g:if>
			<g:else>
				No targets currently found for this compound
			</g:else>
			<br />
			SMILES: ${molecule.smiles}
		</div>
		</td>
	</tr>
	</g:if>
	</g:each>
	</table>
</g:if> 


<div>
    <div class="paging">
      <g:if test="${ligands?.results}">
          Page:
          <g:set var="totalPages" value="${Math.ceil(ligands.total / ligands.max)}" />
          <g:if test="${totalPages == 1}"><span class="currentStep">1</span></g:if>
          <g:else>
			<g:paginate controller="moleculeTarget" action="page" total="${ligands.total}" prev="&lt; previous" next="next &gt;"/>
		  </g:else>
      </g:if>
    </div>
  </div>
</div>
</g:if>
<g:else>
No results found 
<g:if test="${params.entityName}">
 for ${params.entityName}
</g:if>
</g:else>
</g:if>
