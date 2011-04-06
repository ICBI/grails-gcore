

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Membership List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Membership</g:link></span>
        </div>
        <div class="body">
            <h1>Membership List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <th>Collaboration Group</th>
                   	    
                   	        <th>Role</th>
                   	    
                   	        <th>User</th>
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${membershipInstanceList}" status="i" var="membershipInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${membershipInstance.id}">${fieldValue(bean:membershipInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:membershipInstance, field:'collaborationGroup')}</td>
                        
                            <td>${fieldValue(bean:membershipInstance, field:'role')}</td>
                        
                            <td>${fieldValue(bean:membershipInstance, field:'user')}</td>
                        
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
