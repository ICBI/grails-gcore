<html>
<head>
	<meta name="layout" content="noHeaderLayout" />
	<title><g:message code="registration.reset" args="${[appTitle()]}"/></title>
	<g:javascript library="jquery"  plugin="jquery"/>
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
<div style="padding:10px;font-family: 'Open Sans',sans-serif;font-size: 20px;font-weight: 300;color: rgb(0, 92, 167);line-height: 1.05;margin: 0px;"><g:message code="registration.passwordReset"/></div>
<fieldset style="background-color:#fff;-moz-border-radius: 5px; border-radius: 5px;">

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
		<g:submitButton class="btn btn-primary" name="requestReset" value="${message(code: 'registration.request')}" />
		</g:form>
	</div>
	<div class="alert alert-info" style="float:right;border:1px solid silver;padding:10px;margin-right:10px;margin-top:10px;">
		<span style="font-size:1.05em"><g:message code="registration.requirement"/>:</span><br />
		 * <g:message code="registration.req1"/><br />
		 * <g:message code="registration.req2"/><br />
		 * <g:message code="registration.req3"/><br />
		 * <g:message code="registration.req4"/>
	</div>
</fieldset>
</div>
</html>