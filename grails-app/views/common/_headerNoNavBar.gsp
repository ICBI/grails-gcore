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