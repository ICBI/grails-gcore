<div id="top-navigation-block" width="100%" style="position: absolute; z-index: 100;">
<div class="navbar navbar-inverse navbar-fixed-top bs-docs-nav">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
            <a class="brand" href="/${appName()}"><img src="/${appName()}/images/GDOC_Plus_Logo.png" border="0"  alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a>
          </br>
            <div class="nav-collapse collapse">
            <ul class="nav">
              <li>
				<g:navigationLink name="${message(code: 'nav.home', args: [appTitle()])}" controller="workflows"/>
              </li>
              <li>
                <g:navigationLink name="${message(code: 'nav.studies', args: [appTitle()])}" controller="studyDataSource">${message(code: 'nav.studies', args: [appTitle()])}</g:navigationLink>
              </li>

              <li class="dropdown">
              	<a href="#" class="dropdown-toggle" data-toggle="dropdown">My Study Options<b class="caret"></b></a>
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

              <li class="dropdown">
              	<a href="#" class="dropdown-toggle" data-toggle="dropdown">My G-DOC &reg; <b class="caret"></b></a>
              		<ul class="dropdown-menu">
							<li><a href="${createLink(controller: 'notification')}"><g:message code="nav.notifications" /></a>
							<li><a href="${createLink(controller: 'userList')}"><g:message code="nav.savedLists" /></a>
							<li><a href="${createLink(controller: 'savedAnalysis')}"><g:message code="nav.savedAnalyses" /></a>
							<li><g:link controller="collaborationGroups"><g:message code="nav.groups" /></g:link>
					</ul>
              </li>


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
          </div>
        </div>
      </div>
    </div>
</div>
</br>


