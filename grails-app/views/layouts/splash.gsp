
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
		<g:layoutHead/>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'analytics.js')}"></script>
		
</head>
<body style="background-color:#334477">
		
<g:set var="activePage" value="${params.controller}" /> 
<div id="doc2" class="yui-t1" style="border:0px solid black;">
	<div id="hd">
		<!-- Header start -->
    <g:render template="/common/headerNoNavBar" />
    <!-- Header end -->
	</div>
	<div class="c" style="border:1px solid #000;padding:3px; float: left; width: 100%">
	<div id="bd" style="min-height:400px;">
		<div id="yui-main">			
			<g:layoutBody/>					
		</div>
	</div>
	<div id="ft" style="float: left; height: 100%; width: 100%">
		<!-- Footer start -->
    <g:render template="/common/footer" />
    <!-- Footer end -->
	</div>
	</div>
	<br />
</div>
<g:javascript>
$('.c').css('background-color', '#ffffff');
// code to set height of left bar

</g:javascript>
</body>
</html>