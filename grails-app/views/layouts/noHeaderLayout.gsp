
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
    <title><g:layoutTitle /></title>
		<!--link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'reset.css')}"/-->
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'grids.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'thickbox.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.tooltip.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'superfish.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'superfish-vertical.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/cupertino',  file: 'jquery-ui-1.7.1.custom.css')}" />
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styledButton.css')}" />
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'tags.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.autocomplete.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap-select.min.css')}"/>
        <link rel="shortcut icon" href="${createLinkTo(dir: 'images',  file: 'favicon.ico')}" type="image/icon"><link rel="icon" href="${createLinkTo(dir: 'images',  file: 'favicon.ico')}" type="image/icon">
		<g:javascript library="jquery" plugin="jquery"/>
		<g:layoutHead/>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'analytics.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap.min.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap-select.min.js')}"></script>
        <style type="text/css">
             html, body {height: 100%;}
        </style>
</head>
<body>
    <div class="wrapper">
          <div class="header">
                     <div id="doc2" class="yui-t1">

                         <!-- Header start -->
                         <sec:ifNotLoggedIn>
                             <br/>
                             <!-- Header start -->
                             <table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
                                 <a href="/${appName()}"><img src="/${appName()}/images/${appLogo()}" border="0" alt="${message(code: 'header.logoAlt', args: [appTitle()])}" /></a>
                             </td><td valign="bottom" style="text-align:right;padding:7px">
                                 <span style="color:#f2f2f2">
                                     <g:formatDate format="EEE MMM d, yyyy" date="${new Date()}"/><br /><br />
                                     <g:link controller="workflows" style="color:#f2f2f2"> ${message(code: 'nav.home', args: [appTitle()])}</g:link>
                                 </span>

                             </td></tr></table>
                             <!-- Header end -->
                         </sec:ifNotLoggedIn>
                         <sec:ifLoggedIn>
                             <g:render template="/common/headerWorkflow" />
                             <br/>
                         </sec:ifLoggedIn>
                         <!-- Header end -->
                     </div>
         </div>
        <g:set var="activePage" value="${params.controller}" />

        <div id="doc2" class="yui-t1">
            <div id="bd" style="padding-bottom:20px" >
                <div id="yui-main" >
                <br/><br/>
                                <g:layoutBody/>
                </div>
            </div>
        </div>
        <div class="push"></div>
    </div>
    <div class="footer">
       <g:render template="/common/footer" />
    </div>
<g:javascript>
$('.c').css('background-color', '#ffffff');
// code to set height of left bar

</g:javascript>
</body>
</html>