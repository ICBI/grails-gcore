

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
            <p style="font-size:14pt;padding:15px"><g:message code="users.showUser" />: ${fieldValue(bean:GDOCUserInstance, field:'username')}</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="well">
                <table class="admin" style="width:100%">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.id" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.userName" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'username')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.firstName" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'firstName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.lastName" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastName')}</td>
                            
                        </tr>
                    
                        <%--tr class="prop">
                            <td valign="top" class="name">Password:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'password')}</td>
                            
                        </tr--%>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.email" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'email')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.organization" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'organization')}</td>
                            
                        </tr>
						
						<tr class="prop">
                            <td valign="top" class="name"><g:message code="users.title" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'title')}</td>
                            
                        </tr>

						<tr class="prop">
                            <td valign="top" class="name"><g:message code="users.options" />:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="o" in="${GDOCUserInstance.options}">
                                    <li><g:link controller="userOption" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                   		<tr class="prop">
	                            <td valign="top" class="name"><g:message code="users.department" />:</td>

	                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'department')}</td>

	                        </tr>
                    
						
						<tr class="prop">
                            <td valign="top" class="name"><g:message code="users.lists" />:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">${userLists}
                                <%--ul>
                                <g:each var="l" in="${GDOCUserInstance.lists}">
                                    <li><g:link controller="userList" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul--%>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="users.analyses" />:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">${userAnalyses}
                                <ul>
                                <%--g:each var="a" in="${GDOCUserInstance.analysis}">
                                    <li><g:link controller="savedAnalysis" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
                                </g:each--%>
                                </ul>
                            </td>
                            
                        </tr>
                    </tr>




                    <%--tr class="prop">
                        <td valign="top" class="name">Group Names:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'groupNames')}</td>

                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">Groups:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'groups')}</td>

                    </tr--%>



                    <%--tr class="prop">
                        <td valign="top" class="name">Comments:</td>

                        <td  valign="top" style="text-align:left;" class="value">
                            <ul>
                            <g:each var="c" in="${GDOCUserInstance.comments}">
                                <li><g:link controller="comments" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
                            </g:each>
                            </ul>
                        </td>

                    </tr--%>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.dateCreated" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'dateCreated')}</td>

                    </tr>


                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.lastLogin" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastLogin')}</td>

                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.enabled" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'enabled')}</td>

                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.accountExpired" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'accountExpired')}</td>

                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.accountLocked" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'accountLocked')}</td>

                    </tr>




                    <%--tr class="prop">
                        <td valign="top" class="name">Last Updated:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastUpdated')}</td>

                    </tr--%>



                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="users.passwordExpired" />:</td>

                        <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'passwordExpired')}</td>

                    </tr>

                    <tr class="prop">
                            <td valign="top" class="name" colSpan="2"><g:message code="users.memberships" /><br />
							
                           		<table class="admin" style="width:100%">
				                    <thead>
				                        <tr>
											<g:sortableColumn property="id" title="${message(code: 'membership.id')}" />
	   										<th><g:message code="membership.group" /></th>
				                   	        <th><g:message code="membership.role" /></th>

				                        </tr>
				                    </thead>
				                    <tbody>
				                    <g:each in="${GDOCUserInstance.memberships.sort{it.collaborationGroup.name}}" status="i" var="membership">
				                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
											<td><g:link controller="membership" action="show" id="${membership.id}">${fieldValue(bean:membership, field:'id')}</g:link></td>
											
											<td>${fieldValue(bean:membership, field:'collaborationGroup')}</td>
											
				                            <td>${fieldValue(bean:membership, field:'role')}</td>

				                        </tr>
				                    </g:each>
				                    </tbody>
				                </table>
							</td>
                            <!--td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="m" in="${GDOCUserInstance.memberships}">
                                    <li><g:link controller="membership" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td-->
                            
                        </tr>
						
						<%--tr class="prop">
                            <td valign="top" class="name">Requestor Invites:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="r" in="${GDOCUserInstance.requestorInvites}">
                                    <li>Requesting access to ${r?.group?.encodeAsHTML()} is ${r?.status?.encodeAsHTML()}</li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr--%>
						
							<tr class="prop">
		                            <td valign="top" class="name" colspan="2"><g:message code="invitations.heading" />&nbsp; &nbsp;| &nbsp; &nbsp;
			
										<table class="admin" style="width:100%">
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
						
	                            <%--td  valign="top" style="text-align:left;" class="value">
	                                <ul>
	                                <g:each var="i" in="${GDOCUserInstance.invitations}">
	                                    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
	                                </g:each>
	                                </ul>
	                            </td--%>


                        
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${GDOCUserInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit btn btn-default" value="${message(code: 'gcore.edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
