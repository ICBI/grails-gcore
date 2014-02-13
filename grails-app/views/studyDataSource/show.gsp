<html>
<head>
    <meta name="layout" content="maxSpaceLayout" />
    <title>${currStudy.shortName} <g:message code="study.details"/></title>
    <style>
    .table tr:nth-child(even)		{ background-color:#F8F8F8; }
    .table tr:nth-child(odd)		{ background-color:#fff; }
    </style>
</head>
<body>
    <div class="welcome-title"><g:message code="study.title"/></div>
    <div class="desc">${currStudy.shortName} <g:message code="study.details"/></div>

    <div class="features">
        <g:form controller="StudyDataSource" action="setStudy">
            <g:hiddenField name="study" id="study" value="${currStudy.id}" />
            <g:submitButton class="btn btn-primary" name="Select Study" value="Select Study" />
        </g:form>

        <div style="margin-right:45px">

                <table class="table" width="100%">
                    <tr>
                        <td class="label-bis" width="20%"><g:message code="study.name"/></td>
                        <td>${currStudy.shortName}&nbsp;&nbsp;&nbsp;(<g:message code="study.id"/>:${currStudy.id})</td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.abstract"/></td>
                        <td>${currStudy.abstractText}</td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.pi"/></td>
                        <td>
                            <g:each in="${currStudy.pis}" var="pi">
                                ${pi.firstName} ${pi.lastName}, ${pi.suffix}<br/>
                            </g:each>
                        </td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.disease"/></td>
                        <td>${currStudy.disease}</td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.poc"/></td>
                        <td>
                            <g:each in="${currStudy.pocs}" var="poc">
                                ${poc.firstName} ${poc.lastName}<br/>
                            </g:each>
                        </td>
                    </tr>
                    <g:if test="${currStudy.content}">
                        <tr>
                            <td class="label-bis" width="20%">Data Type Details</td>
                            <td>
                                <g:each in="${currStudy.content}" var="content">
                                    &nbsp;|&nbsp;${content.type}
                                </g:each>
                            </td>
                        </tr>
                    </g:if>
                </table>

        </div>

    </div>

	</body>
	
</hmtl>