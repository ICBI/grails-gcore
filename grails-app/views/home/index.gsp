<html>
    <head>
        <title>${appLongName()}</title>
		<g:render template="/common/flex_header" plugin="gcore"/>
		<g:javascript src="swfobject.js"/>
		<meta name="layout" content="splash" />
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<g:javascript src="deployJava.js" />
		<g:javascript src="BrowserDetect.js"/>
		<g:javascript src="detect.js"/>
		
		<!-- styling -->
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'scrollable-navig.css')}"/>
		<style media="screen" type="text/css">#flashContent {visibility:hidden}#flashContent {display:block;text-align:left;}</style>
		<g:javascript>
			$(document).ready(function(){
						$("[class*='info']").each(function(index){
							$(this).tooltip({showURL: false});
						});
						
						$("[class*='sel']").each(function(index){
							$(this).css('cursor','pointer');
							var part = $("[class*='parts']").eq(index);
							$(this).click(function() {
								
							  	$("[class*='parts']").each(function(index){
								 $(this).css('display','none');
								});
								$("[class*='sel']").each(function(index){
								 $(this).css('border-right','1px solid #334477');
								 $(this).css('background-color','#EBF1FF');
								});
							  	$(this).css('background-color','#fff');
								$(this).css('border-right','0px');
							  	part.css('display','block');
							});
							$(this).hover(function(){
								var color = $(this).css('background-color');
								if(color == 'rgb(255, 255, 255)'){
									$(this).css('background','#fff');
								}else{
									$(this).css('background','#EBF1FF');
								}
							});
							$(this).mouseleave(function(){
								var color = $(this).css('background-color');
								if(color == 'rgb(255, 255, 255)'){
									$(this).css('background','#fff');
								}else{
									$(this).css('background','#EBF1FF');
								}
								
							});
							
						});
						
			});
		
		</g:javascript>
		
    </head>
    <body>
				<jq:plugin name="ui"/>
				
				<br/>
					<g:render template="/home/splashPiece" />

				<div id="centerContent" class="welcomeTitle" style="margin:20px">
					<g:if test="${((flash.cmd instanceof RegistrationCommand) || (flash.cmd instanceof ActivationCommand) || (flash.cmd instanceof ResetPasswordCommand)) && flash.message}">
						<div class="message" style="width:65%;margin:0 auto;">${flash.message}</div>
					</g:if>
					<g:if test="${!(flash.cmd instanceof LoginCommand) && flash.error}">
						<div class="errorDetail" style="width:65%;margin:0 auto;">${flash.error}</div>
					</g:if>
					<br/>
					
					<table border="0" style="width:900px;margin:auto">
						<tr>
							<td valign="top" style="width:45%">
							<table class="sumTable" border="1" style="font-size:.9em" id="patientsTable">
								<th colspan="5" style="padding:8px 8px 8px 8px;background-color:#EBF1FF">Cancer/Study Overview</th>
								<tr style="padding:4px 4px 4px 4px;background-color:#f2f2f2">
									<td><g:message code="home.disease" /></td>
									<td><g:message code="home.study" /></td>
									<td><g:message code="home.patients" /></td>
									<td><g:message code="home.biospecimens" /></td>
									<td><g:message code="home.availableData" /></td>
									<g:if test="${diseaseBreakdown}">
									<g:each in="${diseaseBreakdown}" var="item">
											<tr>
											<td>${item.key}</td>
											<td>${item.value.studyNumber}</td>
											<td>${item.value.patientNumber}</td>
											<td>${item.value.biospecimenNumber}</td>
											<td>
												<g:each in="${item.value.availableData}" var="nameAndImage">
													<g:each in="${nameAndImage}" var="n">
														<g:if test="${n.key != 'BIOSPECIMEN' && n.key != 'CELL_LINE'}">
														<g:set var="okey" value="${n.key}" />
														<g:if test="${n.key == 'REPLICATE'}">
															<g:set var="okey" value="CELL LINE" />
														</g:if>
														<img src="${resource(dir: 'images', file: okey.replace(" ","_") + '_icon.gif')}" alt="${okey}" class="info" title="${okey}" />	
														</g:if>
													</g:each>
												</g:each>
											</td>
											</tr>
									</g:each>
									</g:if>
									<g:else>
										<tr>
											<td><g:message code="home.errorService" /></td>
										</tr>
									</g:else>
								</tr>
							</table>	
							</td>
							<td valign="top" rowspan="2" style="width:450px">
									<div style="display:block;margin-left:30px;">
										<table border="0" cellspacing="0">
											<tr>
											<td style="width:10%;" valign="top">
												<div class="sel" style="padding:25px;border-top:1px solid #334477;border-right:0px;border-left:1px solid #334477;background-color:#fff"><g:message code="home.findings" /></div>
												<div class="sel" style="padding:25px;border-top:1px solid #334477;border-right:1px solid #334477;border-left:1px solid #334477;background-color:#EBF1FF"><g:message code="home.news" /></div>
												<div class="sel" style="padding:25px;border-top:1px solid #334477;border-right:1px solid #334477;border-left:1px solid #334477;background-color:#EBF1FF;border-bottom:1px solid #334477;"><g:message code="home.publications" /></div>
												<div style="height:150px;border-right:1px solid #334477"></div>
											</td>

											<td rowspan="3" valign="top">
												<div id="findings" class="parts" style="padding:15px;border-bottom:1px solid #334477;height:330px;border-right:0px solid #334477;height:330px;border-top:1px solid #334477;height:330px;overflow: scroll;">
													<div class="partDiv">
													<g:if test="${findings}">
													<g:each in="${findings}" var="finding">
														<p style="border-bottom:1px dashed black;padding:2px">${finding.title}&nbsp; - <span style="color:blue"><g:message code="home.loadedOn" />: <g:formatDate format="EEE MMM d, yyyy" date="${finding.dateCreated}"/></span></p>
													</g:each>
													</g:if>
													</div>
												</div>
												
												<div id="news" class="parts" style="padding:15px;border-bottom:1px solid #334477;height:330px;border-right:1px solid #334477;height:330px;border-top:1px solid #334477;height:330px;overflow: scroll;display:none">
													<div class="partDiv">
													<g:if test="${newsFeedMap}">
													<g:each in="${newsFeedMap}" var="feedItem">
														<p><a href="${feedItem.value}" target="_blank">${feedItem.key}</a></p>
													</g:each>
													</g:if>
													<g:else>
													<g:message code="home.noFeedMessage" />
													</g:else>
													</div>
												</div>
												
												<div id="pub" class="parts" style="padding:15px;border-bottom:1px solid #334477;height:330px;border-right:1px solid #334477;height:330px;border-top:1px solid #334477;height:330px;overflow: scroll;display:none">
													<div class="partDiv">
														<g:if test="${pubFeedMap}">
														<g:each in="${pubFeedMap}" var="feedItem">
															<p><a href="${feedItem.value}" target="_blank">${feedItem.key}</a></p>
														</g:each>
														</g:if>
														<g:else>
														<g:message code="home.noPubFeedMessage" />
														</g:else>
													</div>
												</div>
											</td>
											</tr>



										</table>

									</div>
							</td>
						</tr>
						<tr>
							<td valign="top" style="padding-top:15px">
							<table class="sumTable" border="1" style="font-size:.9em" id="patientsTable">
								<th colspan="4" style="padding:8px 8px 8px 8px;background-color:#EBF1FF">Data-Type Overview</th>
								<tr style="padding:4px 4px 4px 4px;background-color:#f2f2f2">
									<td><g:message code="home.dataType" /></td>
									<td><g:message code="home.study" /></td>
									<g:if test="${dataBreakdown}">
									<g:each in="${dataBreakdown}" var="data">
											<g:if test="${data.key != 'BIOSPECIMEN' && data.key != 'CELL LINE'}">
											<g:set var="key" value="${data.key}" />
											<g:if test="${data.key == 'REPLICATE'}">
												<g:set var="key" value="CELL LINE" />
											</g:if>
											<tr>
											<td>
												<div valign="top" style="text-align:top">${key} &nbsp;&nbsp;<img src="${resource(dir: 'images', file: key.replace(" ","_") + '_icon.gif')}" alt="${key}" style="margin-bottom:-5px" class="info" title="${key}"/></div></td>
											<td>${data.value}</td>
											</tr>
											</g:if>
									</g:each>
									</g:if>
									<g:else>
										<tr>
											<td><g:message code="home.errorService" /></td>
										</tr>
									</g:else>
								</tr>
							</table>	
							</td>
								
						</tr>	
					
						
						</tr>
						
						
						</table>	
							
							<script type="text/javascript">
									jQuery(document).ready(function() {
										$("#samplesTable").Scrollable(125, 250);
									});
							 	</script>
					
							
							
						
				
					
					
					
				</div>
				
				
				
    </body>
</html>