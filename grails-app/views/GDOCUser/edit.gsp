

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="users.userAdminTitle" args="${ [appTitle()] }" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="users.list" args="${ [appTitle()] }" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="users.create" args="${ [appTitle()] }" /></g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="users.editUser" />: ${fieldValue(bean:GDOCUserInstance, field:'username')}</p>
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
                <div class="well">
                    <table class="admin" style="width:75%">
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
                                    <label for="options"><g:message code="users.options" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'options','errors')}">
                                    
<ul>
<g:each var="o" in="${GDOCUserInstance?.options?}">
    <li><g:link controller="userOption" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="userOption" params="['GDOCUser.id':GDOCUserInstance?.id]" action="create"><g:message code="users.addUserOption" /></g:link>

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

							
							<tr class="prop">
                                <td valign="top" class="name" colSpan="2"><g:message code="users.memberships" /> &nbsp; &nbsp;| &nbsp; &nbsp;
										<g:link controller="membership" params="['username':GDOCUserInstance?.username]" action="create"><g:message code="users.addMembership" /></g:link><br />
                                    	<table class="admin" width="100%">
						                    <thead>
						                        <tr>
													<%--g:sortableColumn property="id" title="Id" /--%>
			   										<th><g:message code="membership.group" /></th>
						                   	        <th><g:message code="membership.role" /></th>

						                        </tr>
						                    </thead>
						                    <tbody>
						                    <g:each in="${GDOCUserInstance.memberships.sort{it.collaborationGroup.name}}" status="i" var="membership">
						                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
													<td><g:link controller="membership" action="show" id="${membership.id}">${fieldValue(bean:membership, field:'collaborationGroup')}</g:link></td>

						                            <td>${fieldValue(bean:membership, field:'role')}</td>

						                        </tr>
						                    </g:each>
						                    </tbody>
						                </table>

                                </td>
                            </tr>

							<%--tr class="prop">
                                <td valign="top" class="name">
                                    <label for="requestorInvites">Requestor Invites:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'requestorInvites','errors')}">
                                    
<ul>
<g:each var="r" in="${GDOCUserInstance?.requestorInvites?}">
    <li><g:link controller="invitation" action="show" id="${r.id}">${r?.group?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>

                                </td>
                            </tr--%>

							<tr class="prop">
		                            <td valign="top" class="name" colspan="2"><g:message code="invitations.heading" />&nbsp; &nbsp;| &nbsp; &nbsp;
			
										<table class="admin" width="100%">
						                    <thead>
						                        <tr>

						                   	        <th><g:message code="invitations.id" /></th>

						                   	        <th><g:message code="invitations.dateCreated" /></th>

						                   	        <th><g:message code="invitations.group" /></th>

						                   	        <th><g:message code="invitations.invitee" /></th>

						                   	        <th><g:message code="invitations.lastUpdated" /></th>

						                   	        <th><g:message code="invitations.requestor" /></th>

													<th><g:message code="invitations.status" /></th>

						                        </tr>
						                    </thead>
						                    <tbody>
						                    <g:each in="${GDOCUserInstance.invitations.sort{it.dateCreated}.reverse()}" status="i" var="invitationInstance">
						                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

						                            <td><g:link action="show" controller="invitation" id="${invitationInstance.id}">${fieldValue(bean:invitationInstance, field:'id')}</g:link></td>

						                            <td><g:formatDate format="EEE MMM d, yyyy" date="${invitationInstance.dateCreated}" /></td>

						                            <td>${fieldValue(bean:invitationInstance, field:'group')}</td>

						                            <td>${fieldValue(bean:invitationInstance, field:'invitee')}</td>

						                            <td><g:formatDate format="EEE MMM d, yyyy" date="${invitationInstance.lastUpdated}" /></td>

						                            <td>${fieldValue(bean:invitationInstance, field:'requestor')}</td>

													<td>${fieldValue(bean:invitationInstance, field:'status')}</td>

						                        </tr>
						                    </g:each>
						                    </tbody>
						                </table>
		                            
                                </td>
                            </tr><br />
							
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
                                    <label for="lastLogin"><g:message code="users.lastLogin" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'lastLogin','errors')}">
                                    <g:datePicker name="lastLogin" value="${GDOCUserInstance?.lastLogin}" precision="minute" noSelection="['':'']"></g:datePicker>
                                </td>
                            </tr> 

							
                        
                           
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="enabled"><g:message code="users.enabled" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'enabled','errors')}">
                                    <g:checkBox name="enabled" value="${GDOCUserInstance?.enabled}" ></g:checkBox>
                                </td>
                            </tr>
                        
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
	                                    <label for="passwordExpired"><g:message code="users.passwordExpired" />:</label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'passwordExpired','errors')}">
	                                    <g:checkBox name="passwordExpired" value="${GDOCUserInstance?.passwordExpired}" ></g:checkBox>
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
                    <span class="button"><g:actionSubmit class="save btn btn-primary" value="${message(code: 'gcore.update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
               		<span class="button"><g:link action="show" id="${GDOCUserInstance?.id}" class="cancel"><g:message code="gcore.cancel" /></g:link></span>
 				</div>
            </g:form>
        </div>
    </body>
</html>
