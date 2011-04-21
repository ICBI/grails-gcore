

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>Membership List</title>
    </head>
    <body>
        <div class="nav">
            
            <span class="menuButton"><g:link class="create" action="create">New Membership</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">Membership List</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="admin">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="groupName" title="Collaboration Group" />
                   	    
                   	        <g:sortableColumn property="userName" title="User" />
                   	    
                   	       	<g:sortableColumn property="roleName" title="Role" />
                   	    
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
