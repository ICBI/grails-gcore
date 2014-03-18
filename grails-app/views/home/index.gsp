<html>
    <head>
        <title>${appLongName()}</title>
		<g:render template="/common/flex_header" plugin="gcore"/>
		<meta name="layout" content="splash" />
		<g:javascript src="swfobject.js"/>
		<g:javascript library="jquery" plugin="jquery"/>
		<g:javascript src="jquery/scrollTable/scrolltable.js"/>
		<g:javascript src="jquery/scrollTable/jscrolltable.js"/>
		<g:javascript src="jquery/jquery-min.js"/>
		<g:javascript src="jquery/jquery.slidorion.js"/>
		<g:javascript src="jquery/jquery.easing.js"/>

		<g:javascript src="BrowserDetect.js"/>
		<g:javascript src="detect.js"/>
		<g:javascript src="bootstrap-select.min.js"/>
        <g:javascript src="bootstrap.min.js"/>
        <g:javascript src="rss-script.js"/>


		<!-- styling -->
        <style>
        @font-face {
            font-family: 'Open Sans';
            font-style: normal;
            font-weight: 300;
            src: local('Open Sans Light'), local('OpenSans-Light'), url(https://themes.googleusercontent.com/static/fonts/opensans/v7/DXI1ORHCpsQm3Vp6mXoaTXhCUOGz7vYGh680lGh-uXM.woff) format('woff');
        }
        </style>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'gdocdata.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'scrollable-navig.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'navBar.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'slidorion.css')}"/>




		<g:javascript>
			$(document).ready(function(){
			            ShowHideReq("Req");
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
			$(function() {
				$('#slidorion').slidorion({
					interval: 4000,
					controlNav: true,
					effect: 'random',
					hoverPause: true
				});
			});
		</g:javascript>

    </head>
    <body>
			<jq:plugin name="ui"/>

            <g:render template="/home/splashPiece" plugin="gcore"/>

				<div id="centerContent" class="welcomeTitle" style="margin:20px">
					<g:if test="${((flash.cmd instanceof RegistrationCommand) || (flash.cmd instanceof ActivationCommand) || (flash.cmd instanceof ResetPasswordCommand)) && flash.message}">
						<div class="message" style="width:65%;margin:0 auto;">${flash.message}</div>
					</g:if>
					<g:if test="${!(flash.cmd instanceof LoginCommand) && flash.error}">
						<div class="errorDetail" style="width:65%;margin:0 auto;">${flash.error}</div>
					</g:if>
					<br/>

                <div style="display:block;margin-left:1px;float:right;" valign="top">
                    <div style="display:block;margin-left:40px; margin-bottom:60px">
                        <div id="feedWidget">

                            <div id="activeTab">
                                    <!-- The name of the current tab is inserted here -->
                                </div>

                                <div class="line"></div>

                                <div id="tabContent">
                                    <!-- The feed items are inserted here -->
                                </div>
                            </div>
                    </div>
                </div>


                </br>
                <h2>Understanding Data in G-DOC Plus</h2>
                <h4>It all begins with a study...</h4>
                </br>
                <p>All data in G-DOC Plus derives from studies on topics such as breast cancer, wound healing, or even 1,000 Genomes. Each study may contain clincal and/or biospecimen data. Below is an overview of studies by topic. <sup>*</sup></p>
                <p class="footprint">* private studies, ones which are uploaded and marked private, are not counted here</p>
                </br>
                <ul class="studytype">
                    <g:if test="${diseaseBreakdown}">
                        <g:each in="${diseaseBreakdown}" var="item">
                        		<g:if test="${item.key == '<i>Total</i>'}">
                        			<li style="background-color: #D9D9D9;">
                        		</g:if>
                        		<g:else>
                        			<li>
                        		</g:else>
                                    <span class="studytypename">${item.key}</span>
                                    <span class="patientcount count"><i>patients</i> <b>${item.value.patientNumber}</b> </span>
                                    <span class="biospecimencount count"><i>biospecimens</i><b>${item.value.biospecimenNumber}</b></span>
                                    <span class="studycount count"> <i>studies</i><b>${item.value.studyNumber}</b></span>
                                </li>

                        </g:each>
                    </g:if>
                </ul>


                <script type="text/javascript">
                        jQuery(document).ready(function() {
                            $("#samplesTable").Scrollable(125, 250);
                        });
                    </script>
                  <g:javascript src="deployJava.js" />
				</div>
    </body>
</html>