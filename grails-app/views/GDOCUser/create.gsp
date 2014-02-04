

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript>
			$(document).ready(function(){
				$("#username").blur(function() {
				  if($("#username").val() != ""){
					$("#email").val($("#username").val());
					return false;
				   }
				});
			});
		</g:javascript>  
        <title><g:message code="users.userAdminTitle" args="${ [appTitle()] }" /></title>         
    </head>
    <body>
    <div class="welcome-title"><g:message code="users.create" args="${ [appTitle()] }" /> </div> <br/>
    <g:if test="${flash.message}">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${flash.message}
        </div>
    </g:if>
    <div class="well" style="min-height: 350px;">
        <g:hasErrors bean="${GDOCUserInstance}">
            <div class="errors">
                <g:renderErrors bean="${GDOCUserInstance}" as="list" />
            </div>
        </g:hasErrors>
        <g:form action="save" method="post" >
        <div style="float: left; width: 45%;">

            <table class="admin" width="100%">
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="username"><g:message code="users.userName" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'username','errors')}">
                        <input type="text" id="username" name="username" value="${fieldValue(bean:GDOCUserInstance,field:'username')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="firstName"><g:message code="users.firstName" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'firstName','errors')}">
                        <input type="text" id="firstName" name="firstName" value="${fieldValue(bean:GDOCUserInstance,field:'firstName')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="lastName"><g:message code="users.lastName" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastName','errors')}">
                        <input type="text" id="lastName" name="lastName" value="${fieldValue(bean:GDOCUserInstance,field:'lastName')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="password"><g:message code="users.password" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'password','errors')}">
                        <input type="password" id="password" name="password" value="${fieldValue(bean:GDOCUserInstance,field:'password')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="email"><g:message code="users.email" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'email','errors')}">
                        <input type="text" id="email" name="email" value="${fieldValue(bean:GDOCUserInstance,field:'email')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="organization"><g:message code="users.organization" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'organization','errors')}">
                        <input type="text" id="organization" name="organization" value="${fieldValue(bean:GDOCUserInstance,field:'organization')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="title"><g:message code="users.title" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'title','errors')}">
                        <input type="text" id="title" name="title" value="${fieldValue(bean:GDOCUserInstance,field:'title')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="department"><g:message code="users.department" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'department','errors')}">
                        <input type="text" id="department" name="department" value="${fieldValue(bean:GDOCUserInstance,field:'department')}"/>
                    </td>
                </tr>


                </tbody>
            </table>

        </div>

        <div style="float: right; width: 55%;">
            <table class="admin" width="100%">
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="accountExpired"><g:message code="users.accountExpired" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'accountExpired','errors')}">
                        <g:checkBox name="accountExpired" value="${GDOCUserInstance?.accountExpired}" ></g:checkBox>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="accountLocked"><g:message code="users.accountLocked" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'accountLocked','errors')}">
                        <g:checkBox name="accountLocked" value="${GDOCUserInstance?.accountLocked}" ></g:checkBox>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="dateCreated"><g:message code="users.dateCreated" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'dateCreated','errors')}">
                        <g:datePicker style="width:40px;" name="dateCreated" value="${GDOCUserInstance?.dateCreated}" precision="minute" ></g:datePicker>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="enabled"><g:message code="users.enabled" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'enabled','errors')}">
                        <g:checkBox name="enabled" value="true" ></g:checkBox>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="lastUpdated"><g:message code="users.lastUpdated" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastUpdated','errors')}">
                        <g:datePicker style="width:40px;" name="lastUpdated" value="${GDOCUserInstance?.lastUpdated}" precision="minute" ></g:datePicker>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="passwordExpired"><g:message code="users.passwordExpired" />:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'passwordExpired','errors')}">
                        <g:checkBox name="passwordExpired" value="${GDOCUserInstance?.passwordExpired}" ></g:checkBox>
                    </td>
                </tr>
                </tbody>
            </table>
            <br/><br/>
            <div class="buttons">
                <span class="button"><input class="save btn btn-primary" type="submit" value="${message(code: 'gcore.create')}" /></span>
            </div>
        </div>





            </g:form>
        </div>
    </body>
</html>
