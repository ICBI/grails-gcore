

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="collaborationGroup.title" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="collaborationGroup.list" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="collaborationGroup.create" /></g:link></span>
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="collaborationGroup.edit" /></p>
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
                <div class="well">
                    <table class="admin" width="100%">
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="collaborationGroup.name" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:collaborationGroupInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="artifacts"><g:message code="collaborationGroup.artifacts" />:</label>
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
                                    <label for="description"><g:message code="collaborationGroup.description" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'description','errors')}">
                                    <input type="text" id="description" name="description" value="${fieldValue(bean:collaborationGroupInstance,field:'description')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="invitations"><g:message code="collaborationGroup.invitations" />:</label>
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
                                
                                <td valign="top" class="name" colspan="2"><g:message code="collaborationGroup.memberships" />:&nbsp; &nbsp;| &nbsp; &nbsp;
										<g:link controller="membership" params="['groupName':collaborationGroupInstance?.name]" action="create"><g:message code="membership.create" /></g:link><br />
									<table class="admin" width="100%">
					                    <thead>
					                        <tr>
												<th><g:message code="membership.id" /></th>
		   										<th><g:message code="membership.user" /></th>
												<th><g:message code="membership.role" /></th>

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
                    <span class="button"><g:actionSubmit class="save btn btn-primary" value="${message(code: 'gcore.update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                	<span class="button"><g:link action="show" id="${collaborationGroupInstance?.id}" class="cancel"><g:message code="gcore.cancel" /></g:link></span>
				</div>
            </g:form>
        </div>
    </body>
</html>
