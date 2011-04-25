<%@ page import="org.springframework.util.ClassUtils" %>
<%@ page import="org.codehaus.groovy.grails.plugins.searchable.SearchableUtils" %>
<%@ page import="org.codehaus.groovy.grails.plugins.searchable.lucene.LuceneUtils" %>
<%@ page import="org.codehaus.groovy.grails.plugins.searchable.util.StringQueryUtils" %>
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta name="layout" content="main" />
	<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery-1.3.2.js')}"></script>

		<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.ui.js')}"></script>
	
    <title><g:if test="${params.q && params.q?.trim() != ''}">${params.q} - </g:if>G-DOC Search</title>
    

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
          Showing <strong>${searchResult.offset + 1}</strong> - <strong>${searchResult.results.size() + searchResult.offset}</strong> of <strong>${searchResult.total}</strong>
          results for <strong>${params.q.encodeAsHTML()}</strong>
        </g:if>
        <g:else>
        &nbsp;
        </g:else>
      </span>
    </div>

    <g:if test="${haveQuery && !haveResults && !parseException}">
	
      <p>Nothing matched your recent query. </p>
      
    </g:if>

    

    <g:if test="${parseException}">
      <p>Your query - <strong>${params.q.encodeAsHTML()}</strong> - is not valid.</p>
      
    </g:if>

    <g:if test="${haveResults}">
      <div class="results">
        <g:each var="result" in="${searchResult.results}" status="index">
          <div class="result">
            <g:set var="className" value="${ClassUtils.getShortName(result.getClass())}" />
				<g:if test="${className == 'Study'}">
					<div>
						<g:link style="color:blue;font-size:1.2em" action="show" controller="studyDataSource" id="${result.id}">
							${result.shortName}
						</g:link> (Study)
						<g:if test="${result.abstractText}">
							<g:set var="desc" value="${result.abstractText}" />
				            	<g:if test="${desc.size() > 120}">
									<g:set var="desc" value="${desc[0..120] + '...'}" />
								</g:if>
				            <div class="desc">${result.longName}:${desc.encodeAsHTML()}</div>
						</g:if>
						<%--span style="color:green">cancer site: ${result.disease},Principal Investigators:
							<g:set var="pis" value="${result.pis.collect{it.lastName}}" />
							${pis}</span--%>
					</div>
				</g:if>
            	<g:if test="${className == 'MoleculeTarget'}">
					<div>
						<g:link action="show" id="${result.id}" controller="moleculeTarget">
							<g:if test="${result.molecule.name}">
								<g:set var="molDesc" value="${result.molecule.name}" />
					            	<g:if test="${molDesc.size() > 20}">
										<g:set var="molDesc" value="${molDesc[0..10] + '...'+ ' with ' + result}" />
									</g:if>
					            <div class="molDesc">(Target Drug Molecule) ${molDesc.encodeAsHTML()}</div>
							</g:if>
							<g:else>
								${result}
							</g:else>
						</g:link>
						<g:if test="${result.molecule.formula}">
							<g:set var="desc" value="${result.molecule.formula}" />
				            	<g:if test="${desc.size() > 120}">
									<g:set var="desc" value="${desc[0..120] + '...'}" />
								</g:if>
				            <%--div class="desc">${desc.encodeAsHTML()}</div--%>
						</g:if>
						<g:else>
						No binding data available
						</g:else>
						<span style="color:green">targets: 
						<g:set var="target" value="${result.protein.gene?.geneAliases?.toArray().collect{it.symbol}}" />
							${target.join(",")}
						</span>
					</div>
				</g:if>
				<g:if test="${className == 'Finding'}">
					<div>
						<g:link action="show" id="${result.id}" controller="finding">${result.title}</g:link> (Finding)
						<g:if test="${result.description}">
							<g:set var="desc" value="${result.description}" />
				            	<g:if test="${desc.size() > 120}">
									<g:set var="desc" value="${desc[0..120] + '...'}" />
								</g:if>
				            <div class="desc">${desc.encodeAsHTML()}</div>
						</g:if>
						<g:else>
						No title available
						</g:else>
						
					</div>
				</g:if>
            
          </div>
        </g:each>
      </div>

      <div>
        <div class="paging">
          	<g:if test="${haveResults}"> <!-- or you could use test="${searchResult?.results}" -->
			    Page:
			    <g:set var="totalPages" value="${Math.ceil(searchResult.total / searchResult.max)}" />
			    <g:if test="${totalPages == 1}">
			        <span class="currentStep">1</span>
			    </g:if>
			    <g:else>
			        <g:paginate controller="search" action="index" params="[q: params.q]" 
			                    total="${searchResult.total}" prev="&lt; previous" next="next &gt;"/>
			    </g:else>
			</g:if>
        </div>
      </div>
    </g:if>
  </div>
  </body>
</html>