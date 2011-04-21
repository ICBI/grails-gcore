

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit Membership</title>
    </head>
    <body>
        <div>
            
            <span class="menuButton"><g:link class="list" action="list">Membership List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Membership</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">Edit Membership</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:if test="${flash.error}">
            	<div class="errorDetail">${flash.error}</div>
            </g:if>
            <g:form method="post" >
                <input type="hidden" name="id" value="${membershipInstance?.id}" />
                <div class="dialog">
                    <table class="admin">
                        <tbody>
	
							<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'user','errors')}">
								${membershipInstance?.user?.username}
								 <input type="hidden" name="user.id" value="${membershipInstance?.user?.id}" />
                                    <%--g:select optionKey="id" from="${GDOCUser.list()}" name="user.id" value="${membershipInstance?.user?.id}" optionValue="username" ></g:select--%>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="collaborationGroup">Collaboration Group:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'collaborationGroup','errors')}">
										${membershipInstance?.collaborationGroup?.name}
										 <input type="hidden" name="collaborationGroup.id" value="${membershipInstance?.collaborationGroup?.id}" />
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
                        
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons"><br />
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                	<span class="button"><g:link action="show" id="${membershipInstance?.id}" class="cancel">Cancel</g:link></span>
				</div>
            </g:form>
        </div>
    </body>
</html>
