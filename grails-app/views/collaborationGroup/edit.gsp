

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit CollaborationGroup</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">CollaborationGroup List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New CollaborationGroup</g:link></span>
        </div>
        <div class="body">
            <h1>Edit CollaborationGroup</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${collaborationGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${collaborationGroupInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${collaborationGroupInstance?.id}" />
                <input type="hidden" name="version" value="${collaborationGroupInstance?.version}" />
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
                                    <label for="artifacts">Artifacts:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'artifacts','errors')}">
                                    <g:select name="artifacts"
from="${ProtectedArtifact.list()}"
size="5" multiple="yes" optionKey="id"
value="${collaborationGroupInstance?.artifacts}" />

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
                                    <label for="invitations">Invitations:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'invitations','errors')}">
                                    
<ul>
<g:each var="i" in="${collaborationGroupInstance?.invitations?}">
    <li><g:link controller="invitation" action="show" id="${i.id}">${i?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="invitation" params="['collaborationGroup.id':collaborationGroupInstance?.id]" action="create">Add Invitation</g:link>

                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="memberships">Memberships:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'memberships','errors')}">
                                    
<ul>
<g:each var="m" in="${collaborationGroupInstance?.memberships?}">
    <li><g:link controller="membership" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="membership" params="['collaborationGroup.id':collaborationGroupInstance?.id]" action="create">Add Membership</g:link>

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
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
