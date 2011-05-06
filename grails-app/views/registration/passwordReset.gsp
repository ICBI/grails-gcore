<html>
<head>
	<meta name="layout" content="splash" />
	<title><g:message code="registration.reset" args="${[appTitle()]}"/></title>
	<g:javascript library="jquery" />
</head>


<div class="clinicalSearch" style="width:85%;margin:0 auto">
	
<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
</g:if>
<g:if test="${flash.error}">
		<div class="errorDetail">${flash.error}</div>
</g:if>

<g:if test="${netId}">
		<div class="errorDetail"><g:message code="registration.cannotChange"/></div>
</g:if>
	
<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
    <legend style="padding:7px"><g:message code="registration.passwordReset"/>:</legend>
	<div style="padding:10px;float:left">
		<g:form name="resetForm" action="resetLoginCredentials">
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}"/>
		</div>
		<g:if test="${session.userId}">
		<g:message code="registration.userId"/>: ${session.userId} <g:hiddenField name="userId" value="${session.userId}"/><br /><br />
		</g:if>
		<g:else>
		<g:message code="registration.enterUser"/>: <g:textField name="userId" value="${flash.cmd?.userId}" /><br /><br />
		</g:else>
		
		<recaptcha:ifEnabled>
		    <recaptcha:recaptcha theme="blackglass"/>
		</recaptcha:ifEnabled>
		<br /><br/>
		<g:submitButton name="requestReset" value="${message(code: 'registration.request')}" />
		</g:form>
	</div>
	<div class="c" style="float:right;border:1px solid silver;padding:10px;margin-right:10px">
		<span style="font-size:1.05em"><g:message code="registration.requirement"/>:</span><br />
		 * <g:message code="registration.req1"/><br />
		 * <g:message code="registration.req2"/><br />
		 * <g:message code="registration.req3"/><br />
		 * <g:message code="registration.req4"/>
	</div>
</fieldset>
</div>
