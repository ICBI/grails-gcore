

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminReport" />
        <title>Invitation List</title>
    </head>
    <body><br /><br /><br />
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Invitation</g:link></span>
        </div>
        <div class="adminForm">
            <p style="font-size:14pt;padding:15px">Invitation List</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="sumTable">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="dateCreated" title="Date Created" />
                        
                   	        <th>Group</th>
                   	    
                   	        <th>Invitee</th>
                   	    
                   	        <g:sortableColumn property="lastUpdated" title="Last Updated" />
                        
                   	        <th>Requestor</th>

							<g:sortableColumn property="status" title="Status" />
                   	    
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
        </div>
    </body>
</html>
