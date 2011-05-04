						<table border="0" width="100%">
							<tr>
								<td colspan="4" class="titleBar">
									<p style="margin-top:4px;color:#336699"><g:message code="workflows.features" /></p>
								</td>
							</tr>
								<tr style="color:#336699;border-bottom:1px solid #336699;" valign="top">
									<td>
										<p class="info" title="${message(code: 'workflows.searchTip', args: [appTitle()])}" style="font-size:1.1em;text-decoration:underline;padding-top:0px;padding-left:25px;cursor:pointer;"><g:message code="workflows.search" /></p>
										<img src="${createLinkTo(dir:'images',file:'searchIcon.png')}" border="0" />
									</td>
									<td>
										
											<p style="font-size:.8em;margin-top:10px">
											<g:searchLinks/>
											</p><br />
									</td>
									<td>
										<p class="info" title="${message(code: 'workflows.analysisTip')}" style="font-size:1.1em;text-decoration:underline;padding-top:0px;padding-left:22px;cursor:pointer"><g:message code="workflows.analyze"/></p>
										<img src="${createLinkTo(dir:'images',file:'analysisIcon.png')}" border="0" />
									</td>
									<td>
											<p style="font-size:.8em;margin-top:10px">
											<g:analysisLinks/>
											</p>
									</td>
								</tr>
								<tr style="color:#336699" valign="top">
									<td>
										<p class="info" title="${message(code: 'workflows.myTip')}" style="font-size:1.1em;text-decoration:underline;padding-top:7px;padding-left:15px;cursor:pointer"><g:message code="workflows.my" args="${ [appTitle()] }" /></p>
										
										<img src="${createLinkTo(dir:'images',file:'myGdoc.png')}" border="0" />
									</td>
									<td>
										<p style="font-size:.8em;margin-top:20px">
<g:link controller="notification" style="color:#336699;"><g:message code="workflows.notifications"/></g:link><br /><br />
<g:link name="View My Saved Lists" controller="userList" style="color:#336699;"><g:message code="workflows.savedLists"/></g:link><br /><br />
<g:link name="View My Saved Analysis" controller="savedAnalysis" style="color:#336699;"><g:message code="workflows.savedAnalysis"/></g:link><br /><br />
<g:link name="Collaboration Groups" controller="collaborationGroups" style="color:#336699;x"><g:message code="workflows.manage"/></g:link>
		</p>
									</td>
								</tr>
						</table>
