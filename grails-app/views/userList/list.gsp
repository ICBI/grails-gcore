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


        <!-- jQuery -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

        <!-- Demo stuff -->
        <link class="ui-theme" rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/cupertino/jquery-ui.css">
        <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>

        <!--link rel="stylesheet" href="${createLinkTo(dir: 'css/grouping',  file: 'jq.css')}"/-->
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/grouping',  file: 'prettify.css')}"/>

        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping', file: 'prettify.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping', file: 'docs.js')}"></script>
        <style id="css">/* extra css needed because there are 5 child rows */

        /* Grouping widget css */
        tr.group-header td {
            background: #eee;
        }
        .group-name {
            text-transform: uppercase;
            font-weight: bold;
        }
        .group-count {
            color: #999;
        }
        .group-hidden {
            display: none !important;
        }
        .group-header, .group-header td {
            user-select: none;
            -moz-user-select: none;
        }
        /* collapsed arrow */
        tr.group-header td i {
            display: inline-block;
            width: 0;
            height: 0;
            border-top: 4px solid transparent;
            border-bottom: 4px solid #888;
            border-right: 4px solid #888;
            border-left: 4px solid transparent;
            margin-right: 7px;
            user-select: none;
            -moz-user-select: none;
        }
        tr.group-header.collapsed td i {
            border-top: 5px solid transparent;
            border-bottom: 5px solid transparent;
            border-left: 5px solid #888;
            border-right: 0;
            margin-right: 10px;
        }</style>
        <!-- Tablesorter: required -->
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/grouping',  file: 'theme.blue.css')}"/>
        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping', file: 'jquery.tablesorter.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping', file: 'jquery.tablesorter.widgets.js')}"></script>


        <!-- grouping widget -->
        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping/parsers', file: 'parser-input-select.js')}"></script>
        <script type="text/javascript" src="${createLinkTo(dir: 'js/grouping/widgets', file: 'widget-grouping.js')}"></script>


        <script id="js">$(function(){

            $("table").tablesorter({
                theme : 'blue',
                sortList : [[1,0]],
                widgets: ['group', 'filter'],
                widgetOptions: {
                    group_collapsible : true,
                    group_collapsed   : true,
                    group_count       : false,
                    filter_childRows  : false
                }
            });

            $('.tablesorter-childRow td').hide();

            $('.tablesorter').delegate('.toggle', 'click' ,function(){
                $(this).closest('tr').nextUntil('tr:not(.tablesorter-childRow)').find('td').toggle();
                return false;
            });

        });

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



        </script>



    </head>
    <body>

    <div class="welcome-title"><g:message code="userList.manage"/></div>
    <div class="desc">Below are all G-DOC Plus saved Lists. You can view, modify, upload, export and share Lists with other groups.
    </div>
    <span id="message" class="message" style="display:none"></span>
    <span style="display:none" class="ajaxController">userList</span>

    <div class="features">
        <div class="desc1" style="margin-left:0px;margin-top: 0px;">
            You can use the filter below to search for a specific list. You can also use the tool Panel on the right to manipulate data in the saved lists.<br/>
        </div>

        <g:form name="filterForm" action="list">
            <g:message code="userList.filter"/>&nbsp;&nbsp;
            <g:select  style="width:270px;margin-top: 8px;" name="listFilter"
                       noSelection="${['':'Filter Lists...']}"
                       value="${session.listFilter?:'value'}"
                       from="${timePeriods}"
                       optionKey="key" optionValue="value">
            </g:select>


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

            <g:if test="${allLists > 0 && userListInstanceList.size() >0}">
                <div class="list" id="allLists">
                    <g:render template="/userList/userListTable" model="${['userListInstanceList':userListInstanceList]}" plugin="gcore"/>
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