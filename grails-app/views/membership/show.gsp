

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="membership.title" /></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="list" action="list"><g:message code="membership.list" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="membership.create" /></g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px"><g:message code="membership.show" args="${ [fieldValue(bean:membershipInstance, field:'id')] }" /></p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table class="admin">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="membership.id" />:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:membershipInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="membership.collab" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="collaborationGroup" action="show" id="${membershipInstance?.collaborationGroup?.id}">${membershipInstance?.collaborationGroup?.name?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="membership.role" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="role" action="show" id="${membershipInstance?.role?.id}">${membershipInstance?.role?.name?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="membership.user" />:</td>
                            
                            <td valign="top" class="value"><g:link controller="GDOCUser" action="show" id="${membershipInstance?.user?.id}">${membershipInstance?.user?.username?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${membershipInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="${message(code: 'gcore.edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
