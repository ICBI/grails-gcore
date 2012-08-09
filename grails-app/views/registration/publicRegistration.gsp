<html>
<head>
	<meta name="layout" content="noHeaderLayout" />
	<title><g:message code="registration.public" args="${[appTitle()]}"/></title>
	<g:javascript library="jquery" plugin="jquery" />
</head>

<div class="clinicalSearch" style="width:85%;margin:0 auto">
	
<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
</g:if>
<g:if test="${flash.error}">
		<div class="errorDetail">${flash.error}</div>
</g:if>
	
<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
    <legend style="padding:7px"><g:message code="registration.request" args="${[appTitle()]}"/>:</legend>
	<div style="padding:10px;float:left">
		<g:form name="registrationPublicForm" action="registerPublic">
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}"/>
		</div>
		<g:message code="registration.validEmail"/>: <g:textField name="userId" value="${flash.cmd?.userId}" /><br /><br />
		
		<recaptcha:ifEnabled>
		    <recaptcha:recaptcha theme="blackglass"/>
		</recaptcha:ifEnabled>
		<br /><br/>
		<g:submitButton name="registerPublic" value="Register" />
		</g:form>
	</div>
	<div class="c" style="float:right;border:1px solid silver;padding:10px;margin-right:10px">
		<span style="font-size:1.05em"><g:message code="registration.link"/></span><br />
	</div>
</fieldset>
</div>
