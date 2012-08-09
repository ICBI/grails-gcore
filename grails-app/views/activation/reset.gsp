<html>
<head>
	<meta name="layout" content="splash" />
	<title><g:message code="activation.reset" /></title>
	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="password"/>
</head>
<g:javascript>
$(document).ready(function() {
	$('#passwordField').pstrength();
});	
</g:javascript>

<div class="clinicalSearch" style="width:85%;margin:0 auto">

<div style="width:55%;">	
<g:if test="${flash.message}">
		<div class="message">${flash.message}</div>
</g:if>
<div class="errorDetail"><g:renderErrors bean="${flash.cmd?.errors}"/></div>
</div>
	
<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
    <legend style="padding:7px"><g:message code="activation.resetHeading" />:</legend>
	<div style="padding:10px;float:left">
		<g:form name="resetPasswordForm" action="resetPassword">
		
		<g:message code="activation.userid" />: ${userId}
		<g:hiddenField name="userId" value="${userId}"/><br /><br />
		<g:message code="activation.enterPassword" />: <g:passwordField name="password" id="passwordField" /><br /><br />
		
		<br /><br/>
		<g:submitButton name="resetPassword" value="${message(code: 'activation.resetPassword')}" />
		</g:form>
	</div>
	<div class="c" style="float:right;border:1px solid silver;padding:10px;margin-right:10px">
		<span style="font-size:1.05em"><g:message code="activation.requirements.heading" />:</span><br />
		 * <g:message code="activation.requirements.chars" />.<br />
		 * <g:message code="activation.requirements.number" />.<br />
		 * <g:message code="activation.requirements.letter" />.<br />
		 * <g:message code="activation.requirements.symbol" />.
	</div>
</fieldset>
</div>
