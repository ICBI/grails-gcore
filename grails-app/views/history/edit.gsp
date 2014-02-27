

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit History</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">History List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New History</g:link></span>
        </div>
        <div class="body">
            <h1>Edit History</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${historyInstance}">
            <div class="errors">
                <g:renderErrors bean="${historyInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${historyInstance?.id}" />
                <input type="hidden" name="version" value="${historyInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreated">Date Created:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:historyInstance,field:'dateCreated','errors')}">
                                    <g:datePicker name="dateCreated" value="${historyInstance?.dateCreated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="study">Study:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:historyInstance,field:'study','errors')}">
                                    <g:select optionKey="id" from="${Study.list()}" name="study.id" value="${historyInstance?.study?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user">User:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:historyInstance,field:'user','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="user.id" value="${historyInstance?.user?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
