

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="invitations.heading" /></title>
    </head>
    <body>
        <div class="nav">
        
            <span class="menuButton"><g:link class="list" action="list"><g:message code="invitations.list" /></g:link></span>
            <!--span class="menuButton"><g:link class="create" action="create">New Invitation</g:link></span-->
        </div>
        <div>
            <p style="font-size:14pt;padding:10px"><g:message code="invitations.edit" args="${ [fieldValue(bean:invitationInstance, field:'id')] }" /></p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${invitationInstance}">
            <div class="errors">
                <g:renderErrors bean="${invitationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${invitationInstance?.id}" />
                <input type="hidden" name="version" value="${invitationInstance?.version}" />
                <div class="well">
                    <table class="admin" width="100%">
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreated"><g:message code="invitations.dateCreated" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'dateCreated','errors')}">
                                    <g:datePicker name="dateCreated" value="${invitationInstance?.dateCreated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="group"><g:message code="invitations.group" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'group','errors')}">
                                    <g:select optionKey="id" from="${CollaborationGroup.list()}" name="group.id" value="${invitationInstance?.group?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="invitee"><g:message code="invitations.invitee" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'invitee','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="invitee.id" value="${invitationInstance?.invitee?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastUpdated"><g:message code="invitations.lastUpdated" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'lastUpdated','errors')}">
                                    <g:datePicker name="lastUpdated" value="${invitationInstance?.lastUpdated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="requestor"><g:message code="invitations.requestor" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'requestor','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="requestor.id" value="${invitationInstance?.requestor?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status"><g:message code="invitations.status" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'status','errors')}">
                                    <g:select  from="${InviteStatus?.values()}" value="${invitationInstance?.status}" name="status" ></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save btn btn-primary" value="${message(code: 'gcore.update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete btn btn-default" onclick="return confirm('Are you sure?');" value="${message(code: 'gcore.delete')}" /></span>
                	<span class="button"><g:link action="show" id="${invitationInstance?.id}" class="cancel"><g:message code="gcore.cancel" /></g:link></span>
				</div>
            </g:form>
        </div>
    </body>
</html>
