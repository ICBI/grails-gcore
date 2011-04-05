

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit User</title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">GDOCUser List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New GDOCUser</g:link></span-->
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Edit User</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${GDOCUserInstance}">
            <div class="errors">
                <g:renderErrors bean="${GDOCUserInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${GDOCUserInstance?.id}" />
                <input type="hidden" name="version" value="${GDOCUserInstance?.version}" />
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
                                    <label for="analysis">Analysis:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'analysis','errors')}">
                                    
<ul>
<g:each var="a" in="${GDOCUserInstance?.analysis?}">
    <li><g:link controller="savedAnalysis" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="savedAnalysis" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add SavedAnalysis</g:link>

                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="comments">Comments:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'comments','errors')}">
                                    
<ul>
<g:each var="c" in="${GDOCUserInstance?.comments?}">
    <li><g:link controller="comments" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="comments" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add Comments</g:link>

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
                                    <label for="invitations">Invitations:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'invitations','errors')}">
                                    
<ul>
<g:each var="i" in="${GDOCUserInstance?.invitations?}">
    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="invitation" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add Invitation</g:link>

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
                                    <label for="lists">Lists:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lists','errors')}">
                                    
<ul>
<g:each var="l" in="${GDOCUserInstance?.lists?}">
    <li><g:link controller="userList" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="userList" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add UserList</g:link>

                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="memberships">Memberships:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'memberships','errors')}">
                                    
<ul>
<g:each var="m" in="${GDOCUserInstance?.memberships?}">
    <li><g:link controller="membership" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="membership" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add Membership</g:link>

                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="options">Options:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'options','errors')}">
                                    
<ul>
<g:each var="o" in="${GDOCUserInstance?.options?}">
    <li><g:link controller="userOption" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="userOption" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add UserOption</g:link>

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
                                    <label for="requestorInvites">Requestor Invites:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'requestorInvites','errors')}">
                                    
<ul>
<g:each var="r" in="${GDOCUserInstance?.requestorInvites?}">
    <li><g:link controller="invitation" action="show" id="${r.id}">${r?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="invitation" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create">Add Invitation</g:link>

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
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
