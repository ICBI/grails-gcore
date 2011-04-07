

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit User</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">User List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New User</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px">Edit User: ${fieldValue(bean:GDOCUserInstance, field:'username')}</p>
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
                    <table class="admin" style="width:75%">
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
                                    <input type="password" id="password" name="password" value="${fieldValue(bean:GDOCUserInstance,field:'password')}"/>
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
                                    <label for="title">Title:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'title','errors')}">
                                    <input type="text" id="title" name="title" value="${fieldValue(bean:GDOCUserInstance,field:'title')}"/>
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
                                    <label for="department">Department:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'department','errors')}">
                                    <input type="text" id="department" name="department" value="${fieldValue(bean:GDOCUserInstance,field:'department')}"/>
                                </td>
                            </tr> 

							
							<tr class="prop">
                                <td valign="top" class="name" colSpan="2">Memberships &nbsp; &nbsp;| &nbsp; &nbsp;
										<g:link controller="membership" params="['GDOCUser.username':GDOCUserInstance?.username]" action="create">Add Membership?</g:link><br />
                                    <table class="admin">
					                    <thead>
					                        <tr>
												<g:sortableColumn property="id" title="Id" />
		   										<g:sortableColumn property="collaborationGroup" title="Group" />

					                   	        <g:sortableColumn property="role" title="Role" />

					                        </tr>
					                    </thead>
					                    <tbody>
					                    <g:each in="${GDOCUserInstance.memberships}" status="i" var="membership">
					                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
												<td><g:link controller="membership" action="show" id="${membership.id}">${membership.id.encodeAsHTML()}</g:link></td>
												
												<td>${fieldValue(bean:membership, field:'collaborationGroup')}</td>

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
		                            <td valign="top" class="name" colspan="2">Invitations&nbsp; &nbsp;| &nbsp; &nbsp;
			
										<table class="admin">
						                    <thead>
						                        <tr>

						                   	        <g:sortableColumn property="id" title="Id" />

						                   	        <g:sortableColumn property="dateCreated" title="Date Created" />

						                   	        <th>Group</th>

						                   	        <th>Invitee</th>

						                   	        <g:sortableColumn property="lastUpdated" title="Last Updated" />

						                   	        <th>Requestor</th>

													<g:sortableColumn property="status" title="Status" />

						                        </tr>
						                    </thead>
						                    <tbody>
						                    <g:each in="${GDOCUserInstance.invitations}" status="i" var="invitationInstance">
						                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

						                            <td><g:link action="show" controller="invitation" id="${invitationInstance.id}">${fieldValue(bean:invitationInstance, field:'id')}</g:link></td>

						                            <td>${fieldValue(bean:invitationInstance, field:'dateCreated')}</td>

						                            <td>${fieldValue(bean:invitationInstance, field:'group')}</td>

						                            <td>${fieldValue(bean:invitationInstance, field:'invitee')}</td>

						                            <td>${fieldValue(bean:invitationInstance, field:'lastUpdated')}</td>

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
	                                    <label for="dateCreated">Date Created:</label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'dateCreated','errors')}">
	                                    <g:datePicker name="dateCreated" value="${GDOCUserInstance?.dateCreated}" precision="minute" ></g:datePicker>
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
                                    <label for="enabled">Enabled:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'enabled','errors')}">
                                    <g:checkBox name="enabled" value="${GDOCUserInstance?.enabled}" ></g:checkBox>
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
	                                    <label for="passwordExpired">Password Expired:</label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean:GDOCUserInstance,field:'passwordExpired','errors')}">
	                                    <g:checkBox name="passwordExpired" value="${GDOCUserInstance?.passwordExpired}" ></g:checkBox>
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
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
               		<span class="button"><g:link action="show" id="${GDOCUserInstance?.id}" class="cancel">Cancel</g:link></span>
 				</div>
            </g:form>
        </div>
    </body>
</html>
