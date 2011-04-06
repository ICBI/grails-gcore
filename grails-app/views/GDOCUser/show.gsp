

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Show User</title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">GDOCUser List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New GDOCUser</g:link></span-->
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Show User: ${fieldValue(bean:GDOCUserInstance, field:'username')}</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Username:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'username')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">First Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'firstName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Last Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastName')}</td>
                            
                        </tr>
                    
                        <%--tr class="prop">
                            <td valign="top" class="name">Password:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'password')}</td>
                            
                        </tr--%>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Email:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'email')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Organization:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'organization')}</td>
                            
                        </tr>

						<tr class="prop">
                            <td valign="top" class="name">Options:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="o" in="${GDOCUserInstance.options}">
                                    <li><g:link controller="userOption" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                   		<tr class="prop">
	                            <td valign="top" class="name">Department:</td>

	                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'department')}</td>

	                        </tr>
                    
						
						<tr class="prop">
                            <td valign="top" class="name">Lists:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">${userLists}
                                <%--ul>
                                <g:each var="l" in="${GDOCUserInstance.lists}">
                                    <li><g:link controller="userList" action="show" id="${l.id}">${l?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul--%>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Analysis:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">${userAnalyses}
                                <ul>
                                <%--g:each var="a" in="${GDOCUserInstance.analysis}">
                                    <li><g:link controller="savedAnalysis" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
                                </g:each--%>
                                </ul>
                            </td>
                            
                        </tr>

						<tr class="prop">
                            <td valign="top" class="name" colSpan="2">Memberships<br />
							
                            <table class="sumTable">
			                    <thead>
			                        <tr>
   										<g:sortableColumn property="collaborationGroup" title="Group" />

			                   	        <g:sortableColumn property="role" title="Role" />

			                        </tr>
			                    </thead>
			                    <tbody>
			                    <g:each in="${GDOCUserInstance.memberships}" status="i" var="membership">
			                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
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
						
						<tr class="prop">
                            <td valign="top" class="name">Requestor Invites:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="r" in="${GDOCUserInstance.requestorInvites}">
                                    <li>Requesting access to ${r?.group?.encodeAsHTML()} is ${r?.status?.encodeAsHTML()}</li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
						
						<tr class="prop">
	                            <td valign="top" class="name" colspan="2">Invitations<br />
									<table class="sumTable">
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

					                            <td><g:link action="show" id="${invitationInstance.id}">${fieldValue(bean:invitationInstance, field:'id')}</g:link></td>

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
	                            <%--td  valign="top" style="text-align:left;" class="value">
	                                <ul>
	                                <g:each var="i" in="${GDOCUserInstance.invitations}">
	                                    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
	                                </g:each>
	                                </ul>
	                            </td--%>

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
                            <td valign="top" class="name">Date Created:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'dateCreated')}</td>
                            
                        </tr>


						 <tr class="prop">
	                            <td valign="top" class="name">Last Login:</td>

	                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastLogin')}</td>

	                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Enabled:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'enabled')}</td>
                            
                        </tr>

						<tr class="prop">
                            <td valign="top" class="name">Account Expired:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'accountExpired')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Account Locked:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'accountLocked')}</td>
                            
                        </tr>
						
                    
                       
                    
                        <%--tr class="prop">
                            <td valign="top" class="name">Last Updated:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'lastUpdated')}</td>
                            
                        </tr--%>
                    
                        
                    
                        <tr class="prop">
                            <td valign="top" class="name">Password Expired:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:GDOCUserInstance, field:'passwordExpired')}</td>
                            
                        </tr>
                    
                        
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${GDOCUserInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
