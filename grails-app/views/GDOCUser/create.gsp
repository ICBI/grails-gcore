

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Create User</title>         
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">GDOCUser List</g:link></span-->
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Create User</p>
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
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="username">Username:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'username','errors')}">
                                    <input type="text" id="username" name="username" value="${fieldValue(bean:GDOCUserInstance,field:'username')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstName">First Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'firstName','errors')}">
                                    <input type="text" id="firstName" name="firstName" value="${fieldValue(bean:GDOCUserInstance,field:'firstName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastName">Last Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastName','errors')}">
                                    <input type="text" id="lastName" name="lastName" value="${fieldValue(bean:GDOCUserInstance,field:'lastName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">Password:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'password','errors')}">
                                    <input type="text" id="password" name="password" value="${fieldValue(bean:GDOCUserInstance,field:'password')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="email">Email:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'email','errors')}">
                                    <input type="text" id="email" name="email" value="${fieldValue(bean:GDOCUserInstance,field:'email')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="organization">Organization:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'organization','errors')}">
                                    <input type="text" id="organization" name="organization" value="${fieldValue(bean:GDOCUserInstance,field:'organization')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="department">Department:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'department','errors')}">
                                    <input type="text" id="department" name="department" value="${fieldValue(bean:GDOCUserInstance,field:'department')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastLogin">Last Login:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastLogin','errors')}">
                                    <g:datePicker name="lastLogin" value="${GDOCUserInstance?.lastLogin}" precision="minute" noSelection="['':'']"></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="accountExpired">Account Expired:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'accountExpired','errors')}">
                                    <g:checkBox name="accountExpired" value="${GDOCUserInstance?.accountExpired}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="accountLocked">Account Locked:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'accountLocked','errors')}">
                                    <g:checkBox name="accountLocked" value="${GDOCUserInstance?.accountLocked}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreated">Date Created:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'dateCreated','errors')}">
                                    <g:datePicker name="dateCreated" value="${GDOCUserInstance?.dateCreated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="enabled">Enabled:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'enabled','errors')}">
                                    <g:checkBox name="enabled" value="${GDOCUserInstance?.enabled}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastUpdated">Last Updated:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastUpdated','errors')}">
                                    <g:datePicker name="lastUpdated" value="${GDOCUserInstance?.lastUpdated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="passwordExpired">Password Expired:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'passwordExpired','errors')}">
                                    <g:checkBox name="passwordExpired" value="${GDOCUserInstance?.passwordExpired}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
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
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
