<g:if test="${session.notifications}">
<g:each in="${session.notifications}" var="item">
	<g:render template="savedAnalysisItem" bean="${item}" var="notification" plugin="gcore" />
</g:each>

</g:if>
<g:else>
<g:message code="notifications.none" />
</g:else>