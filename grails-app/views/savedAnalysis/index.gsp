
<html>
<head>
	<meta name="layout" content="main" />
	<title><g:message code="savedAnalysis.title"/></title>
	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="ui"/>
	<jq:plugin name="styledButton"/>
	<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'thickbox-compressed.js')}"></script>
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'dialog.css')}"/>
	<script type="text/javascript">
		function toggle(element){
			$('#'+element+'_content').slideToggle();
			$('.'+element+'_toggle').toggle();
		}
		</script>
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styledButton.css')}" />
</head>
<body>
	<g:javascript>
	$(document).ready( function () {
			$('#analysisFilter').change(function() {
				if($('#analysisFilter').val() && $('#analysisFilter').val() == 'search') {
					$('#analysisFilter').val("search");
					showSearchForm(true);
				}
				if($('#analysisFilter').val() && $('#analysisFilter').val() != 'search'){
					$('#filterForm').submit();
				}
	 		});
	
			$('#filterSearchForm').submit(function() {
				if($('#searchTerm').val() == ""){
					alert("please enter a search term");
					return false;
				}else{
					return true;
				}
			});
			
		 	
		});
		
		$(document).ready( function () {
				$('.checkall').click(function () {
						$(this).parents('fieldset:eq(0)').find(':checkbox').attr('checked', this.checked);
					});


		} );
		
		function showSearchForm(show){
			if(show){
				$("#searchBox").css("display","block");
			}
			else{
				$("#searchBox").css("display","none");
			}
		}

		
	</g:javascript>
	
	
	<div class="body">
		<div class="welcome-title"><g:message code="savedAnalysis.title"/></div>
	    <div class="desc">Below is the list of G-DOC Saved Analysis. You can view, modify and share your saved analysis with other groups. You can use the filter below to search and filter the list.</div>
	    <div class="desc1">
	           <g:if test="${session.analysisFilter}">
            		<span><g:message code="savedAnalysis.total"/>: ${allAnalysesSize}&nbsp;&nbsp; |<g:message code="savedAnalysis.filter"/>: ${session.analysisFilter}|</span>
               </g:if>
        </div>
		<span style="display:none" class="ajaxController">savedAnalysis</span>
		<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
		</g:if>

		<div class="well well-sm">
         			<span>
         			<g:form name="filterForm" action="index">
         			<g:message code="savedAnalysis.filter"/>:&nbsp;<g:select name="analysisFilter"
         				noSelection="${['': message(code: 'savedAnalysis.filter') + '...']}"
         				value="${session.analysisFilter?:'value'}"
         				from="${timePeriods}"
         				optionKey="key" optionValue="value">
         			</g:select>

         			</span>

         			<g:if test="${session.analysisFilter!='search'}">
         			<div id="searchBox" style="display:none;padding-top:8px">
         			</g:if>
         			<g:else>
         			<div id="searchBox" style="padding-top:8px">
         			</g:else>
         			<g:message code="savedAnalysis.search"/><br />
         			<g:textField name="searchTerm" id="searchTerm" size="15" />
         			<g:submitButton value="search" name="searchButton"/>
         			</div>
         			</g:form>
         </div>

         <g:form name="delAnalysisForm" action="deleteMultipleAnalyses">
                <span class="controlBarUpload" id="controlBarDelete">
                <g:submitButton name="del" value="${message(code: 'savedAnalysis.delete')}" style="font-size: 12px;color:black;text-decoration:none;padding: 3px 8px;background-color:#E6E6E6;border: 1px solid #a0a0a0;margin: 5px 3px 3px 5px;" onclick="return confirm('${message(code: 'userList.confirm')}');" />
                </span>
         </g:form>

		<g:if test="${savedAnalysis.size() > 0}">
		<fieldset style="border:0px solid black">

		<div><input type="checkbox" class="checkall"> <g:message code="savedAnalysis.checkAll"/></div>
		
		<div id="pager1" style="text-align:right;padding:2px 10px 3px 0px">
		<g:set var="totalPages" value="${Math.ceil(allAnalysesSize / savedAnalysis.size())}" />

	    <g:if test="${totalPages == 1}">
	        <span class="currentStep">1</span>
	    </g:if>
	    <g:else>
	        <g:paginate controller="savedAnalysis" action="index" 
	                    total="${allAnalysesSize}" prev="&lt; ${message(code:'search.previous')}" next="${message(code: 'search.next')} &gt;" params="[searchTerm:params?.searchTerm]" />
	    </g:else>
		</div>
		
        <g:panel title="My Saved Analysis" styleClass="welcome" contentClass="myPanelContent" id="savedAnalysis">
            <div id="analysisContainer">
            <g:render template="/savedAnalysis/savedAnalysisTable" plugin="gcore" />
            </div>
        </g:panel>

		<div id="pager2" style="text-align:right;padding:2px 10px 3px 0px">
		<g:set var="totalPages" value="${Math.ceil(allAnalysesSize / savedAnalysis.size())}" />

	    <g:if test="${totalPages == 1}">
	        <span class="currentStep">1</span>
	    </g:if>
	    <g:else>
	        <g:paginate controller="savedAnalysis" action="index" 
	                    total="${allAnalysesSize}" prev="&lt; ${message(code:'search.previous')}" next="${message(code: 'search.next')} &gt;" params="[searchTerm:params?.searchTerm]"/>
	    </g:else>
		</div>
		</fieldset>
		</g:if>
		<g:else>
			<p><g:message code="savedAnalysis.no"/></p>
		</g:else>
	</div>

</body>