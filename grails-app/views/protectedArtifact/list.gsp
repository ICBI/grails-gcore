

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminReport" />
        <title>ProtectedArtifact List</title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><g:link class="create" action="create">New ProtectedArtifact</g:link></span-->
        </div>
        <div class="body">
            <div class="welcome-title">Protected Artifacts List</div>
            <br />
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list well">
                <table class="admin" width="100%">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="name" title="Name" />
                        
                   	        <g:sortableColumn property="objectId" title="Object Id" />
                        
                   	        <g:sortableColumn property="type" title="Type" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${protectedArtifactInstanceList}" status="i" var="protectedArtifactInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${protectedArtifactInstance.id}">${fieldValue(bean:protectedArtifactInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:protectedArtifactInstance, field:'name')}</td>
                        
                            <td>${fieldValue(bean:protectedArtifactInstance, field:'objectId')}</td>
                        
                            <td>${fieldValue(bean:protectedArtifactInstance, field:'type')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${protectedArtifactInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
