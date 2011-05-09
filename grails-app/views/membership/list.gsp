

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="membership.title" /></title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="create" action="create"><g:message code="membership.create" /></g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px"><g:message code="membership.list" /></p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="admin">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="${message(code: 'membership.id')}" />
                        
                   	        <g:sortableColumn property="groupName" title="${message(code: 'membership.group')}" />
                   	    
                   	        <g:sortableColumn property="userName" title="${message(code: 'membership.user')}" />
                   	    
                   	       	<g:sortableColumn property="roleName" title="${message(code: 'membership.role')}" />
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${membershipInstanceList}" status="i" var="membershipInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${membershipInstance.id}">${fieldValue(bean:membershipInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:membershipInstance, field:'collaborationGroup')}</td>
                        
                            <td>${fieldValue(bean:membershipInstance, field:'user')}</td>

							<td>${fieldValue(bean:membershipInstance, field:'role')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${membershipInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
