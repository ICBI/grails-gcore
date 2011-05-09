

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="invitations.heading" /></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="list" action="list"><g:message code="invitations.list" /></g:link></span>
            <!--span class="menuButton"><g:link class="create" action="create">New Invitation</g:link></span-->
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="invitations.show" args="${ [fieldValue(bean:invitationInstance, field:'id')] }" /></p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table class="admin">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.id" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:invitationInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.dateCreated" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:invitationInstance, field:'dateCreated')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.group" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="collaborationGroup" action="show" id="${invitationInstance?.group?.id}">${invitationInstance?.group?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.invitee" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="GDOCUser" action="show" id="${invitationInstance?.invitee?.id}">${invitationInstance?.invitee?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.lastUpdated" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:invitationInstance, field:'lastUpdated')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.requestor" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="GDOCUser" action="show" id="${invitationInstance?.requestor?.id}">${invitationInstance?.requestor?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="invitations.status" />:</td>
                            
                            <td valign="top" class="value">${invitationInstance?.status?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${invitationInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="${message(code: 'gcore.edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
