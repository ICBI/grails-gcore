

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="adminReport" />
        <title>User List</title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New GDOCUser</g:link></span-->
        </div>
        <div class="body">
            <p style="font-size:14pt;padding:15px">User List</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table class="sumTable">
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="username" title="Username" />
                        
                   	        <g:sortableColumn property="firstName" title="First Name" />
                        
                   	        <g:sortableColumn property="lastName" title="Last Name" />
                        
                   	        <g:sortableColumn property="password" title="Password" />
                        
                   	        <g:sortableColumn property="email" title="Email" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${GDOCUserInstanceList}" status="i" var="GDOCUserInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${GDOCUserInstance.id}">${fieldValue(bean:GDOCUserInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:GDOCUserInstance, field:'username')}</td>
                        
                            <td>${fieldValue(bean:GDOCUserInstance, field:'firstName')}</td>
                        
                            <td>${fieldValue(bean:GDOCUserInstance, field:'lastName')}</td>
                        
                            <td>${fieldValue(bean:GDOCUserInstance, field:'password')}</td>
                        
                            <td>${fieldValue(bean:GDOCUserInstance, field:'email')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${GDOCUserInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
