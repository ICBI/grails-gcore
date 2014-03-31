
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
        <link rel="shortcut icon" href="${createLinkTo(dir: 'images',  file: 'favicon.ico')}" type="image/icon"><link rel="icon" href="${createLinkTo(dir: 'images',  file: 'favicon.ico')}" type="image/icon">
		<g:layoutHead/>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'analytics.js')}"></script>
		
</head>
<body>

<g:set var="activePage" value="${params.controller}" />

<g:render template="/common/headerNoNavBar" />


<div id="bd" style="min-height:400px;">
		<div id="yui-main"  >
		    <div id="doc2" class="yui-t1" style="background-color:white;">
			    <g:layoutBody/>
			</div>
		</div>
</div>

<div id="ft" style="border-top:1px solid #F0F0F0; height: 100%; width: 100%;background:none repeat scroll 0% 0% rgb(245, 245, 245);" >
		<!-- Footer start -->
		     <div id="doc2" class="yui-main" style="background-color:rgb(245, 245, 245);">
            <g:render template="/common/footer" />
            </div>
        <!-- Footer end -->
</div>

<g:javascript>
$('.c').css('background-color', '#ffffff');
// code to set height of left bar

</g:javascript>
</body>
</html>