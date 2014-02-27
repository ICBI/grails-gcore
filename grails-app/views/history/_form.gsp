



<div class="fieldcontain ${hasErrors(bean: historyInstance, field: 'study', 'error')} required">
	<label for="study">
		<g:message code="history.study.label" default="Study" />
		<span class="required-indicator">*</span>
	</label>
	<g:select optionKey="id" from="${Study.list()}" name="study.id" value="${historyInstance?.study?.id}" ></g:select>
</div>

<div class="fieldcontain ${hasErrors(bean: historyInstance, field: 'user', 'error')} required">
	<label for="user">
		<g:message code="history.user.label" default="User" />
		<span class="required-indicator">*</span>
	</label>
	<g:select optionKey="id" from="${GDOCUser.list()}" name="user.id" value="${historyInstance?.user?.id}" ></g:select>
</div>

