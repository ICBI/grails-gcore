

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show ProtectedArtifact</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">ProtectedArtifact List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ProtectedArtifact</g:link></span>
        </div>
        <div class="body">
            <h1>Show ProtectedArtifact</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:protectedArtifactInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Groups:</td>
                            
                            <td  valign="top" style="text-align:left;" class="value">
                                <ul>
                                <g:each var="g" in="${protectedArtifactInstance.groups}">
                                    <li><g:link controller="collaborationGroup" action="show" id="${g.id}">${g?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:protectedArtifactInstance, field:'name')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Object Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:protectedArtifactInstance, field:'objectId')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Type:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:protectedArtifactInstance, field:'type')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${protectedArtifactInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
