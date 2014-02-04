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
		<link rel="stylesheet" href="${createLinkTo(dir:'css',file:'chosen.css')}" />
		<g:javascript library="jquery" plugin="jquery"/>   
		<g:javascript src="chosen.jquery.js" plugin="gcore"/>
    </head>
    <body>
		<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.styledButton.js" plugin="gcore"/>
		<g:javascript src="jquery/jquery.blockUI.js" plugin="gcore"/>
		<g:javascript src="jquery-contained-sticky-scroll.js" plugin="gcore"/>
		<g:jqgrid />
	<g:javascript>
	$(document).ready(function (){
		$("#user_switchAttribute").chosen();
		$('.resultsStick').containedStickyScroll({
		        duration: 300,
		        unstick: true,
		        closeChar: '' 
		});
		
	});
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


    <div class="welcome-title">Clinical Search</div>

    <div id="studyPicker">
        <g:render template="/studyDataSource/studyPicker" plugin="gcore"/>
        <g:if test="${!session.study}">
            <div class="filterInstructions">
                Once you've selected a study above, use the filter panel that will appear here
                to narrow your cohort selection based on subject attributes (categorical as well as continuous)
            </div>
            <br />
        </g:if>
    </div>

    <table>
        <td style="vertical-align:top;">
            <div style="width:280px;border:0px solid black;" class="bParent">

                <div style="border:0px solid #999999;">
                    <g:render template="/clinical/filter" plugin="gcore"/>
                </div>
            </div>
        </td>
        <td style="vertical-align:top;">
            <div style="float:right;">
                <div style="font-size:1.3em;margin-left:15px;padding-top:5px;color:#444444">Subject Search&nbsp;&nbsp;&nbsp;
                </div>
                <div class="breadcrumbs">
                </div>

                <div style="border:0px solid black;padding-top:25px;display:inline-table;margin-left:15px" >
                    <g:if test="${session.splitAttribute}">
                        <span class="group">Current Split Attribute</span><img class="info" title="An arbitrary vocabulary attribute that can optionally be used to separate the results into cohorts for easy comparison" src="${createLinkTo(dir:'images',file:'help.png')}" border="0" /><br>
                        <g:select class="splitAtt" name="user_switchAttribute" id="user_switchAttribute"
                                  noSelection="${['NONE':'None...']}" value="${session.splitAttribute}"
                                  from="${session.vocabList}" optionKey="shortName" optionValue="longName">

                        </g:select>
                    </g:if>
                </div>
                <br/>
                <div style="border:0px solid black;width:100%;margin-left:15px"  class="resultsStick">
                    <table border="0">

                        <tr>
                            <td id="filterResults">
                                <g:if test="${!session.study}">
                                    <table class="filterTable" id="patientsTable" width="100%">
                                        <th colspan="5">Disease/Data Overview</th>
                                        <tr>
                                            <th style="background-color:#EBF1FF;border:1px solid #999999"><g:message code="home.disease" /></th>
                                    <th style="background-color:#EBF1FF;border:1px solid #999999"><g:message code="home.study" /></th>
                                    <th style="background-color:#EBF1FF;border:1px solid #999999"><g:message code="home.patients" /></th>
                                    <th style="background-color:#EBF1FF;border:1px solid #999999"><g:message code="home.biospecimens" /></th>
                                    <th style="background-color:#EBF1FF;border:1px solid #999999"><g:message code="home.availableData" /></th>
                                    <g:if test="${diseaseBreakdown}">
                                        <g:each in="${diseaseBreakdown}" var="item" status="i">
                                            <g:if test="${i == diseaseBreakdown.size()-1}">
                                                <tr style="font-size: .9em;" class="totalsLine">
                                            </g:if>
                                            <g:else>
                                                <tr style="font-size: .9em;" >
                                            </g:else>

                                            <td>${item.key}</td>
                                            <td>${item.value.studyNumber}</td>
                                            <td>${item.value.patientNumber}</td>
                                            <td>${item.value.biospecimenNumber}</td>
                                            <td>
                                                <g:each in="${item.value.availableData}" var="nameAndImage" status="j">
                                                    <g:each in="${nameAndImage}" var="n">
                                                        <g:if test="${n.key != 'BIOSPECIMEN' && n.key != 'CELL_LINE'}">
                                                            <g:set var="okey" value="${n.key}" />
                                                            <g:if test="${n.key == 'REPLICATE'}">
                                                                <g:set var="okey" value="CELL LINE" />
                                                            </g:if>
                                                            <img src="${resource(dir: 'images', file: okey.replace(" ","_") + '_icon.gif')}" alt="${okey}" class="info" title="${okey}" />
                                                        </g:if>

                                                    </g:each>
                                                </g:each>
                                            </td>
                                            </tr>
                                        </g:each>
                                    </g:if>
                                    <g:else>
                                        <tr>
                                            <td><g:message code="home.errorService" /></td>
                                        </tr>
                                    </g:else>
                                    </tr>
                                </table>
                                </g:if>
                                <br>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

        </td>
    </table>





	</body>
	
</html>
