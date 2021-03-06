

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>History List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New History</g:link></span>
        </div>
        <div class="body">
            <h1>History List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="features">
                <table class="order-table table">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="dateCreated" title="Date Created" />
                        
                   	        <th>Study</th>
                   	    
                   	        <th>User</th>
                   	    
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${historyInstanceList}" status="i" var="historyInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${historyInstance.id}">${fieldValue(bean:historyInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:historyInstance, field:'dateCreated')}</td>
                        
                            <td>${fieldValue(bean:historyInstance, field:'study')}</td>
                        
                            <td>${fieldValue(bean:historyInstance, field:'user')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${historyInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
