
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
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'styledButton.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'tags.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'editableText.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.autocomplete.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
		<link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap-select.min.css')}"/>
				
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

    <g:set var="activePage" value="${params.controller}" />

    <div class="wrapper1" >
                  <div class="header">
                             <div id="doc2" class="yui-t1">
                             <br/>
                                 <!-- Header start -->
                                 <g:render template="/common/headerWorkflow" />
                                 <!-- Header end -->
                             </div>
                 </div>

                <div id="doc2" class="yui-t1">
                    <div id="bd" style="padding-bottom:20px;" >
                        <div id="yui-main">
                        <br/><br/>
                                <div class="yui-gc">
                                    <div class="yui-u first"style="width:750px;">
                                        <g:layoutBody/>
                                    </div>
                                    <div class="yui-u" style="width:250px;">
                                        <g:render template="/userList/lists_rightbar" plugin="gcore"/>
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
        <div class="push"></div>
    </div>
    <div class="footer">
       <g:render template="/common/footer" />
    </div>

<g:javascript>
// code to set height of left bar
jQuery(document).ready(function() {
	$('#navigation').height($('#yui-main').height());
});
</g:javascript>
</body>
</html>