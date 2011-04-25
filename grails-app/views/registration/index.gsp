<html>
<head>
	<meta name="layout" content="splash" />
	<title>G-DOC Registration</title>
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
<span style="font-size:13pt;">Select your user category</span><br />
<g:select id="userCat" from="${categoryList}" noSelection="${['null':'Select One...']}" />
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
    <legend style="padding:7px">Georgetown NET ID required:</legend>
	<div style="padding:10px">
		<g:form name="registrationForm" action="register">
		<g:if test="${flash.cmd instanceof RegistrationCommand}">
			<div class="errorDetail">
				<g:renderErrors bean="${flash.cmd?.errors}" />
			</div>
		</g:if>
		Enter a valid Georgetown Net-Id: <g:textField name="netId" /><br /><br />
		Enter password: <g:passwordField name="password" id="passwordField" /><br /><br />
		Select a department (optional): 
		<g:select name="department"
		          from="${departmentList}" 
				noSelection="['':'-Choose department-']"/>
		<br /><br/>
		<g:submitButton name="register" value="Register" />
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
	    <legend style="padding:7px">Request access to G-DOC:</legend>
		<div style="padding:10px;float:left">
			<g:if test="${flash.cmd instanceof RegistrationPublicCommand}">
				<div class="errorDetail">
					<g:renderErrors bean="${flash.cmd?.errors}" />
				</div>
			</g:if>
			<g:form name="registrationPublicForm" action="registerPublic">
			Enter a valid email address (userId): <g:textField name="userId" /><br /><br />

			<recaptcha:ifEnabled>
			    <recaptcha:recaptcha theme="blackglass"/>
			</recaptcha:ifEnabled>
			<br /><br/>
			<div class="c" style="border:1px solid silver;padding:10px;margin-right:10px;width:50%">
				*NOTE:<span style="font-size:.85em">A registration link will be sent your email address after submission
				 If you do not receive a registration email in a timely manner,
				 check your 'spam' box and verify your filter does not block future email from gdoc-help@georgetown.edu</span><br />
			</div><br />
			<g:submitButton name="registerPublic" value="Register" />
			</g:form>
		</div>
		
	</fieldset>
</div>