

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Create Role</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Role List</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">Create Role</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${roleInstance}">
            <div class="errors">
                <g:renderErrors bean="${roleInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="well">
                    <table class="admin" width="100%">
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:roleInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:roleInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save btn btn-primary" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
