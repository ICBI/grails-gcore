<div id="top-navigation-block" width="100%" style="position: absolute; z-index: 100;">
<div class="navbar navbar-inverse navbar-fixed-top bs-docs-nav">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
            <a class="brand" href="/${appName()}"><img src="${createLinkTo(dir: 'images',  file: 'GDOC_Plus_Logo.png')}" border="0"  alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a>
          </br>
            <div class="nav-collapse collapse">
            <ul class="nav">
              <li>
				<g:navigationLink name="${message(code: 'nav.home', args: [appTitle()])}" controller="workflows"/>
              </li>

              <li class="dropdown">
              	<a href="#" class="dropdown-toggle" data-toggle="dropdown">My G-DOC Plus &reg; <b class="caret"></b></a>
              		<ul class="dropdown-menu">
                            <li><g:navigationLink name="My Studies" controller="studyDataSource">My Studies</g:navigationLink></li>
							<li><a href="${createLink(controller: 'notification')}"><g:message code="nav.notifications" /></a></li>
						    <li><a href="${createLink(controller: 'userList')}"><g:message code="nav.savedLists" /></a></li>
							<li><a href="${createLink(controller: 'savedAnalysis')}"><g:message code="nav.savedAnalyses" /></a></li>
							<li><g:link controller="collaborationGroups"><g:message code="nav.groups" /></g:link></li>
                            <li><a href="/${appName()}/workflows/choosePath">Help me pick a study</a></li>
					</ul>
              </li>
                <g:if test="${session.study}">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">${session.study.shortName}<b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <g:if test="${session.supportedOperations}">
                                <g:set var="operations" value="${session.supportedOperations.groupBy {it.type}}"></g:set>
                                <g:each in="${operations.keySet()}" var="type">
                                    <li class="nav-header">${type}</li>
                                    <g:each in="${operations[type]}" var="operation">
                                        <li><a href="${createLink(controller: operation.controller, action: operation.action)}">${operation.name}</a>
                                    </g:each>
                                    <li class="divider"></li>
                                </g:each>
                            </g:if>
                            <g:else>
                                <li>No study selected</li>
                            </g:else>
                        </ul>
                    </li>
                </g:if>
            </ul>


              <ul class="nav pull-right">

                  <li class="dropdown">
                      <a href="#" class="dropdown-toggle" data-toggle="dropdown"> ${session.userId} <b class="caret"></b></a>
                      <ul class="dropdown-menu">
                          <g:if test="${session.isGdocAdmin}">
                              <li> <g:link  controller="admin"><g:message code="header.admin"/></g:link></li>
                          </g:if>
                          <li><g:link controller="registration" action="passwordReset" ><g:message code="header.changePassword"/></g:link></li>
                          <li><g:link controller="help" action="index" ><g:message code="header.help"/></g:link></li>
                          <li class="divider"></li>
                          <li><g:link action="index" controller="logout" update="success"><g:message code="header.logout"/></g:link></li>
                      </ul>
                  </li>
              </ul>




                <ul class="nav pull-right">
                    <li>
                        <jq:plugin name="ui"/>
                        <jq:plugin name="autocomplete"/>
                        <jq:plugin name="tooltip"/>
                        <g:javascript>
                                $(document).ready(function(){
                                $('.info').tooltip({showURL: false});
                                $("#q").autocomplete("/${appName()}/search/relevantTerms",{
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
                        <g:form autocomplete="off" controller="search" action="index" style="margin-bottom: 0px; margin-right: 50px;">

                            <input name="q" id="q" type="text" value="" style="width:180px;" ></input>

                            <button class="btn btn-default"  style="vertical-align: top;margin-top: 0px;" type="submit"  value="search gdoc"><img src="${createLinkTo(dir: 'images',  file: 'search.png')}" alt="Search">
                            </button>


                        </g:form>
                    </li>
                </ul>


          </div>
        </div>
      </div>
    </div>
</div>
</br>


