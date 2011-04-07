

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Show CollaborationGroup</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">CollaborationGroup List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New CollaborationGroup</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px">Show CollaborationGroup</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table class="admin">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'name')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Artifacts:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="a" in="${collaborationGroupInstance.artifacts}">
                                    <li><g:link controller="protectedArtifact" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Description:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'description')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Invitations:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="i" in="${collaborationGroupInstance.invitations}">
                                    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name" colspan="2">Memberships:<br />
                            
								<table class="admin">
				                    <thead>
				                        <tr>
											<th>Id</th>
	   										<th>User</th>
											<th>Role</th>

				                        </tr>
				                    </thead>
				                    <tbody>
				                    <g:each in="${collaborationGroupInstance.memberships}" status="i" var="membership">
				                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
											<td><g:link controller="membership" action="show" id="${membership.id}">${membership.id.encodeAsHTML()}</g:link></td>
											
											<td>${fieldValue(bean:membership, field:'user')}</td>

				                            <td>${fieldValue(bean:membership, field:'role')}</td>

				                        </tr>
				                    </g:each>
				                    </tbody>
				                </table>
							</td>
                            <%--td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="m" in="${collaborationGroupInstance.memberships}">
                                    <li><g:link controller="membership" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td--%>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Users:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'users')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${collaborationGroupInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
