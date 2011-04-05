

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Create CollaborationGroup</title>         
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">CollaborationGroup List</g:link></span-->
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Create CollaborationGroup</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${collaborationGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${collaborationGroupInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:collaborationGroupInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description">Description:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'description','errors')}">
                                    <input type="text" id="description" name="description" value="${fieldValue(bean:collaborationGroupInstance,field:'description')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="users">Users:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'users','errors')}">
                                    
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
