

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="membership.title" /></title>         
    </head>
    <body>

    <div class="welcome-title"><g:message code="membership.create" /> </div>
    <br />
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="membership.list" /></g:link></span>
			<g:if test="${params?.username}">
	        	<span class="menuButton"><g:link class="show" action="show" controller="GDOCUser" params="${['username':params?.username]}"><g:message code="membership.back" /></g:link></span>
	        </g:if>
        </div>

    <g:if test="${flash.error}">
        <div class="errorDetail">${flash.error}</div>
    </g:if>
		

            <g:form action="save" method="post" >
                <div class="well">
                    <table class="admin" width="100%">
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="collaborationGroup"><g:message code="membership.collab" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'collaborationGroup','errors')}">
                                    <g:select optionKey="name" from="${CollaborationGroup.list()?.sort{it.name}}" name="groupName" value="${flash.params?.groupName}" optionValue="name"></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="role">Role:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'role','errors')}">
                                    <g:select optionKey="name" from="${Role.list()}" name="role" optionValue="name" value="${flash.params?.role}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:membershipInstance,field:'user','errors')}">
                                    <g:select optionKey="username" from="${GDOCUser.list(sort:'username')}" name="username"  value="${params?.username}" optionValue="username"></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save btn btn-primary" type="submit" value="${message(code: 'gcore.create')}" /></span>
                </div>
            </g:form>

    </body>
</html>
