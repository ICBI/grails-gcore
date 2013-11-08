<g:javascript library="jquery" plugin="jquery"/>
<g:javascript src="jquery/jquery.autocomplete.js" plugin="gcore"/>
<g:javascript src="jquery/jquery.tooltip.js" plugin="gcore"/>

<g:javascript>



  jQuery(document).ready(function(){
   	jQuery("#q").autocomplete("/${appName()}/search/relevantTerms",{
			max: 130,
			scroll: true,
			multiple:false,
			matchContains: true,
			dataType:'json',
			parse: function(data){
				var array = jQuery.makeArray(data);
				for(var i=0;i < data.length;i++) {
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
	
	if(jQuery('#username')) {
		jQuery("#username").click(function(){
			$(this).val("");
			$(this).css("color","black");
		})
	}
	
	
  });


</g:javascript>


<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td style="width: 70%"><a href="/${appName()}"><img src="/${appName()}/images/${appLogo()}" border="0" alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a></td>
		<td valign="bottom" style="text-align:right;padding:7px"><span style="color:#f2f2f2"><g:formatDate format="EEE MMM d, yyyy" date="${new Date()}"/></span><br />

<sec:ifNotLoggedIn>

<g:if test='${flash.loginError}'>
<div class='login_message' style="color:#f2f2f2">${flash.loginError}</div>
</g:if>

<form action='${postUrl}' method='POST' id='loginForm' class='cssform'>
<input type='text' name='j_username' id='username'style="color:gray" size="20" onclick="clear()" value="${message(code: 'header.userName')}" />
<input type='password' name='j_password' id='password' size="15" />
<g:hiddenField name="desiredPage" value="${params.url}" />
<input type='submit' value="${message(code: 'header.login')}" />
</form>

<span style="color:#f2f2f2;padding-top:8px;font-size:.9em">
	<g:link controller="registration" style="color:#f2f2f2"><g:message code="header.registerNow"/></g:link>&nbsp;|&nbsp;
	<g:link controller="registration" action="passwordReset" style="color:#f2f2f2"><g:message code="header.forgotPassword" /></g:link>
</span>
</sec:ifNotLoggedIn>
<sec:ifLoggedIn>
<div >

	
</div>
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
          <a class="brand" href="http://lombardi.georgetown.edu/gdoc/" target="_blank">G-DOC&nbsp;&reg;</a>
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
              		<g:if test="${session.study}">
              			<li class="nav-header">${session.study.shortName}
              			<g:set var="longName" value="${session.study.longName}" />
              			(${longName.substring(0, 20)} &nbsp;.....&nbsp;${longName.substring(longName.size() - 20)})
              			</li>
              		</g:if>
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
      </div> <!-- container -->
    </div> <!-- navbar-inner -->
</div>