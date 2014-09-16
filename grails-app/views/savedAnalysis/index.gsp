
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
    <div class="desc">Below is the list of G-DOC Plus saved Analyses. You can view, modify and share your saved analysis with other groups. You can use the filter below to search and filter the list.</div>

    <div class="features" style="padding-left: 40px;padding-right: 40px;">
        <div class="desc1" style="margin-left:0px;margin-top: 0px;">
            You can use the filter below to find a specific analysis.
        </div>
                <g:form name="filterForm" action="index">
                    <g:message code="savedAnalysis.filter"/>&nbsp;
                    <g:select style="width:270px;margin-top: 8px;" name="analysisFilter"
                        noSelection="${['': message(code: 'savedAnalysis.filter') + '...']}"
                        value="${session.analysisFilter?:'value'}"
                        from="${timePeriods}"
                        optionKey="key" optionValue="value">
                    </g:select>
                    <br/>
                    <g:if test="${session.analysisFilter}">
                        <span><g:message code="savedAnalysis.total"/>: ${allAnalysesSize}&nbsp;&nbsp; |<g:message code="savedAnalysis.filter"/>: ${session.analysisFilter}|</span>
                    </g:if>

                    <g:if test="${session.analysisFilter!='search'}">
                    <div id="searchBox" style="display:none;padding-top:8px">
                    </g:if>
                    <g:else>
                    <div id="searchBox" style="padding-top:8px;">
                    </g:else>
                    <g:message code="savedAnalysis.search"/><br />
                    <g:textField style="margin-top: 8px; " name="searchTerm" id="searchTerm"  />
                    <g:submitButton class="btn" value="search" name="searchButton"/>
                    </div>

                </g:form>


                <g:if test="${savedAnalysis.size() > 0}">
                <fieldset style="border:0px solid black">

                    <div id="pager1" style="text-align:right;padding:2px 10px 3px 0px; float:right;">
                        <g:set var="totalPages" value="${Math.ceil(allAnalysesSize / savedAnalysis.size())}" />

                        <g:if test="${totalPages == 1}">
                            <span class="currentStep">1</span>
                        </g:if>
                        <g:else>
                            <g:paginate controller="savedAnalysis" action="index"
                                        total="${allAnalysesSize}" prev="&lt; ${message(code:'search.previous')}" next="${message(code: 'search.next')} &gt;" params="[searchTerm:params?.searchTerm]" />
                        </g:else>
                    </div>

                    <g:form name="delAnalysisForm" action="deleteMultipleAnalyses">
                        <span class="controlBarUpload" id="controlBarDelete">
                            <input type="checkbox" class="checkall"> <g:message code="savedAnalysis.checkAll"/>&nbsp;&nbsp;&nbsp;&nbsp;
                        <g:submitButton class="btn" name="del" value="${message(code: 'savedAnalysis.delete')}" style="font-size: 12px;color:black;text-decoration:none;padding: 3px 8px;background-color:#E6E6E6;border: 1px solid #a0a0a0;margin: 5px 3px 3px 5px;" onclick="return confirm('${message(code: 'userList.confirm')}');" />
                        </span>
                    </g:form>

                    <div id="analysisContainer">
                        <g:render template="/savedAnalysis/savedAnalysisTable" plugin="gcore" />
                    </div>

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
        </div>
</div>
</body>