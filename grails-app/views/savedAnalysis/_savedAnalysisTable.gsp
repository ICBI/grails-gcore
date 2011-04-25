<g:javascript library="jquery"/>



<table class="listTable" width="100%" cellpadding="2">
	

<g:each in="${savedAnalysis}" var="analysis">



<tr>
	<td style="background-color:white;">
		
<div class="notificationContainer" style="height: 10px">
		<div style="float: left;">
			
			<g:if test="${(session.userId.equals(analysis.author.username)) && (analysis.query?.geAnalysisId?.toString() != 'null')}">
			<div style="border:0px solid black;width:2%;float:left;padding-right:20px"><g:checkBox class="the_checkbox" name="deleteAnalyses"
				 value="${analysis.id}" checked="false"/></div>
			</g:if>
			
			<g:if test="${analysis.status == 'Error'}">
				<div style="float: left;">${analysis.type} (<g:formatDate date="${analysis.dateCreated}" format="h:mm M/dd/yyyy"/> ) 
				</div>
				<div class="status" style="float: right;text-decoration:underline;cursor:pointer" title='${analysis.analysis.item.errorMessage}'>${analysis.status.toUpperCase()}</div>
			</g:if>
			<g:else>
				<g:if test="${g.analysisView(type: analysis.type)}">
					<g:if test="${(analysis.query?.geAnalysisId?.toString() == 'null')}">
						<span style="font-style:italic">${analysis.type} **REFERENCED ANALYSIS (not viewable)**</span>
					</g:if>
					<g:else>
					<g:link controller="${g.analysisView(type: analysis.type)}" action="view"  id="${analysis.id}">${analysis.type}</g:link>
					</g:else>
				</g:if>
				<g:else>
					${analysis.type}
				</g:else>
				&nbsp;&nbsp;<span><g:formatDate date="${analysis.dateCreated}" format="h:mm M/dd/yyyy"/></span>
			</div>
				<g:if test="${session.userId.equals(analysis.author.username)}">
				<div style="border:0px solid black;width:20%;float:right">	
					<g:if test="${(!analysis.tags.contains('_temporary')) && (analysis.query?.geAnalysisId?.toString() != 'null')}">
					<g:link class="thickbox" name="Share &nbsp; analysis &nbsp; with collaboration groups?" action="share" controller="share" 
params="[id:analysis.id,name:'analysis',type:'SAVED_ANALYSIS',keepThis:'true',TB_iframe:'true',height:'375',width:'450',title:'someTitle']"><img alt="share list" style="height: 18px;padding-right:20px" src="${createLinkTo(dir: 'images', file: 'share.png')}" border="0"/></a></g:link>
					</g:if>	
				<g:if test="${(analysis.query?.geAnalysisId?.toString() == 'null')}">
					&nbsp;
				</g:if>
				<g:else>
				<g:link onclick="return confirm('Are you sure?');" action="delete" id="${analysis.id}">
				<img alt="Delete Analysis" border="0" title="Delete Analysis" style="vertical-align: bottom;" src="${createLinkTo(dir: 'images', file: 'cross.png')}"/></g:link>
				</g:else>
				
				</div>
				</g:if>
				<g:else>
				<div style="border:0px solid black;width:50%;float:right">	
					Shared by: ${analysis.author.firstName}&nbsp;${analysis.author.lastName}&nbsp;(author)
				</div>
				</g:else>
				</g:else>
				
				
		</div>	
		</div>
	</div><br />
	<div style="display:block;text-align:left;border-bottom:1px solid grey;background-color:#f3f3f3;padding-bottom:5px">
		<g:if test="${analysis.studies.size()>0}">
		Studies: ${analysis.studyNames().join(", ")}<br/>
		</g:if>
		<g:if test="${analysis.groups}">
		Groups: 
			${analysis.groups.join(", ")}<br/>
		</g:if>
		<g:if test="${analysis.tags.size()>0}">
		<g:if test="${analysis.tags.contains('_temporary')}">
			<span style="color:red;padding:3px">NOTE: This analysis was created via the G-DOC QuickStart and will be removed when you log out of this session.</span>
		</g:if>
		<g:else>
		${analysis.tags[2]}
		Tags: ${analysis.tags.join(", ")}
		</g:else>
	
		
		
	</div>
	
	<br/>
	</g:if>
	</td>
	</tr>

	
</g:each>
</table>