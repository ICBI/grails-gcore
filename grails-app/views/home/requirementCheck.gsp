<html>
    <head>
        <title>${appLongName()}</title>
		<g:javascript src="swfobject.js"/>
		<g:javascript src="BrowserDetect.js"/>
		<g:javascript src="detect.js"/>
		<meta name="layout" content="noHeaderLayout" />
		<g:javascript library="jquery" plugin="jquery"/>

		<!-- styling -->
		<g:javascript>
			$(document).ready(function() {

				var browserData = checkBrowser();
				passCheck($('#browserPass'), browserData[0]);
				$('#browserVersion').text(browserData[1]);
				var flashData = checkFlash();
				passCheck($('#flashPass'), flashData[0]);
				$('#flashVersion').text(flashData[1]);
				var javaData = checkJava();
				passCheck($('#javaPass'), javaData[0]);
				$('#javaVersion').text(javaData[1]);
				$('#javaLink').click(function() {
					deployJava.installLatestJRE();
					return false;
				});

                //Warning message for Java 7 and Chrome on Mac OS X and Linux
                var OSName  = detectOS();
                var browser = get_browser();
                var testJava = detectJava();
                if ((OSName == 'MacOS' || OSName == 'Linux' || OSName == 'UNIX') && browser == 'Chrome' && testJava[1] =='' )
                {
                    document.getElementById("chrome-on-mac-warning").innerHTML='<div class="well desc">You have '+browser +' running on '+OSName +'. '+
                            'Currently Chrome does not support Java 7 (and higher) on the Mac or Linux platforms.  A 64-bit browser (Firefox, for example) is required to run Java 7 on Mac OS X. '
                            +'For more info visit this link: <a href="http://www.java.com/en/download/faq/chrome.xml">Java Website FAQ</a></div> '
                    ;
                    document.getElementById("requirements").style.display = "none"
                }
			});

			
			function passCheck(item, pass) {
				if(pass) {
					$(item).find('.fail').hide();
					$(item).find('.pass').show();
				} else {
					$(item).find('.pass').hide();
					$(item).find('.fail').show();
				}
			}


		</g:javascript>
    </head>
    <body>
        <jq:plugin name="ui"/>
        <g:javascript src="deployJava.js"/>

        <div class="welcome-title">
            <g:message code="home.reqCheckHeading" args="${[appTitle()]}"/>
        </div>


        <br/>
        <br/>


        <table class="checkTable table" border="1" id="requirements" style="margin:auto; font-size: 1.0em">
            <tr style="padding:4px 4px 4px 4px;background-color:#f2f2f2">
                <td><g:message code="home.required" /></td>
                <td><g:message code="home.yourComputer" /></td>
                <td><g:message code="home.pass" /></td>
                <td><g:message code="home.download" /></td>
            </tr>
            <tr>
                <td><g:message code="home.browsers" /></td>
                <td><div id="browserVersion"></div></td>
                <td>
                    <div id="browserPass" align="center">
                        <img src="${createLinkTo(dir: 'images', file: 'accept.png')}" alt="${message(code: 'home.passAlt')}" style="display:none" class="pass"/>
                        <img src="${createLinkTo(dir: 'images', file: 'cancel.png')}" alt="${message(code: 'home.failAlt')}" class="fail"/>
                    </div>
                </td>
                <td>
                    <a href="http://www.mozilla.com/firefox" target="_blank"><g:message code="home.firefox" /></a><br/>
                    <a href="http://www.google.com/chrome/" target="_blank"><g:message code="home.chrome" /></a>
                </td>
            </tr>
            <tr>
                <td><g:message code="home.flashVersion" /></td>
                <td><div id="flashVersion"></div></td>
                <td><div id="flashPass" align="center">
                    <img src="${createLinkTo(dir: 'images', file: 'accept.png')}" alt="${message(code: 'home.passAlt')}" style="display:none" class="pass"/>
                    <img src="${createLinkTo(dir: 'images', file: 'cancel.png')}" alt="${message(code: 'home.failAlt')}" class="fail"/>
                </div></td>
                <td><a href="http://get.adobe.com/flashplayer/" target="_blank"><g:message code="home.flash" /></a></td>
            </tr>
            <tr>
                <td><g:message code="home.javaVersion" /></td>
                <td><div id="javaVersion"></div></td>
                <td><div id="javaPass" align="center">
                    <img src="${createLinkTo(dir: 'images', file: 'accept.png')}" alt="${message(code: 'home.passAlt')}" style="display:none" class="pass"/>
                    <img src="${createLinkTo(dir: 'images', file: 'cancel.png')}" alt="${message(code: 'home.failAlt')}" class="fail"/>
                </div></td>
                <td><a href="#" id="javaLink" target="_blank"><g:message code="home.java" /></a></td>
            </tr>
        </table>
    <br/>

    <div id="chrome-on-mac-warning"></div>

    </body>
</html>