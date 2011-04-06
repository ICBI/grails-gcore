

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminReport" />
        <title>CollaborationGroup List</title>
    </head>
    <body>
        <!--div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New CollaborationGroup</g:link></span-->
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:15px">CollaborationGroup List</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="sumTable">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="name" title="Name" />
                        
                   	        <g:sortableColumn property="description" title="Description" />
                        
                   	        <td>Users</td>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${collaborationGroupInstanceList}" status="i" var="collaborationGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${collaborationGroupInstance.id}">${fieldValue(bean:collaborationGroupInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:collaborationGroupInstance, field:'name')}</td>
                        
                            <td>${fieldValue(bean:collaborationGroupInstance, field:'description')}</td>
                        
                            <td>${fieldValue(bean:collaborationGroupInstance, field:'users')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${collaborationGroupInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
