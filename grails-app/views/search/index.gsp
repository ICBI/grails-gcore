<%@ page import="org.springframework.util.ClassUtils" %>
<%@ page import="grails.plugin.searchable.internal.SearchableUtils" %>
<%@ page import="grails.plugin.searchable.internal.lucene.LuceneUtils" %>
<%@ page import="grails.plugin.searchable.internal.util.StringQueryUtils" %>
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="layout" content="main" />
	<g:javascript library="jquery" plugin="jquery"/>

		<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.ui.js')}"></script>

    <title><g:if test="${params.q && params.q?.trim() != ''}">${params.q} - </g:if><g:message code="search.title"/></title>


    <script type="text/javascript">
        var focusQueryInput = function() {
            document.getElementById("q").focus();
        }
    </script>
  </head>
  <body onload="focusQueryInput();">

  <div id="header">
    <%--h1><a href="http://grails.org/Searchable+Plugin" target="_blank">Grails <span>Searchable</span> Plugin</a></h1>
    <g:form url='[controller: "search", action: "index"]' id="searchableForm" name="searchableForm" method="get">
        <g:textField name="q" value="${params.q}" size="50"/> <input type="submit" value="Search" />
    </g:form--%>

  </div>
  <div id="main">

    <g:set var="haveQuery" value="${params.q?.trim()}" />
    <g:set var="haveResults" value="${searchResult?.results}" />

    <div class="title">
      <span>
        <g:if test="${haveQuery && haveResults}">
          <g:message code="search.showing"/> <strong>${searchResult.offset + 1}</strong> - <strong>${searchResult.results.size() + searchResult.offset}</strong> <g:message code="search.of"/> <strong>${searchResult.total}</strong>
          <g:message code="search.results"/> <strong>${params.q.encodeAsHTML()}</strong>
        </g:if>
        <g:else>
        &nbsp;
        </g:else>
      </span>
    </div>

    <g:if test="${!haveResults}">
      <div class="desc"><g:message code="search.noResults"/> </div>
      <div class="desc1">  Suggestions:
        <ul>
            <li>Make sure all words are spelled correctly.</li>
            <li>Try different keywords.</li>
            <li>Try more general keywords.</li>
            <li>Try fewer keywords.</li>
        </ul>
        </div>
    </g:if>



    <g:if test="${parseException}">
      <p><g:message code="search.query"/> - <strong>${params.q.encodeAsHTML()}</strong> - <g:message code="search.notValid"/></p>

    </g:if>

    <g:if test="${haveResults}">
      <div class="results features">
        <g:each var="result" in="${searchResult.results}" status="index">
          <div class="result">
            <g:set var="className" value="${ClassUtils.getShortName(result.getClass())}" />
				<g:if test="${className == 'Study'}">
					<div>
						<g:link style="font-size:1.2em" action="show" controller="studyDataSource" id="${result.id}">
							${result.shortName}
						</g:link> <g:message code="search.study"/>
						<g:if test="${result.abstractText}">
							<g:set var="desc" value="${result.abstractText}" />
				            	<g:if test="${desc.size() > 120}">
									<g:set var="desc" value="${desc[0..120] + '...'}" />
								</g:if>
				            <div class="desc2">${result.longName}:${desc.encodeAsHTML()}</div>
						</g:if>
						<%--span style="color:green">cancer site: ${result.disease},Principal Investigators:
							<g:set var="pis" value="${result.pis.collect{it.lastName}}" />
							${pis}</span--%>
					</div>
                    <br/>
				</g:if>
            	<g:if test="${className == 'MoleculeTarget'}">
					<div>
						<g:link style="font-size:1.2em" action="show" id="${result.id}" controller="moleculeTarget">
							<g:if test="${result.molecule.name}">
								<g:set var="molDesc" value="${result.molecule.name}" />
					            	<g:if test="${molDesc.size() > 20}">
										<g:set var="molDesc" value="${molDesc[0..10] + '...'+ ' with ' + result}" />
									</g:if>
					            <div class="molDesc" style="float:left;"> ${molDesc.encodeAsHTML()}</div>
							</g:if>
							<g:else>
                                <div style="float:left;"> ${result} </div>
							</g:else>
						</g:link>
                       <div style="float:left;">&nbsp;<g:message code="search.target"/> <br/></div>
                       <div class="desc2">
                            <g:if test="${result.molecule.formula}">
                                <g:set var="desc" value="${result.molecule.formula}" />
                                    <g:if test="${desc.size() > 120}">
                                        <g:set var="desc" value="${desc[0..120] + '...'}" />
                                    </g:if>
                                <%--div class="desc2">${desc.encodeAsHTML()}</div--%>
                            </g:if>
                            <g:else>
                                <br/>
                            <g:message code="search.noBinding"/>
                            </g:else>
                            <span><br/><g:message code="search.targets"/>:
                            <span style="color:green;"><g:set var="target" value="${result.protein.gene?.geneAliases?.toArray().collect{it.symbol}}" />
                                ${target.join(",")}</span>
                            </span>
                       </div>
					</div>
                    <br/>
				</g:if>
				<g:if test="${className == 'Finding'}">
					<div>
						<g:link style="font-size:1.2em" action="show" id="${result.id}" controller="finding">${result.title}</g:link> <g:message code="search.finding"/>
						<g:if test="${result.description}">
							<g:set var="desc" value="${result.description}" />
				            	<g:if test="${desc.size() > 120}">
									<g:set var="desc" value="${desc[0..120] + '...'}" />
								</g:if>
				            <div class="desc2">${desc.encodeAsHTML()}</div>
						</g:if>
						<g:else>
						<g:message code="search.noTitle"/>
						</g:else>

					</div>
				</g:if>

          </div>
        </g:each>
      </div>


        <div class="paging">
          	<g:if test="${haveResults}"> <!-- or you could use test="${searchResult?.results}" -->
			    <g:message code="search.page"/>:
			    <g:set var="totalPages" value="${Math.ceil(searchResult.total / searchResult.max)}" />
			    <g:if test="${totalPages == 1}">
			        <span class="currentStep">1</span>
			    </g:if>
			    <g:else>
			        <g:paginate controller="search" action="index" params="[q: params.q]"
			                    total="${searchResult.total}" prev="&lt; ${message(code: 'search.previous')}" next="${message(code: 'search.next')} &gt;"/>
			    </g:else>
			</g:if>
        </div>

    </g:if>
  </div>
  </body>
</html>
