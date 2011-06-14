<html>
<head>
	<meta name="layout" content="noHeaderLayout" />
	<title><g:message code="registration.title" args="${[appTitle()]}"/></title>
	<g:javascript>
	$(document).ready( function () {
				$('#userCat').change(function() {
					if($('#userCat').val() == 'Georgetown User') {
						$('#netIdReg').css('display','block');
						$('#publicReg').css('display','none');
					}else{
						$('#publicReg').css('display','block');
						$('#netIdReg').css('display','none');
					}
		 		});
	});
	</g:javascript>
</head>

<div id="userCatDiv" align="center" style="padding:10px">
<span style="font-size:13pt;"><g:message code="registration.category"/></span><br />
<g:select id="userCat" from="${categoryList}" noSelection="${['null': message(code:'registration.selectOne')]}" />
</div>

<g:if test="${flash.error}">
	<div class="errorDetail" style="width:85%;margin:0 auto;">${flash.error}</div>
</g:if>



<div class="clinicalSearch" id="netIdReg" style="width:85%;margin:0 auto;display:none">
	<g:if test="${flash.cmd instanceof RegistrationCommand}">
	<g:javascript>
		$('#netIdReg').css('display','block');
	</g:javascript>
	</g:if>
<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
    <legend style="padding:7px"><g:message code="registration.netId"/>:</legend>
	<div style="padding:10px">
		<g:form name="registrationForm" action="register">
		<g:if test="${flash.cmd instanceof RegistrationCommand}">
			<div class="errorDetail">
				<g:renderErrors bean="${flash.cmd?.errors}" />
			</div>
		</g:if>
		<g:message code="registration.validNetid"/>: <g:textField name="netId" /><br /><br />
		<g:message code="registration.password"/>: <g:passwordField name="password" id="passwordField" /><br /><br />
		<g:message code="registration.department"/>: 
		<g:select name="department"
		          from="${departmentList}" 
				noSelection="['':message(code: 'registration.chooseDepartment')]"/>
		<br /><br/>
		<g:submitButton name="register" value="${message(code: 'registration.register')}" />
		</g:form>
	</div>
</fieldset>
</div>

<div class="clinicalSearch" id="publicReg" style="width:85%;margin:0 auto;display:none">
	<g:if test="${flash.cmd instanceof RegistrationPublicCommand}">
	<g:javascript>
	$('#publicReg').css('display','block');
	</g:javascript>
	</g:if>
	<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
	    <legend style="padding:7px"><g:message code="registration.request" args="${[appTitle()]}"/>:</legend>
		<div style="padding:10px;float:left">
			<g:if test="${flash.cmd instanceof RegistrationPublicCommand}">
				<div class="errorDetail">
					<g:renderErrors bean="${flash.cmd?.errors}" />
				</div>
			</g:if>
			<g:form name="registrationPublicForm" action="registerPublic">
			<g:message code="registration.validEmail"/>: <g:textField name="userId" /><br /><br />

			<recaptcha:ifEnabled>
			    <recaptcha:recaptcha theme="blackglass"/>
			</recaptcha:ifEnabled>
			<br /><br/>
			<div class="c" style="border:1px solid silver;padding:10px;margin-right:10px;width:50%">
				*<g:message code="registration.note"/>:<span style="font-size:.85em"> <g:message code="registration.link"/></span><br />
			</div><br />
			<g:submitButton name="registerPublic" value="${message(code: 'registration.register')}" />
			</g:form>
		</div>
		
	</fieldset>
</div>
