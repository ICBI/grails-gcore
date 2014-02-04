

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title><g:message code="membership.title" /></title>
    </head>
    <body>

    <div class="welcome-title"><g:message code="membership.list" /> </div>
    <br />
    <g:if test="${flash.message}">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            ${flash.message}
        </div>
    </g:if>

        <div class="nav">
            <span class="menuButton"><g:link class="create" action="create"><g:message code="membership.create" /></g:link></span>
        </div>

            <div class="list well">
                <table class="admin"  style="width:100%">
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

    </body>
</html>
