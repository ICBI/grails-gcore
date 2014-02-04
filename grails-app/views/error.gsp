<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'reset.css')}"/>
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

    <script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'analytics.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap.min.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js',  file: 'bootstrap-select.min.js')}"></script>
    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
    <g:javascript library="jquery"/>
    <style type="text/css">
    html, body {height: 100%;}
    </style>
</head>
<body>


<g:set var="activePage" value="${params.controller}" />
<div class="wrapper1" >
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
            </sec:ifLoggedIn>
            <!-- Header end -->
        </div>
    </div>

    <div id="doc2" class="yui-t1">
        <div id="bd" style="padding-bottom:20px" >
            <div id="yui-main" >
                <br/><br/><br/><br/><br/><br/>
                <div class="yui-u first">
                    <div><img src="${createLinkTo(dir: 'images',  file: 'error.gif')}" border="0" alt="" />
                        <div class="desc"> Error.</div>
                        <div class="desc1">We are sorry, a system error has occurred. Please try again!</div>
                    </div><br /><br/>
                    <div id="details" style="display: none;">
                        <g:if test="${exception}">
                            <h2>Stack Trace</h2>
                            <div class="stack">
                                <pre><g:each in="${exception.stackTraceLines}">${it.encodeAsHTML()}<br/></g:each></pre>
                            </div>
                        </g:if>
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