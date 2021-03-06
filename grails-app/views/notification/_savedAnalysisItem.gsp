<g:javascript library="jquery" plugin="jquery"/>

    <div class="notificationContainer" style="height: 10px">
        <g:if test="${notification.status == 'Complete'}">
            <div style="float: left;">
                <g:if test="${g.analysisView(type: notification.type)}">
                    <g:link controller="${g.analysisView(type: notification.type)}" action="view" id="${notification.id}">${notification.type.value()}</g:link> (<g:formatDate date="${notification.dateCreated}" format="h:mm M/dd/yyyy"/> )
                </g:if>
                <g:else>
                    ${notification.type.value()}
                </g:else>
            </div>
            <div class="status" style="float: right; ">
                ${notification.status}
            </div>
        </g:if>
        <g:elseif test="${notification.status == 'Error'}">
            <div style="float: left;">${notification.type.value()} (<g:formatDate date="${notification.dateCreated}" format="h:mm M/dd/yyyy"/> )
            </div>
            <div class="status errorStatus" style="float: right;text-decoration:underline;cursor:pointer" id="${notification.id}">${notification.status.toUpperCase()}</div>
        </g:elseif>
        <g:else>
            <div style="float: left;">${notification.type.value()} (<g:formatDate date="${notification.dateCreated}" format="h:mm M/dd/yyyy"/> )
            </div>
            <div class="status" style="float: right;">${notification.status} <img style="height: 12px" src="${createLinkTo(dir:'images',file:'indicator.gif')}" border="0" />

            <g:link onclick="return confirm('Are you sure?');" action="delete" id="${notification.id}">
            <img alt="${message(code: 'notifications.delete')}" title="${message(code: 'notifications.delete')}" style="vertical-align: bottom;" src="${createLinkTo(dir: 'images', file: 'cross.png')}"/></g:link>
            </div>
        </g:else>
    </div>
    <br/>
