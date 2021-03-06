

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit UserOption</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">UserOption List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New UserOption</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">Edit UserOption</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${userOptionInstance}">
            <div class="errors">
                <g:renderErrors bean="${userOptionInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${userOptionInstance?.id}" />
                <input type="hidden" name="version" value="${userOptionInstance?.version}" />
                <div class="well">
                    <table class="admin" width="100%">
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="type">Type:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:userOptionInstance,field:'type','errors')}">
                                    <g:select  from="${UserOptionType?.values()}" value="${userOptionInstance?.type}" name="type" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:userOptionInstance,field:'user','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="user.id" value="${userOptionInstance?.user?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="value">Value:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:userOptionInstance,field:'value','errors')}">
                                    <input type="text" id="value" name="value" value="${fieldValue(bean:userOptionInstance,field:'value')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save btn btn-primary" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
