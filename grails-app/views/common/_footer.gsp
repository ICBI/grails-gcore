<STYLE type="text/css">
A:link {color:#336699}
A:visited {color:#336699}
A:hover {color:#334477}
</style>
<div style="-moz-border-radius: 5px;border-radius: 5px;background: #f2f2f2 url(/${g.appName()}/images/border_bottom.gif) top repeat-x; width: 100%; float: left" align="center"><br />
	<div style="border:0px solid black">
		<span size="6" style="vertical-align:20px;font-size: 11px; font-family: arial,helvetica,sans-serif; color: #1c2674;border:0px solid black">
			${g.appTitle()} ${g.appVersion()}&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="${createLink(controller: 'home', action: 'releaseNotes')}" ><g:message code="common.footer.releaseNotes" /></a>
			&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;powered by G-CODE</span>

	</div>
	
	<span size="6" style="vertical-align:40px;margin-right:20px;margin-left:20px;font-size: 10px; font-family: arial,helvetica,sans-serif; color: #1c2674;border:0px solid black">
		<a href="http://lombardi.georgetown.edu/gdoc/" target="_blank">${g.appTitle()} <g:message code="common.footer.lcccLink" /></a>  &nbsp; |&nbsp;&nbsp; 
		<a href="${createLink(controller: 'home', action: 'requirementCheck')}" target="_blank"><g:message code="common.footer.systemReqs" /></a>  &nbsp; |&nbsp;&nbsp; 
		<a href="${createLink(controller: 'policies', action: 'publication')}"><g:message code="common.footer.publicationPolicy" /></a> &nbsp;&nbsp; |&nbsp;&nbsp; 
		<a href="${createLink(controller: 'policies', action: 'dataAccess')}"><g:message code="common.footer.dataAccessPolicy" /></a>  &nbsp; |&nbsp;&nbsp; 
		<a href="${createLink(controller: 'policies', action: 'licenses')}"><g:message code="common.footer.licenseInfo" /></a> &nbsp;&nbsp; |&nbsp;&nbsp; 
		<g:link controller="contact"><g:message code="common.footer.contactUs" /></g:link> &nbsp; |&nbsp;&nbsp; 
		<g:link controller="home" action="team">${g.appTitle()} <g:message code="common.footer.team" /></g:link>
	</span><br />

<span style="border:0px solid black; float:left; padding-left:100px; height: 55px; width:149px;">	
		<a href="http://lombardi.georgetown.edu/" target="_blank">
			<img src="${createLinkTo(dir:'images', file:'lombardi_logo.png')}">
		</a>
</span>

<span style="border:0px solid black">
	<a href="http://www.georgetown.edu/" target="_blank">	
		<img src="${createLinkTo(dir:'images',file:'GU_logo.png')}" border="0" alt="${message(code: 'common.footer.guLogoAlt')}"/>
	</a>
</span>

<span style="border:0px solid black;float:right;padding-right:100px">
	<a href="http://gumc.georgetown.edu/" target="_blank">
		<img src="${createLinkTo(dir:'images',file:'gumc.png')}" border="0" style="height:20px;width:220px" alt="${message(code: 'common.footer.gumcLogoAlt')}"/>
	</a>
</span>


</div>
