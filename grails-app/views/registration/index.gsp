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
<g:select id="userCat" name="userCat" from="${categoryList}" noSelection="${['null': message(code:'registration.selectOne')]}" />
</div>

<g:if test="${flash.error}">
	<div class="errorDetail" style="width:85%;margin:0 auto;">${flash.error.encodeAsHTML()}</div>
</g:if>


<div class="clinicalSearch" id="netIdReg" style=" -moz-border-radius: 10px; border-radius: 10px;width:85%;margin:0 auto;display:none">
	<g:if test="${flash.cmd instanceof RegistrationCommand}">
	<g:javascript>
		$('#netIdReg').css('display','block');
	</g:javascript>
	</g:if>
	<div style="padding:10px;font-family: 'Open Sans',sans-serif;font-size: 20px;font-weight: 300;color: rgb(0, 92, 167);line-height: 1.05;margin: 0px;"><g:message code="registration.netId"/></div>
    <fieldset style="background-color:#fff;-moz-border-radius: 5px; border-radius: 5px;">
        <div style="padding:10px">
            <g:form name="registrationForm" action="register">
            <g:if test="${flash.cmd instanceof RegistrationCommand}">
                <div class="errorDetail">
                    <g:renderErrors bean="${flash.cmd?.errors}" />
                </div>
            </g:if>
            <g:message code="registration.validNetid"/> <g:textField name="netId" /><br /><br />
            <g:message code="registration.password"/> <g:passwordField name="password" id="passwordField" /><br /><br />
            <g:message code="registration.department"/>
            <g:select name="department"
                      from="${departmentList}"
                    noSelection="['':message(code: 'registration.chooseDepartment')]"/>
            <br /><br/>
            <g:submitButton class="btn btn-primary" name="register" value="${message(code: 'registration.register')}" />
            </g:form>
        </div>

    </fieldset>


</div>

<div class="clinicalSearch" id="publicReg" style=" -moz-border-radius: 10px; border-radius: 10px;width:85%;margin:0 auto;display:none">
	<g:if test="${flash.cmd instanceof RegistrationPublicCommand}">
	<g:javascript>
	$('#publicReg').css('display','block');
	</g:javascript>
	</g:if>
	<div style="padding:10px;font-family: 'Open Sans',sans-serif;font-size: 20px;font-weight: 300;color: rgb(0, 92, 167);line-height: 1.05;margin: 0px;"><g:message code="registration.register" args="${[appTitle()]}"/></div>
	  <fieldset style="background-color:#fff;-moz-border-radius: 5px; border-radius: 5px;">
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
			<div class="alert alert-info"><strong>*<g:message code="registration.note"/>:</strong> <g:message code="registration.link"/></div>

			<g:submitButton class="btn btn-primary" name="registerPublic" value="${message(code: 'registration.register')}" />
			</g:form>
		</div>
		
	</fieldset>
</div>