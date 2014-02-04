

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="collaborationGroup.title" /></title>         
    </head>
    <body>

    <div class="welcome-title"><g:message code="collaborationGroup.create" /></div> <br/>
    <div class="nav">
            <span class="menuButton"><g:link class="list" action="list"><g:message code="collaborationGroup.list" /></g:link></span>
        </div>
        <div>

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
            <g:form action="save" method="post" >
                <div class="well">
                    <table class="admin" style="width:100%;">
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
                                    <label for="description"><g:message code="collaborationGroup.description" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'description','errors')}">
                                    <input type="text" id="description" name="description" value="${fieldValue(bean:collaborationGroupInstance,field:'description')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="owner"><g:message code="collaborationGroup.owner" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:collaborationGroupInstance,field:'users','errors')}">
                                    <g:select optionKey="username" from="${GDOCUser.list(sort:'username')}" name="owner"  value="${params?.GDOCUser?.username}" optionValue="username"></g:select>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div><br />
                <div class="buttons">
                    <span class="button"><input class="save btn btn-primary" type="submit" value="${message(code: 'gcore.create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
