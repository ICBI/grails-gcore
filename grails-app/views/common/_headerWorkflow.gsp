
<jq:plugin name="autocomplete"/>



<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
<a href="/${appName()}"><img src="/${appName()}/images/${appLogo()}" border="0" alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a>
</td><td valign="bottom" style="text-align:right;padding:7px">
<span style="color:white"><g:formatDate format="EEE MMM d, yyyy" date="${new Date()}"/></span><br />

<sec:ifLoggedIn>

<div style="float:right;color:#f2f2f2">
	<div><g:message code="header.loggedInAs"/>: ${session.userId}</div>
	<div>
		<g:if test="${session.isGdocAdmin}">
		<g:link style="color:#f2f2f2" controller="admin"><g:message code="header.admin"/></g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span>
		</g:if>
		<g:link controller="registration" action="passwordReset" style="color:#f2f2f2"><g:message code="header.changePassword"/></g:link>
		<span style="font-weight:bold;color:#fff;padding-left:5px;padding-right:5px">|</span>
		<g:link style="color:#f2f2f2" action="index" controller="logout" update="success"><g:message code="header.logout"/></g:link>
	</div>
</div>
</sec:ifLoggedIn>



</td>
</tr></table>

<div id="top-navigation-block" width="100%" style="position: absolute; z-index: 100;">
<div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="./index.html">G-DOC&nbsp;&reg;</a>
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
          </div>
        </div>
      </div>
    </div>
</div>