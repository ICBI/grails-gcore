

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
		<g:javascript library="jquery"/>
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
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="users.list" args="${ [appTitle()] }" /></g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="users.create" args="${ [appTitle()] }" /></p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${GDOCUserInstance}">
            <div class="errors">
                <g:renderErrors bean="${GDOCUserInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table class="admin">
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
                        
                            <%--tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastLogin">Last Login:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastLogin','errors')}">
                                    <g:datePicker name="lastLogin" value="${GDOCUserInstance?.lastLogin}" precision="minute" noSelection="['':'']"></g:datePicker>
                                </td>
                            </tr--%> 
                        
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
                                    <g:datePicker name="dateCreated" value="${GDOCUserInstance?.dateCreated}" precision="minute" ></g:datePicker>
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
                                    <g:datePicker name="lastUpdated" value="${GDOCUserInstance?.lastUpdated}" precision="minute" ></g:datePicker>
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
                        
                            <%--tr class="prop">
                                <td valign="top" class="name">
                                    <label for="groupNames">Group Names:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'groupNames','errors')}">
                                    
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="groups">Groups:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'groups','errors')}">
                                    
                                </td>
                            </tr--%> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="${message(code: 'gcore.create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
