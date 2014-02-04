

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Create ProtectedArtifact</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">ProtectedArtifact List</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:15px">Create ProtectedArtifact</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${protectedArtifactInstance}">
            <div class="errors">
                <g:renderErrors bean="${protectedArtifactInstance}" as="list" />
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
                                <td valign="top" class="value ${hasErrors(bean:protectedArtifactInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:protectedArtifactInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="objectId">Object Id:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:protectedArtifactInstance,field:'objectId','errors')}">
                                    <input type="text" id="objectId" name="objectId" value="${fieldValue(bean:protectedArtifactInstance,field:'objectId')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="type">Type:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:protectedArtifactInstance,field:'type','errors')}">
                                    <input type="text" id="type" name="type" value="${fieldValue(bean:protectedArtifactInstance,field:'type')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save btn btn-primary" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
