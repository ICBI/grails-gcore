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
                });

            })(document);

        </script>
    <style>
    .order-table tr:nth-child(even)		{ background-color:#F8F8F8; }
    .order-table tr:nth-child(odd)		{ background-color:#fff; }
    </style>

    </head>
    <body>

    <div class="welcome-title"><g:message code="study.title"/></div>

        <div class="features" >
            <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                <li class="active"><a href="#mystudies" data-toggle="tab">My GDOC studies</a></li>
                <li><a href="#myhistory" data-toggle="tab">My studies history</a></li>
                <li><a href="#otherstudies" data-toggle="tab">Other GDOC studies</a></li>
            </ul>
            <div id="my-tab-content" class="tab-content">
                <div class="tab-pane active" id="mystudies">
                    <div  class="" style="font-size: 12px;">
                        <div class="desc1">
                            Below is an overview of all the studies in G-DOC that you have access to. You can explore each study, view the details and use the available tools to analyse and search the data. Use the filter below to filter the table.
                            <br/><br/><input type="search" class="light-table-filter" data-table="order-table" placeholder="Filtrer" />
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
                                <br/><br/><input type="search" class="light-table-filter" data-table="order-table" placeholder="Filtrer" />
                            </div>

                            <table class="order-table table">
                                <thead>
                                <th><g:message code="study.name"/></th>
                                <th style="width:5%"><g:message code="study.id"/></th>
                                <th style="width:25%"><g:message code="study.description"/></th>
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
                <div class="tab-pane" id="otherstudies">
                    <div  class="" style="font-size: 12px;">
                        <div class="desc1">
                            Below are the G-DOC private studies.
                            <br/><br/><input type="search" class="light-table-filter" data-table="order-table" placeholder="Filtrer" />
                        </div>
                        <table class="order-table table">
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