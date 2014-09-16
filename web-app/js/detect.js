function checkBrowser() {
	var browser = ""
	var browserPass = false;
    /*if(BrowserDetect.browser == 'Explorer') {
		if(jQuery.browser.version >= 8)
			browserPass = true
		else 
			browserPass = false
		browser = "Internet Explorer " + jQuery.browser.version;
	} else */if(BrowserDetect.browser == 'Firefox') {
		if(BrowserDetect.version >= 3.5) {
			browserPass = true;
		} else { 
			browserPass = false;
		}
		browser = "Mozilla Firefox " + BrowserDetect.version;
	} else if (BrowserDetect.browser == 'Chrome') {
		browserPass = true
		browser = BrowserDetect.browser + " " + BrowserDetect.version;
	} else { 
		browser = BrowserDetect.browser + " " + BrowserDetect.version;
		browserPass = false;
	}
	return [browserPass, browser];
}

function checkFlash() {
	var flashPass = false;
	if(swfobject.getFlashPlayerVersion().major >= 10)
		flashPass = true;
	return [flashPass, "Flash " + swfobject.getFlashPlayerVersion().major + "." + swfobject.getFlashPlayerVersion().minor];
}

function checkJava() {
	var javaPass = deployJava.versionCheck("1.6.0+");
	return [javaPass, "Java version(s): " + deployJava.getJREs().join(", ")];
}
function detectJava() {
    var javaPass = deployJava.versionCheck("1.7.0+");
    return [javaPass, deployJava.getJREs().join(", ")];
}

function detectOS(){
    var OSName="Unknown OS";
    if (navigator.appVersion.indexOf("Win")!=-1) OSName="Windows";
    if (navigator.appVersion.indexOf("Mac")!=-1) OSName="MacOS";
    if (navigator.appVersion.indexOf("X11")!=-1) OSName="UNIX";
    if (navigator.appVersion.indexOf("Linux")!=-1) OSName="Linux";
    return OSName;
}

function get_browser(){
    var ua=navigator.userAgent,tem,M=ua.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [];
    if(/trident/i.test(M[1])){
        tem=/\brv[ :]+(\d+)/g.exec(ua) || [];
        return 'IE';
    }
    if(M[1]==='Chrome'){
        tem=ua.match(/\bOPR\/(\d+)/)
        if(tem!=null)   {return 'Opera'}
    }
    M=M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
    if((tem=ua.match(/version\/(\d+)/i))!=null) {M.splice(1,1,tem[1]);}
    return M[0];
}


function checkBrowserPass() {
	var browser = ""
	var browserPass = false;
	/*if(BrowserDetect.browser == 'Explorer') {
		if(jQuery.browser.version >= 8)
			browserPass = true
		else
			browserPass = false
		browser = "Internet Explorer " + jQuery.browser.version;
	} else */if(BrowserDetect.browser == 'Firefox') {
		if(BrowserDetect.version >= 3.5) {
			browserPass = true;
		} else {
			browserPass = false;
		}
		browser = "Mozilla Firefox " + BrowserDetect.version;
	} else if (BrowserDetect.browser == 'Chrome') {
		browserPass = true
		browser = BrowserDetect.browser + " " + BrowserDetect.version;
	} else {
		browser = BrowserDetect.browser + " " + BrowserDetect.version;
		browserPass = false;
	}
	return browserPass
}

function checkFlashPass() {
	var flashPass = false;
	if(swfobject.getFlashPlayerVersion().major >= 10)
		flashPass = true;
	return flashPass
}

function checkJavaPass() {
	var javaPass = deployJava.versionCheck("1.6.0+");
	return javaPass
}

function ShowHideReq(id) {
    if (checkJavaPass()&&checkBrowserPass()&&checkFlashPass()) {
    document.getElementById(id).style.display = 'none';
    }
    else {
    document.getElementById(id).style.display = 'block';
    }
    }
