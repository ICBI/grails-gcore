

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Create Invitation</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Invitation List</g:link></span>
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Create Invitation</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${invitationInstance}">
            <div class="errors">
                <g:renderErrors bean="${invitationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="well">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateCreated">Date Created:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'dateCreated','errors')}">
                                    <g:datePicker name="dateCreated" value="${invitationInstance?.dateCreated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="group">Group:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'group','errors')}">
                                    <g:select optionKey="id" from="${CollaborationGroup.list()}" name="group.id" value="${invitationInstance?.group?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="invitee">Invitee:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'invitee','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="invitee.id" value="${invitationInstance?.invitee?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastUpdated">Last Updated:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'lastUpdated','errors')}">
                                    <g:datePicker name="lastUpdated" value="${invitationInstance?.lastUpdated}" precision="minute" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="requestor">Requestor:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'requestor','errors')}">
                                    <g:select optionKey="id" from="${GDOCUser.list()}" name="requestor.id" value="${invitationInstance?.requestor?.id}" ></g:select>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status">Status:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:invitationInstance,field:'status','errors')}">
                                    <g:select  from="${InviteStatus?.values()}" value="${invitationInstance?.status}" name="status" ></g:select>
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
