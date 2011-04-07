

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Show ProtectedArtifact</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">ProtectedArtifact List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ProtectedArtifact</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding-bottom:15px">Show ProtectedArtifact</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table class="admin">
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
                                    <g:link controller="collaborationGroup" action="show" id="${g.id}">${g?.name?.encodeAsHTML()}</g:link>
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
						
						<tr class="prop">
                            <td valign="top" class="name">Referenced Artifact Description:</td>
                            
                            <td valign="top" class="value">${description}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div><br />
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${protectedArtifactInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div><br /><br />
    </body>
</html>
