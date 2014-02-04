

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="collaborationGroup.title" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="collaborationGroup.list" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="collaborationGroup.create" /></g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="collaborationGroup.label" />: ${fieldValue(bean:collaborationGroupInstance, field:'name')}</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="well">
                <table class="admin" width="100%">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.id" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.name" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'name')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.artifacts" />:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <div style="height:250px;overflow:auto;background:#f2f2f2;border:1px solid black;padding:3px">
								<ul>
                                <g:each var="a" in="${collaborationGroupInstance.artifacts}">
                                    <li><g:link controller="protectedArtifact" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
								</div>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.description" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'description')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.invitations" />:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="i" in="${collaborationGroupInstance.invitations}">
                                    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collaborationGroup.memberships" />:</td>
							
							<td  valign="top" style="text-align:left;" class="value">
                            	<div style="height:250px;overflow:auto;background:#f2f2f2;border:1px solid black;padding:3px">
								<table class="admin" width="100%">
				                    <thead>
				                        <tr>
											<th><g:message code="membership.id" /></th>
	   										<th><g:message code="membership.user" /></th>
											<th><g:message code="membership.role" /></th>

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
								</div>
							</td>
                            <%--td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="m" in="${collaborationGroupInstance.memberships}">
                                    <li><g:link controller="membership" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td--%>
                            
                        </tr>
                    
                        <%--tr class="prop">
                            <td valign="top" class="name">Users:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:collaborationGroupInstance, field:'users')}</td>
                            
                        </tr--%>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${collaborationGroupInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit btn btn-default" value="${message(code: 'gcore.edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
