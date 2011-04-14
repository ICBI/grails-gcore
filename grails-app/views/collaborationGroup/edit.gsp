

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Edit CollaborationGroup</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list">CollaborationGroup List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New CollaborationGroup</g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px">Edit CollaborationGroup</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message.encodeAsHTML()}</div>
            </g:if>
			<g:if test="${flash.error}">
            	<div class="errorDetail">${flash.error.encodeAsHTML()}</div>
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
                    <table class="admin">
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


                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                
                                <td valign="top" class="name" colspan="2">Memberships:&nbsp; &nbsp;| &nbsp; &nbsp;
										<g:link controller="membership" params="['groupName':collaborationGroupInstance?.name]" action="create">Add Membership?</g:link><br />
									<table class="admin">
					                    <thead>
					                        <tr>
												<th>Id</th>
		   										<th>User</th>
												<th>Role</th>

					                        </tr>
					                    </thead>
					                    <tbody>
					                    <g:each in="${collaborationGroupInstance.memberships}" status="i" var="membership">
					                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
												<td><g:link controller="membership" action="show" id="${membership.id}">${membership.id.encodeAsHTML()}</g:link></td>

												<td>${fieldValue(bean:membership, field:'user')}</td>

					                            <td>${fieldValue(bean:membership, field:'role')}</td>

					                        </tr>
					                    </g:each>
					                    </tbody>
					                </table>
								</td>
                            </tr> 
                        
                            <!--tr class="prop">
                                <td valign="top" class="name">
                                    <label for="users">Users:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'users','errors')}">
                                    
                                </td>
                            </tr--> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                	<span class="button"><g:link action="show" id="${collaborationGroupInstance?.id}" class="cancel">Cancel</g:link></span>
				</div>
            </g:form>
        </div>
    </body>
</html>
