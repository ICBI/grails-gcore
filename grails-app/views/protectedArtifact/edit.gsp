

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit ProtectedArtifact</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="list" action="list">ProtectedArtifact List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ProtectedArtifact</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding-bottom:10px">Edit ProtectedArtifact</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${protectedArtifactInstance}">
            <div class="errors">
                <g:renderErrors bean="${protectedArtifactInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${protectedArtifactInstance?.id}" />
                <input type="hidden" name="version" value="${protectedArtifactInstance?.version}" />
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

							<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="groups">Groups:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:protectedArtifactInstance,field:'groups','errors')}">
                                    <g:select name="group"
									          from="${CollaborationGroup.list(sort:'name')}"
									          value="${protectedArtifactInstance?.groups.id}"
									          optionKey="id"
											  optionValue="name" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save btn btn-primary" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                	<span class="button"><g:link action="show" id="${protectedArtifactInstance?.id}" class="cancel">Cancel</g:link></span>
				</div>
            </g:form>
        </div><br /><br />
    </body>
</html>
