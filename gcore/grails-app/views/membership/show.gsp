

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Show Membership</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="list" action="list">Membership List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Membership</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">Show Membership</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table class="admin">
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:membershipInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Collaboration Group:</td>
                            
                            <td valign="top" class="value"><g:link controller="collaborationGroup" action="show" id="${membershipInstance?.collaborationGroup?.id}">${membershipInstance?.collaborationGroup?.name?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Role:</td>
                            
                            <td valign="top" class="value"><g:link controller="role" action="show" id="${membershipInstance?.role?.id}">${membershipInstance?.role?.name?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">User:</td>
                            
                            <td valign="top" class="value"><g:link controller="GDOCUser" action="show" id="${membershipInstance?.user?.id}">${membershipInstance?.user?.username?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${membershipInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
