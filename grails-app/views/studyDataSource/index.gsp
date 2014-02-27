<html>
    <head>
        <meta name="layout" content="maxSpaceLayout" />
        <title><g:message code="study.title"/></title>

        <script language="JavaScript">

            (function(document) {
                'use strict';

                var LightTableFilter = (function(Arr) {

                    var _input;

                    function _onInputEvent(e) {
                        _input = e.target;
                        var tables = document.getElementsByClassName(_input.getAttribute('data-table'));
                        Arr.forEach.call(tables, function(table) {
                            Arr.forEach.call(table.tBodies, function(tbody) {
                                Arr.forEach.call(tbody.rows, _filter);
                            });
                        });
                    }

                    function _filter(row) {
                        var text = row.textContent.toLowerCase(), val = _input.value.toLowerCase();
                        row.style.display = text.indexOf(val) === -1 ? 'none' : 'table-row';
                    }

                    return {
                        init: function() {
                            var inputs = document.getElementsByClassName('light-table-filter');
                            Arr.forEach.call(inputs, function(input) {
                                input.oninput = _onInputEvent;
                            });
                        }
                    };
                })(Array.prototype);

                document.addEventListener('readystatechange', function() {
                    if (document.readyState === 'complete') {
                        LightTableFilter.init();
                    }

                    /*// Javascript to enable link to tab
                    var url = document.location.toString();
                    if (url.match('#')) {
                        $('.nav-tabs a[href=#'+url.split('#')[1]+']').tab('show') ;
                    }
                    // Change hash for page-reload
                    $('.nav-tabs a').on('shown', function (e) {
                        window.location.hash = e.target.hash;
                    });
                    */
                });
            })(document);

        </script>

        <script type="text/javascript">
            $(function() {
                // Javascript to enable link to tab
                var url = document.location.toString();
                if (url.match('#')) {
                    $('.nav-tabs a[href=#'+url.split('#')[1]+']').tab('show') ;
                }

                // Change hash for page-reload
                $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
                    window.location.hash = e.target.hash;
                });
            });
        </script>
        <style>
        .order-table, .order-table1, .order-table2, tr:nth-child(even)		{ background-color:#F8F8F8; }
        .order-table, .order-table1, .order-table2, tr:nth-child(odd)		{ background-color:#fff; }
        </style>

    </head>
    <body>

    <div class="welcome-title"><g:message code="study.title"/></div>

        <div class="features"  >
            <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                <li class="active"><a href="#mystudies" data-toggle="tab"  >My Studies</a></li>
                <li><a href="#myhistory" data-toggle="tab">My History</a></li>
                <li><a href="#otherstudies" data-toggle="tab">Private Studies</a></li>
            </ul>
            <div id="my-tab-content" class="tab-content">
                <div class="tab-pane active" id="mystudies">
                    <div  class="" style="font-size: 12px;">
                        <div class="desc1">
                            Below is an overview of all the studies in G-DOC that you have access to. You can explore each study, view the details and use the available tools to analyse and search the data. Use the filter below to filter the table.
                            <br/><br/><input type="search" class="light-table-filter" data-table="order-table" placeholder="Filter" />
                        </div>

                        <table class="order-table table">
                            <thead>
                            <th><g:message code="study.name"/></th>
                            <th style="width:5%"><g:message code="study.id"/></th>
                            <th style="width:30%"><g:message code="study.description"/></th>
                            <th><g:message code="study.pi"/></th>
                            <th><g:message code="study.disease"/></th>
                            <th><g:message code="study.subjectType"/></th>
                            <th><g:message code="study.poc"/></th>
                            </thead>
                            <g:each in="${myStudies}" var="study">
                                <tr>
                                    <td ><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
                                    <td style="vertical-align:top">${study.id}</td>
                                    <td style="vertical-align:top">${study.longName}</td>
                                    <td style="vertical-align:top">
                                        <g:each in="${study.pis}" var="pi">
                                            ${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
                                        </g:each>
                                    </td>
                                    <td style="vertical-align:top">${study.disease}</td>
                                    <td style="vertical-align:top">${study.subjectType?.replace("_"," ")}</td>
                                    <td style="vertical-align:top">
                                        <g:each in="${study.pocs}" var="poc">
                                            ${poc.firstName} ${poc.lastName}<br/><br/>
                                        </g:each>
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                    </div>
                </div>
                <div class="tab-pane" id="myhistory">
                        <div  class="" style="font-size: 12px;">
                            <div class="desc1">
                                The list below is your G-DOC studies history. The history shows the last 10 studies that you selected.
                                <br/><br/><input type="search" class="light-table-filter" data-table="order-table1" placeholder="Filter" />
                            </div>
                            <g:if test="${myHistory}">
                                <table class="order-table1 table">
                                    <thead>
                                    <th><g:message code="study.name"/></th>
                                    <th style="width:5%"><g:message code="study.id"/></th>
                                    <th style="width:25%"><g:message code="study.description"/></th>
                                    <th><g:message code="study.pi"/></th>
                                    <th><g:message code="study.disease"/></th>
                                    <th><g:message code="study.subjectType"/></th>
                                    <th><g:message code="study.poc"/></th>
                                    </thead>
                                    <g:each in="${myHistory}" var="study">
                                        <tr>
                                            <td ><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
                                            <td style="vertical-align:top">${study.id}</td>
                                            <td style="vertical-align:top">${study.longName}</td>
                                            <td style="vertical-align:top">
                                                <g:each in="${study.pis}" var="pi">
                                                    ${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
                                                </g:each>
                                            </td>
                                            <td style="vertical-align:top">${study.disease}</td>
                                            <td style="vertical-align:top">${study.subjectType?.replace("_"," ")}</td>
                                            <td style="vertical-align:top">
                                                <g:each in="${study.pocs}" var="poc">
                                                    ${poc.firstName} ${poc.lastName}<br/><br/>
                                                </g:each>
                                            </td>
                                        </tr>
                                    </g:each>
                                </table>
                            </g:if>
                            <g:else>
                                &nbsp;&nbsp; &nbsp;You have no Studies History yet.
                            </g:else>

                        </div>
                    </div>
                <div class="tab-pane" id="otherstudies">
                    <div  class="" style="font-size: 12px;">
                        <div class="desc1">
                            Below are G-DOC private studies. You can request access to a private study through <g:link controller="collaborationGroups"><g:message code="nav.groups" /></g:link>.
                            <br/><br/><input type="search" class="light-table-filter" data-table="order-table2" placeholder="Filter" />
                        </div>
                        <table class="order-table2 table">
                            <thead>
                            <th><g:message code="study.name"/></th>
                            <th style="width:30%"><g:message code="study.description"/></th>
                            <th><g:message code="study.pi"/></th>
                            <th><g:message code="study.disease"/></th>
                            <th><g:message code="study.subjectType"/></th>
                            <th><g:message code="study.poc"/></th>
                            </thead>
                            <g:each in="${otherStudies}" var="study">
                                <tr>
                                    <td style="vertical-align:top"><g:link action="show" id="${study.id}">${study.shortName}</g:link></td>
                                    <td style="vertical-align:top">${study.longName}</td>
                                    <td style="vertical-align:top">
                                        <g:each in="${study.pis}" var="pi">
                                            ${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/><br/>
                                        </g:each>
                                    </td>
                                    <td style="vertical-align:top">${study.disease}</td>
                                    <td style="vertical-align:top">${study.subjectType?.replace("_"," ")}</td>
                                    <td style="vertical-align:top">
                                        <g:each in="${study.pocs}" var="poc">
                                            ${poc.firstName} ${poc.lastName}<br/><br/>
                                        </g:each>
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                    </div>
                </div>


                </div>

            </div>
        </div>


        <script type="text/javascript">
            jQuery(document).ready(function ($) {
                $('#tabs').tab();
            });
        </script>


	</body>
	
</hmtl>