
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
    <title><g:layoutTitle /></title>
		<%--link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'reset.css')}"/--%>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/cupertino',  file: 'jquery-ui-1.7.1.custom.css')}" />
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'grids.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'thickbox.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styles.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.tooltip.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'superfish.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'superfish-vertical.css')}"/>			
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styledButton.css')}" />
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'tags.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.autocomplete.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap-select.min.css')}"/>
		<g:javascript library="jquery" plugin="jquery"/>
		<g:layoutHead/>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'analytics.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap.min.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap-select.min.js')}"></script>
		
</head>
<body style="background-color:#334477; padding: 50px">
	
<g:set var="activePage" value="${params.controller}" /> 
<div id="doc2" class="yui-t1">
	<div id="hd">
		<!-- Header start -->
    <g:render template="/common/header" />
    <!-- Header end -->
	</div>
	<div class="c" style="background:#fff;border:1px solid #000;padding:3px; float: left">
	<div id="bd" style="float: left; width: 100%">
		<div style="padding-left: 10%; padding-right: 10%; float: left; width: 80%">
			<g:layoutBody/><br />
		</div>
	</div>
	<div id="ft" style="float: left; height: 100%; width: 100%">
		<!-- Footer start -->
    <g:render template="/common/footer" />
    <!-- Footer end -->
	</div>
	</div>
</div>
<g:javascript>
// code to set height of left bar

$(window).load(function(){
$('#navigation').height($('#yui-main').height());
})
</g:javascript>
</body>
</html>