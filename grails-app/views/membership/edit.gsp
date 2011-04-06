

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit Membership</title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span-->
            <span class="menuButton"><g:link class="list" action="list">Membership List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Membership</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:15px">Edit Membership</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${membershipInstance}">
            <div class="errors">
                <g:renderErrors bean="${membershipInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${membershipInstance?.id}" />
                <input type="hidden" name="version" value="${membershipInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="collaborationGroup">Collaboration Group:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'collaborationGroup','errors')}">
                                    <g:select optionKey="id" from="${CollaborationGroup.list()}" name="collaborationGroup.id" value="${membershipInstance?.collaborationGroup?.id}" optionValue="name" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="role">Role:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'role','errors')}">
                                    <g:select optionKey="id" from="${Role.list()}" name="role.id" value="${membershipInstance?.role?.id}" optionValue="name" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'user','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="user.id" value="${membershipInstance?.user?.id}" optionValue="username" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons"><br />
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
