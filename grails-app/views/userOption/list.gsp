

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminLayout" />
        <title>UserOption List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><g:link class="create" action="create">New UserOption</g:link></span>
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:10px">UserOption List</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list well">
                <table class="admin" width="100%">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="type" title="Type" />
                        
                   	        <th>User</th>
                   	    
                   	        <g:sortableColumn property="value" title="Value" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userOptionInstanceList}" status="i" var="userOptionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${userOptionInstance.id}">${fieldValue(bean:userOptionInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:userOptionInstance, field:'type')}</td>
                        
                            <td>${fieldValue(bean:userOptionInstance, field:'user')}</td>
                        
                            <td>${fieldValue(bean:userOptionInstance, field:'value')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${userOptionInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
