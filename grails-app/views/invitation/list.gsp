

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminReport" />
        <title><g:message code="invitations.heading" /></title>
    </head>
    <body>
    <div class="welcome-title"><g:message code="invitations.list" /></div> <br/>
    <g:if test="${flash.message}">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${flash.message}
        </div>
    </g:if>

            <div class="list well">
                <table class="admin" width="100%">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="${message(code: 'invitations.id')}" />
                        
                   	        <g:sortableColumn property="dateCreated" title="${message(code: 'invitations.dateCreated')}" />
                        
                   	        <th><g:message code="invitations.group" /></th>
                   	    
                   	        <th><g:message code="invitations.invitee" /></th>
                   	    
                   	        <g:sortableColumn property="lastUpdated" title="${message(code: 'invitations.lastUpdated')}" />
                        
                   	        <th><g:message code="invitations.requestor" /></th>

							<g:sortableColumn property="status" title="${message(code: 'invitations.status')}" />
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${invitationInstanceList}" status="i" var="invitationInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${invitationInstance.id}">${fieldValue(bean:invitationInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:invitationInstance, field:'dateCreated')}</td>
                        
                            <td>${fieldValue(bean:invitationInstance, field:'group')}</td>
                        
                            <td>${fieldValue(bean:invitationInstance, field:'invitee')}</td>
                        
                            <td>${fieldValue(bean:invitationInstance, field:'lastUpdated')}</td>
                        
                            <td>${fieldValue(bean:invitationInstance, field:'requestor')}</td>
							
							<td>${fieldValue(bean:invitationInstance, field:'status')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${invitationInstanceTotal}" />
            </div>

    </body>
</html>
