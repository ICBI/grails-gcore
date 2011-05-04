<html>
<head>
	<meta name="layout" content="splash" />
	<title><g:message code="activation.pageTitle" args="${ [appTitle()] }" /></title>
	<g:javascript library="jquery" />
	<jq:plugin name="password"/>
</head>
<g:javascript>
$(document).ready(function() {
	$('#passwordField').pstrength();
	$('#activateAccountForm').submit(function() {
	      if ($("#consent:checked").val() !== undefined) {
	        return true;
	      }
	      $("#consentSpan").text("Please agree to Legal Term of Use").show().fadeOut(5000);
	      return false;
	 });
	<%--$("#agreement").hide();
	  //toggle the componenet with class msg_body
	  $("#showAg").click(function()
	  {
	    $("#agreement").slideToggle(500);
		return false;
	  });--%>
});	

</g:javascript>

<div class="clinicalSearch" style="width:85%;margin:0 auto">

<fieldset style="background-color:#fff;border:1px solid #334477;margin:10px 5px 5px 5px">
    <legend style="padding:7px"><g:message code="activation.heading" />:</legend>
	<div class="c" style="border:1px solid silver;padding:10px;margin-right:10px;font-size:.8em">
		<span style="font-size:1.05em"><g:message code="activation.requirements.heading" />:</span><br />
		 * <g:message code="activation.requirements.chars" />.<br />
		 * <g:message code="activation.requirements.number" />.<br />
		 * <g:message code="activation.requirements.letter" />.<br />
		 * <g:message code="activation.requirements.symbol" />.
	</div>
	<div style="padding:10px;">
		
		<div style="padding-left:25px">
		<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
		</g:if>
		<div class="errorDetail">
			<g:renderErrors bean="${flash.cmd?.errors}"/>
		</div>
		<br />
		</div>

		<g:form name="activateAccountForm" id="activateAccountForm" action="activateAccount">
		<span style="font-weight:bold"><g:message code="activation.userid" /></span>: ${userId}
		<g:hiddenField name="userId" value="${userId}"/><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.firstName" />:</span> <g:textField name="firstName" id="firstNameField" value="${flash.cmd?.firstName}"/><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.lastName" />:</span> <g:textField name="lastName" id="lastNameField" 
value="${flash.cmd?.lastName}"/><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.title" />:</span> <g:textField name="title" id="titleField" value="${flash.cmd?.title}"/><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.organization" />:</span> <g:textField name="organization" id="organizationField" value="${flash.cmd?.organization}" /><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.accessReason" args="${ [appTitle()] }" /></span><br/><g:textArea name="reason" id="reasonField" rows="10" cols="50" value="${flash.cmd?.reason}"/><br /><br />
		
		<span style="font-weight:bold">*<g:message code="activation.enterPassword" />:</span> <g:passwordField name="password" id="passwordField" /><br /><br />
		<span style="font-weight:bold">*<g:message code="activation.confirmPassword" />:</span> <g:passwordField name="passwordConfirm" id="passwordConfirm" /><br /><br />
		
		
		<br />
		<div style="font-style:italic;"><span style="font-weight:bold">*</span> <g:message code="activation.required" /></div>
		<br/>
		
		<div id="agreement" style="display:block;width:85%;border:1px solid black;height: 200px;overflow: auto;">
			<g:render template="/activation/useAgreement"/>
			
		</div>
		<span id="consentSpan" style="color:red;"></span><br />
		<g:checkBox name="consent" id="consent" class="consent" value="${false}" />&nbsp;&nbsp;&nbsp;<g:message code="activation.consent" /><br />
		<br />
		<g:submitButton name="activateAccount" value="${message(code: 'activation.heading')}" />
		</g:form>
		
		
		
	</div>
	
</fieldset>
</div>
