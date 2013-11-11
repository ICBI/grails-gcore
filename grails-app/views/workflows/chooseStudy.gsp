<html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<g:javascript>
			$(document).ready(function(){
				$(".selectpicker").each(function(){this.selectedIndex = 0});
				$(".selectpicker").selectpicker();
				if($(".selectpicker").size() == 1) $("#help").hide();
				$("#type").change(function() {
					if($("#type").val() && $("#disease").val()) {
						queryForDisease();
					}
		 		  }); // end clicked button to trigger AJAX
				$("#disease").change(function() {
					if($("#type").val() && $("#disease").val()) {
						queryForDisease();
					}
		 		  });
		 		$("#study").change(function() {
		 			if($("#study").val() && $("#study").val() != '') {
		 				$("#submit").show();
		 			}
		 			else $("#submit").hide();
		 		});
			});
			function queryForDisease() {
				jQuery.getJSON("/${appName()}/studyDataSource/findStudiesForDisease", { disease: $("#disease").val(), subjectType: $("#type").val() },
					function(j) {
					     // erase all OPTIONs from existing select menu on the page
					    $("#study options").remove();
						$("#study").bind('change', function() {
							$("#update").removeAttr('disabled');
						});
						// You will rebuild new options based on the JSON response...
					     var options = "<option value=''>Select A Study ...</option>";
					     // it is the array of key-value pairs to turn
					     // into option value/labels...
					     for (var i = 0; i < j.length; i++) {
					        options += "<option value = " +j[i].studyId + ">" +j[i].studyName +"</option>";
					     }
					     if(j.length <= 0) {
					     	$("#submit").hide();
					     }

					        // stick these new options in the existing select menu
					        $("#study").html(options);
					        $("#study").selectpicker('refresh');
					        
					        // now your select menu is rebuilt with dynamic info
					  }
				); // end getJSON
			}
			
			function selectStudy(form) {
				//alert($("#study").val());
				//form.submit();
				$("#studySelector").submit();
			}
		
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
		<div class="hero-unit">
			<p style="padding-left: 0px" class="lead">
				${flash.chooseStudy}
			</p>
			<br>
			<p style="padding-left: 0px; font-size: 11px" id="help">
				* To pick a study, select an option from each of the dropdowns going left to right
			</p>
			<g:form url="[controller:'studyDataSource',action:'setStudy']" name="studySelector" id="studySelector">
				<g:if test="${!params.operation}">
				<input type="hidden" name="workflowMode" value="study" />
				<div class="btn-toolbar">
					<div class="btn-group">

					  <select class="selectpicker span2" id="disease">
					  	<!-- <li>Breast Cancer</li> -->
					  	<option value="" selected>Select a disease</option>
					  	<g:each name="disease" in="${diseases}"><option>${it}</option></g:each>
					  </select>
					</div>	
					
					<div class="btn-group">
					  	
					  <select class="selectpicker span2" id="type" name="type">
					  	<option>Select subject matter</option>
					  	<g:each name="disease" in="${availableSubjectTypes.entrySet()}"><option>${it.value}</option></g:each>
					  </select>
					</div>	
					
					<div class="btn-group">						  	
					  <select class="selectpicker span2" id="study" name="study">
					  	<option>First select disease and subject matter</option>
					  </select>
					</div>	
													
				
				</div>
				</g:if>
				<g:else>
					<input type="hidden" name="workflowMode" value="operation" />
					<input type="hidden" name="operation" value="${params.operation}">
					<select class="selectpicker" id="study" name="study">
						<option value="">Please select a study</option>
						<g:each in="${filteredStudies.keySet()}" var="disease">
							
							<optgroup label="${disease}">
								<g:each in="${filteredStudies[disease]}" var="study">
									<option value="${study.id}" title="${study.longName}">${study.shortName}&nbsp;&nbsp;(${study.longName.substring(0, 20)}......${study.longName.substring(study.longName.length() - 20)})
								</g:each>											
							</optgroup>
						</g:each>
					</select>
										
				</g:else>
				<br><br>
				<input type="submit" id="submit" class="btn btn-primary" style="display: none" value="Submit" />					
			</g:form>					
		</div>

    </body>
</html>