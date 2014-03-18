<STYLE type="text/css">
A:link {color:#336699}
A:visited {color:#336699}
A:hover {color:#334477}
</style>
<div style="border-top:1px solid #F0F0F0; width:1015px; margin-left:auto;margin-right:auto;">


<div class="social-media-content" style="border:0px solid black; margin-top:10px;" >
    <span style="border:0px solid black;float:right;padding-right:20px;">
        <a href="https://twitter.com/ICBI_Georgetown" target="_blank">
            <img src="${createLinkTo(dir:'images',file:'Twitter.png')}" border="0" alt=""/>
        </a>
    </span>

    <span style="border:0px solid black;float:right;padding-right:20px">
        <a href="https://www.facebook.com/pages/ICBI-Innovation-Center-for-Biomedical-Informatics-Georgetown-University/630799513616357" target="_blank">
            <img src="${createLinkTo(dir:'images',file:'facebook.png')}" border="0" alt=""/>
        </a>
    </span>

    <span style="border:0px solid black;float:right;padding-right:20px">
        <a href="http://www.linkedin.com/groups/ICBI-4521527" target="_blank">
            <img src="${createLinkTo(dir:'images',file:'LinkedIn.png')}" border="0" alt=""/>
        </a>
    </span>
</div>

 <div class="copyright">
		<span size="6" style="vertical-align:20px;font-size: 10px; font-family:'open sans',Helvetica,sans-serif; color: rgb(153, 153, 153);border:0px solid black"> Copyright © 2014 ICBI. All Rights Reserved &nbsp;&nbsp;&nbsp;&nbsp;
			${g.appTitle()} ${g.appVersion()}
            &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="${createLink(controller: 'home', action: 'releaseNotes')}" ><g:message code="common.footer.releaseNotes" /></a>
			&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="https://github.com/ICBI" target="_blank" >powered by G-CODE</a>
            &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="http://lombardi.georgetown.edu/gdoc/" target="_blank">${g.appTitle()} <g:message code="common.footer.lcccLink" /></a>
        </span>

		 <br/>
                <span size="6" style="vertical-align:40px;font-size: 10px; font-family:'open sans',Helvetica,sans-serif; color: rgb(0, 92, 167);border:0px solid black">
                		<a href="${createLink(controller: 'home', action: 'requirementCheck')}" target="_blank"><g:message code="common.footer.systemReqs" /></a>  &nbsp; |&nbsp;&nbsp;
                		<a href="${createLink(controller: 'policies', action: 'publication')}"><g:message code="common.footer.publicationPolicy" /></a> &nbsp;&nbsp; |&nbsp;&nbsp;
                        <a href="${createLink(controller: 'policies', action: 'citations')}"><g:message code="common.footer.citations" /></a> &nbsp;&nbsp; |&nbsp;&nbsp;
                		<a href="${createLink(controller: 'policies', action: 'dataAccess')}"><g:message code="common.footer.dataAccessPolicy" /></a>  &nbsp; |&nbsp;&nbsp;
                		<a href="${createLink(controller: 'policies', action: 'licenses')}"><g:message code="common.footer.licenseInfo" /></a> &nbsp;&nbsp; |&nbsp;&nbsp;
                		<g:link controller="contact"><g:message code="common.footer.contactUs" /></g:link> &nbsp; |&nbsp;&nbsp;
                		<g:link controller="home" action="team">${g.appTitle()} <g:message code="common.footer.team" /></g:link>
                </span>

 </div>


<div id="footerlogoscontainer">
    <div class="footerlogos">
            <a href="http://lombardi.georgetown.edu/" target="_blank">
                <img src="${createLinkTo(dir:'images', file:'lombardi_logo.png')}"  style="border:0px solid black; float:left; height: 40px; width:120px;"/>
            </a>
    </div>
    <div class="footerlogos" style="text-align:center;">
        <a href="http://www.georgetown.edu/" target="_blank">
            <img src="${createLinkTo(dir:'images',file:'GU_logo.png')}"  alt="${message(code: 'common.footer.guLogoAlt')}" style="height: 45px; "/>
        </a>
    </div>
    <div class="footerlogos" style="float:right;">
        <a href="http://gumc.georgetown.edu/" target="_blank">
            <img src="${createLinkTo(dir:'images',file:'gumc.png')}" style="float:right;width:200px;" alt="${message(code: 'common.footer.gumcLogoAlt')}" />
        </a>
    </div>
</div>

</br>
</div>

