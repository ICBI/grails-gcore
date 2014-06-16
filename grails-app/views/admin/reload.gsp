<html>
    <head>
        <title><g:message code="admin.title" args="${ [appTitle()] }" /></title>
		<meta name="layout" content="adminLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'scrollable-navig.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'dialog.css')}"/>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap-select.min.css')}"/>

        <g:javascript>
			function success(){
					$("#spinner").css("visibility","hidden");
			}
			function loading(){
					$("#spinner").css("visibility","visible");
					$("#status").html("Status: loading")
			}
			 
		</g:javascript>
    </head>
    <body>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<jq:plugin name="ui"/>
		<jq:plugin name="autocomplete"/>
		<g:javascript>
		$(document).ready(function(){
		   	$("#q").autocomplete("/${appName()}/search/userAutocomplete",{
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
        <div class="welcome-title"><g:message code="admin.heading" args="${ [appTitle()] }" /> </div>
        <g:if test="${flash.message}">
            <div class="alert alert-info"> ${flash.message}</div>
        </g:if>
		<div id="centerContent">

                <div class="desc1"> <g:message code="admin.dataLoading" /></div>
                <div class="well">
                    <div>
                        <div style="padding:7px;background-color:seashell;">
                            <g:link action="reload" onclick="loading()"><g:message code="admin.reloadData" /></g:link><br />
                            <span id="status">Status:
                            <g:if test="${loadedStudies}">${loadedStudies.size()} <g:message code="admin.studiesLoaded" /></g:if>
                            <g:else> <g:message code="admin.noStudies" /></g:else>
                            </span>
                            <span id="spinner" style="visibility:hidden;display:inline-table"><img src='/${appName()}/images/spinner.gif' alt='Wait'/></span>
                        </div>

                        <div style="padding:5px;background-color:#f2f2f2;">
                            <g:if test="${loadedStudies}">
                                ${loadedStudies}
                            </g:if>
                            <g:else>
                                <g:message code="admin.noStudies" />
                            </g:else>
                        </div>
                    </div>

                </div>




                <div class="desc1"><g:message code="admin.userAdmin" /></div>
                <div class="well">
                    <g:message code="admin.findUser" /><br /><br />
                    <g:form controller="GDOCUser" action="list" autocomplete="off">
                        <g:textField style="height:25px;" name="userId" id="q" /><br /><br />
                        <g:submitButton class="btn btn-default" name="search" value="${message(code: 'admin.searchUser')}" />
                    </g:form>
                </div>


        </div>
	</body>
	
</html>