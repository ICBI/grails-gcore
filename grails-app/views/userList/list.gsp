<strong>

<html>
<head>
	<meta name="layout" content="listsMain" />
	<title>User Lists</title>
	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="ui"/>
	<jq:plugin name="styledButton"/>
	<jq:plugin name="tooltip"/>
	<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'dialog.css')}"/>
	<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'thickbox-compressed.js')}"></script>
	<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'jquery.editableText.js')}"></script>
	<STYLE type="text/css">
	   #tooltip {
	text-align:left;
	font-size: 100%;
	min-width: 90px;
	max-width: 180px;
	}
	 </STYLE>
	
	<script type="text/javascript">
		function toggle(element){
			$('#'+element+'_content').slideToggle();
			$('.'+element+'_toggle').toggle();
		}
	
	</script>
	
	
</head>
<body>
	
	<g:javascript>
	$(document).ready( function () {
				$('.info').tooltip({showURL: false});
				$('#listFilter').change(function() {
					if($('#listFilter').val() && $('#listFilter').val() == 'search') {
						$('#listFilter').val("search");
						showSearchForm(true);
					}
					if($('#listFilter').val() && $('#listFilter').val() != 'search'){
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
	

    <div class="welcome-title"><g:message code="userList.manage"/></div>
    <div class="desc">Below are all G-DOC Plus saved Lists. You can view, modify, upload, export and share Lists with other groups.
    </div>
    <span id="message" class="message" style="display:none"></span>
    <span style="display:none" class="ajaxController">userList</span>

    <div class="features">
        <div class="desc1" style="margin-left:0px;margin-top: 0px;">
            You can use the filter below to search for a specific list. You can also use the tool Panel on the right to manipulate data in the saved lists.<br/>
        </div>

            <span>
			<g:form name="filterForm" action="list">
			<g:message code="userList.filter"/>&nbsp;&nbsp;
                <g:select  style="width:270px;margin-top: 8px;" name="listFilter"
				noSelection="${['':'Filter Lists...']}"
				value="${session.listFilter?:'value'}"
				from="${timePeriods}"
				optionKey="key" optionValue="value">
			</g:select>
			</span>

			<g:if test="${session.listFilter!='search'}">
			<div id="searchBox" style="display:none;padding-top:8px">
			</g:if>
			<g:else>
			<div id="searchBox" style="padding-top:8px">
			</g:else>
			<g:message  style="padding-top:8px;" code="userList.search"/><br />
			<g:textField style="margin-top: 8px; " name="searchTerm" id="searchTerm" size="15" />
			<g:submitButton class="btn" value="search" name="searchButton"/>
			</div>
			</g:form>

            <g:form name="delListForm" action="deleteMultipleLists">
                    <span class="controlBarUpload" id="controlBarUpload" >
                       <g:link class="btn thickbox" name="Upload custom list" action="upload" style="font-size: 12px;color:black;text-decoration:none;background-color:#E6E6E6;width:80px;border: 1px solid #a0a0a0;margin: 1px 3px 1px 3px;"
                        params="[keepThis:'true',TB_iframe:'true',height:'350',width:'600',title:'someTitle']"><g:message code="Upload"/></g:link>
                    </span>
                    <span class="controlBarUpload" id="controlBarDelete">
                        <g:submitButton class="btn" name="del" value="${message(code: 'userList.deleteLists')}" style="font-size: 12px;color:black;text-decoration:none;padding: 4px 13px;background-color:#E6E6E6;border: 1px solid #a0a0a0;margin: 1px 3px 1px 3px;" onclick="return confirm('${message(code: 'userList.confirm')}');" />
                    </span>
           			<g:if test="${allLists > 0 && userListInstanceList.size() >0}">
                           <div id="pager1" style="text-align:right;padding:2px 10px 3px 0px">
                           <g:set var="totalPages" value="${Math.ceil(allLists / userListInstanceList.size())}" />
                           <g:if test="${totalPages == 1}">
                               <span class="currentStep">1</span>
                           </g:if>
                           <g:else>
                               <g:paginate controller="userList" action="list"
                               total="${allLists}" prev="&lt; previous" next="next &gt;" params="[searchTerm:params?.searchTerm]"/>
                           </g:else>
           			</div>

           			<div class="list" id="allLists">
           				<g:render template="/userList/userListTable" model="${['userListInstanceList':userListInstanceList]}" plugin="gcore"/>
           			</div>

           			<div id="pager2" style="text-align:right;padding:2px 10px 3px 0px">
           				<g:set var="totalPages" value="${Math.ceil(allLists/ userListInstanceList.size())}" />

               			<g:if test="${totalPages == 1}">
                   			<span class="currentStep">1</span>
               			</g:if>
               			<g:else>
                   			<g:paginate controller="userList" action="list"
                               total="${allLists}" prev="&lt; previous" next="next &gt;" params="[searchTerm:params?.searchTerm]"/>
               			</g:else>
           			</div>
           			</g:if>
           			<g:else>
                        </br></br></br>
           				<p class="desc1" style="margin-left:-10px;"><g:message code="userList.noSaved"/></p>
           			</g:else>
           		</g:form>


</div>


</body>
</html>
</strong>