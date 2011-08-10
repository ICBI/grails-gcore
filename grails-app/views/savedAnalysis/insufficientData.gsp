<html>
    <head>
        <title><g:message code="savedAnalysis.insufficientData" args="${[appTitle()]}"/></title>
		<meta name="layout" content="report" />
		<g:javascript library="jquery"/>
		
    </head>
    <body>
	
		<div id="centerContent" style="width:65%;padding:15px">
			<p style="font-size:14pt"><g:message code="savedAnalysis.insufficientData" /></p>
				
				<div style="font:1em;font-weight:bold"><g:message code="savedAnalysis.insufficientData.explanation" /></div><br /><br />
					<g:each in="${params}" var="param">
						<g:if test="${param.key!='action' && param.key!='controller'}">
						${param.key}:
						<g:if test="${param.value.metaClass.respondsTo(params.value, 'max')}">
							<g:each in="${param.value}" var="list">
								${list}&nbsp;&nbsp;
							</g:each>
						</g:if>
						<g:else>
						${param.value}
						</g:else>
						<br />
						</g:if>
					</g:each>
			</p>
			</div>
			
	
		
	</body>
	
</html>