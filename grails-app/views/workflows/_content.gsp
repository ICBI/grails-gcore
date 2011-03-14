						<table border="0" width="100%">
							<tr>
								<td colspan="4" style="height:29px;background: url('/gdoc/images/bgTitles.png') repeat;">
									<p style="margin-top:4px;color:#336699">Features</p>
								</td>
							</tr>
								<tr style="color:#336699;border-bottom:1px solid #336699;" valign="top">
									<td>
										<p class="info" title="Query G-DOC clinial data and save patient lists for use in later analyses (click 'Clinical Data' to the left). Explore data in the genome browser. View details of recent findings." style="font-size:1.1em;text-decoration:underline;padding-top:0px;padding-left:25px;cursor:pointer;">Search</p>
										<img src="${createLinkTo(dir:'images',file:'searchIcon.png')}" border="0" />
									</td>
									<td>
										
											<p style="font-size:.8em;margin-top:10px">
											<g:searchLinks/>
											</p><br />
									</td>
									<td>
										<p class="info" title="Perform high-throughput analyses on cohorts of patients to discover differences among patients in regard to 'omics' data" style="font-size:1.1em;text-decoration:underline;padding-top:0px;padding-left:22px;cursor:pointer">Analyze</p>
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
										<p class="info" title="Manage your lists, analyses and memberships. Share data you've collected and discovered via this collaboration feature." style="font-size:1.1em;text-decoration:underline;padding-top:7px;padding-left:15px;cursor:pointer">My G-DOC</p>
										
										<img src="${createLinkTo(dir:'images',file:'myGdoc.png')}" border="0" />
									</td>
									<td>
										<p style="font-size:.8em;margin-top:20px">
<g:link controller="notification" style="color:#336699;">Notifications</g:link><br /><br />
<g:link name="View My Saved Lists" controller="userList" style="color:#336699;">Saved Lists</g:link><br /><br />
<g:link name="View My Saved Analysis" controller="savedAnalysis" style="color:#336699;">Saved Analysis</g:link><br /><br />
<g:link name="Collaboration Groups" controller="collaborationGroups" style="color:#336699;x">Manage my groups / Request access</g:link>
		</p>
									</td>
								</tr>
						</table>
