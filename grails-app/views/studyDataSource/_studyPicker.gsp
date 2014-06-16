			
		<g:javascript library="jquery" plugin="jquery" />
		<g:javascript dir="js/jquery" file="jquery.tooltip.js" plugin="gcore"/>
		<g:javascript dir="js/jquery" file="jquery.ui.js" plugin="gcore"/>
		<g:javascript>
			$(document).ready(function (){
				$(".selectpicker").selectpicker();
				
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
				if($("#type").val()) {
					queryForDisease();
				}
				$("#changeStudy").click(function() {
				  	showStudyChange();
				});
			});
			
		function queryForDisease() {
			jQuery.getJSON("/${appName()}/studyDataSource/findStudiesForDisease", { disease: $("#disease").val(), subjectType: $("#type").val(), operation: $("#operation").val() },
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
				     for (var i = 0; i < j.length; i++)
				       {
						//console.log("load " + j[i]);
				        options += "<option value=" +
				        j[i].studyId + ">" +
				        j[i].studyName +
				        "</option>";
				        }
				        // stick these new options in the existing select menu
				        $("#study").html(options);
				        $("#study").selectpicker('refresh');
				        // now your select menu is rebuilt with dynamic info
				  }
			); // end getJSON
		}
		function reload(){
			if(${remote ?: false}) {
				$("#searchDiv").load("/${appName()}/${controllerName}/studyForm",{limit: 25}, function(){
					if(typeof bindBehaviour == 'function')
						bindBehaviour();
					});
				$("#changeStudy").css("display","block");
				$("#studyPageSpinner").css("visibility","hidden");
			} else {
				//location.reload(true);
				location.replace("/${appName()}/${controllerName}/${actionName}");
			}
			
		}
		
	
		function showStudyChange(){
			var visSelector = $("#studyFieldset").css("display");
			if(visSelector == 'none'){
				$("#studyFieldset").css("display","block");
				$("#changeStudy").html("hide study selector");
			}
			else{
				$("#studyFieldset").css("display","none");
				$("#changeStudy").html("change study?");	
			}
		}
		function showSpinner(){
			$("#studyPageSpinner").css("visibility","visible");
		}
		</g:javascript>
		
		<div style="font-size:1em;padding-top:5px">
			<span class="desc1">
				<g:if test="${!session.study}"><br><g:message code="gcore.noStudy"/></g:if>
				<g:else><g:message code="gcore.currentStudy"/>: ${session.study?.shortName}</g:else></span>
			<span style="display:inline-table;font-size:.8em">
				<g:if test="${session.study}">
					<a href="#" id="changeStudy" style="display:block;margin-left:10px;font-size:.95em;color: #03f"><g:message code="study.change"/></a>
				</g:if>
				<g:else>
					<a href="#" id="changeStudy" style="display:none;margin-left:10px;font-size:.95em;color: #03f"><g:message code="study.change"/></a>
				</g:else>
			</span>
			<br /><br />
		</div>
		<g:if test="${!session.study}">
		<div id="studyFieldset">
		</g:if>
		<g:else>
		<div id="studyFieldset" style="display:none">
		</g:else>
		<!-- <fieldset class="studyPicker"><legend style="margin:8px"><g:message code="study.choose"/></legend>  -->
		<div class="hero-unit" style="width: 900px; height:100px;">
			<g:formRemote name="setStudyForm" url="[controller:'studyDataSource',action:'setStudy']" update="label" onLoading="showSpinner();" onSuccess="reload();">
		<%--g:message code="study.disease"/>:--%>
		<g:select name="disease" class="selectpicker"
				noSelection="${['': message(code:'study.selectDisease')]}"
				from="${diseases}">
		</g:select>
		
		<g:select name="type" class="selectpicker"
				noSelection="${['': message(code:'study.selectType')]}"
				from="${availableSubjectTypes.entrySet()}" optionKey="key" optionValue="value">
		</g:select>
		
		<%--g:message code="study.study"/>:--%>
		<g:select name="study" class="selectpicker"
				noSelection="${['': message(code: 'study.selectStudy')]}" from="${[]}">
				
		</g:select>
		<input type="hidden" name="operation" id="operation" value="${controllerName}">
		<%--from="${myStudies}"
		value="${session.study?.id}"
		optionKey="id" optionValue="shortName"--%>
			<br /><span style="float:right">
		    <g:submitButton class="btn btn-primary" name="update" value="set study" disabled="true"/>
			</span>
			<span id="studyPageSpinner" style="visibility:hidden;display:inline-table"><img src="${resource(dir: 'images', file: 'spinner.gif', plugin: 'gcore')}" alt='Wait'/></span>
		</g:formRemote>
		<p style="font-size:11px;">** This list will only show studies relevant to this workflow and hence may not be a complete list. To see a 
		complete list go back to <a href="<g:createLink controller='workflows'/>" style="color: #03f" >home</a> page</p>
		</div>
		<!-- </fieldset> -->
		</div>