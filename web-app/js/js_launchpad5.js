/* Modernizr 2.6.2 (Custom Build) | MIT & BSD
 * Build: http://modernizr.com/download/#-svg-cssclasses
 */
;window.Modernizr=function(a,b,c){function v(a){j.cssText=a}function w(a,b){return v(prefixes.join(a+";")+(b||""))}function x(a,b){return typeof a===b}function y(a,b){return!!~(""+a).indexOf(b)}function z(a,b,d){for(var e in a){var f=b[a[e]];if(f!==c)return d===!1?a[e]:x(f,"function")?f.bind(d||b):f}return!1}var d="2.6.2",e={},f=!0,g=b.documentElement,h="modernizr",i=b.createElement(h),j=i.style,k,l={}.toString,m={svg:"http://www.w3.org/2000/svg"},n={},o={},p={},q=[],r=q.slice,s,t={}.hasOwnProperty,u;!x(t,"undefined")&&!x(t.call,"undefined")?u=function(a,b){return t.call(a,b)}:u=function(a,b){return b in a&&x(a.constructor.prototype[b],"undefined")},Function.prototype.bind||(Function.prototype.bind=function(b){var c=this;if(typeof c!="function")throw new TypeError;var d=r.call(arguments,1),e=function(){if(this instanceof e){var a=function(){};a.prototype=c.prototype;var f=new a,g=c.apply(f,d.concat(r.call(arguments)));return Object(g)===g?g:f}return c.apply(b,d.concat(r.call(arguments)))};return e}),n.svg=function(){return!!b.createElementNS&&!!b.createElementNS(m.svg,"svg").createSVGRect};for(var A in n)u(n,A)&&(s=A.toLowerCase(),e[s]=n[A](),q.push((e[s]?"":"no-")+s));return e.addTest=function(a,b){if(typeof a=="object")for(var d in a)u(a,d)&&e.addTest(d,a[d]);else{a=a.toLowerCase();if(e[a]!==c)return e;b=typeof b=="function"?b():b,typeof f!="undefined"&&f&&(g.className+=" "+(b?"":"no-")+a),e[a]=b}return e},v(""),i=k=null,e._version=d,g.className=g.className.replace(/(^|\s)no-js(\s|$)/,"$1$2")+(f?" js "+q.join(" "):""),e}(this,this.document);

/*!
 * jQuery Cookie Plugin v1.3.1
 * https://github.com/carhartl/jquery-cookie
 *
 * Copyright 2013 Klaus Hartl
 * Released under the MIT license
 */
(function(e){if(typeof define==="function"&&define.amd){define(["jquery"],e)}else{e(jQuery)}})(function(e){function n(e){return e}function r(e){return decodeURIComponent(e.replace(t," "))}function i(e){if(e.indexOf('"')===0){e=e.slice(1,-1).replace(/\\"/g,'"').replace(/\\\\/g,"\\")}try{return s.json?JSON.parse(e):e}catch(t){}}var t=/\+/g;var s=e.cookie=function(t,o,u){if(o!==undefined){u=e.extend({},s.defaults,u);if(typeof u.expires==="number"){var a=u.expires,f=u.expires=new Date;f.setDate(f.getDate()+a)}o=s.json?JSON.stringify(o):String(o);return document.cookie=[s.raw?t:encodeURIComponent(t),"=",s.raw?o:encodeURIComponent(o),u.expires?"; expires="+u.expires.toUTCString():"",u.path?"; path="+u.path:"",u.domain?"; domain="+u.domain:"",u.secure?"; secure":""].join("")}var l=s.raw?n:r;var c=document.cookie.split("; ");var h=t?undefined:{};for(var p=0,d=c.length;p<d;p++){var v=c[p].split("=");var m=l(v.shift());var g=l(v.join("="));if(t&&t===m){h=i(g);break}if(!t){h[m]=i(g)}}return h};s.defaults={};e.removeCookie=function(t,n){if(e.cookie(t)!==undefined){e.cookie(t,"",e.extend({},n,{expires:-1}));return true}return false}});


/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Dual licensed under the MIT (MIT_LICENSE.txt)
 * and GPL Version 2 (GPL_LICENSE.txt) licenses.
 *
 * Version: 1.1.1
 * Requires jQuery 1.3+
 * Docs: http://docs.jquery.com/Plugins/livequery
 */

(function(e){e.extend(e.fn,{livequery:function(t,n,r){var i=this,s;if(e.isFunction(t))r=n,n=t,t=undefined;e.each(e.livequery.queries,function(e,o){if(i.selector==o.selector&&i.context==o.context&&t==o.type&&(!n||n.$lqguid==o.fn.$lqguid)&&(!r||r.$lqguid==o.fn2.$lqguid))return(s=o)&&false});s=s||new e.livequery(this.selector,this.context,t,n,r);s.stopped=false;s.run();return this},expire:function(t,n,r){var i=this;if(e.isFunction(t))r=n,n=t,t=undefined;e.each(e.livequery.queries,function(s,o){if(i.selector==o.selector&&i.context==o.context&&(!t||t==o.type)&&(!n||n.$lqguid==o.fn.$lqguid)&&(!r||r.$lqguid==o.fn2.$lqguid)&&!this.stopped)e.livequery.stop(o.id)});return this}});e.livequery=function(t,n,r,i,s){this.selector=t;this.context=n;this.type=r;this.fn=i;this.fn2=s;this.elements=[];this.stopped=false;this.id=e.livequery.queries.push(this)-1;i.$lqguid=i.$lqguid||e.livequery.guid++;if(s)s.$lqguid=s.$lqguid||e.livequery.guid++;return this};e.livequery.prototype={stop:function(){var e=this;if(this.type)this.elements.unbind(this.type,this.fn);else if(this.fn2)this.elements.each(function(t,n){e.fn2.apply(n)});this.elements=[];this.stopped=true},run:function(){if(this.stopped)return;var t=this;var n=this.elements,r=e(this.selector,this.context),i=r.not(n);this.elements=r;if(this.type){i.bind(this.type,this.fn);if(n.length>0)e.each(n,function(n,i){if(e.inArray(i,r)<0)e.event.remove(i,t.type,t.fn)})}else{i.each(function(){t.fn.apply(this)});if(this.fn2&&n.length>0)e.each(n,function(n,i){if(e.inArray(i,r)<0)t.fn2.apply(i)})}}};e.extend(e.livequery,{guid:0,queries:[],queue:[],running:false,timeout:null,checkQueue:function(){if(e.livequery.running&&e.livequery.queue.length){var t=e.livequery.queue.length;while(t--)e.livequery.queries[e.livequery.queue.shift()].run()}},pause:function(){e.livequery.running=false},play:function(){e.livequery.running=true;e.livequery.run()},registerPlugin:function(){e.each(arguments,function(t,n){if(!e.fn[n])return;var r=e.fn[n];e.fn[n]=function(){var t=r.apply(this,arguments);e.livequery.run();return t}})},run:function(t){if(t!=undefined){if(e.inArray(t,e.livequery.queue)<0)e.livequery.queue.push(t)}else e.each(e.livequery.queries,function(t){if(e.inArray(t,e.livequery.queue)<0)e.livequery.queue.push(t)});if(e.livequery.timeout)clearTimeout(e.livequery.timeout);e.livequery.timeout=setTimeout(e.livequery.checkQueue,20)},stop:function(t){if(t!=undefined)e.livequery.queries[t].stop();else e.each(e.livequery.queries,function(t){e.livequery.queries[t].stop()})}});e.livequery.registerPlugin("append","prepend","after","before","wrap","attr","removeAttr","addClass","removeClass","toggleClass","empty","remove","html");e(function(){e.livequery.play()})})(jQuery)


jQuery(document).ready(function(){
	// Customers page
	jQuery('.featured-customer-item').hover(function() {
		jQuery(this).siblings().toggleClass('featured-customer-item-skinny');
	});
	// prevent click to go anywhere on editions table
	jQuery('.table-compare-popup-link').on('click',function(e){
		return false;
	});
	// Toggle showing the drop-down items in the Super Nav
	jQuery('.super-nav .nolink').on('click',function(e){
		jQuery(this).closest('.menu-item-wrapper').toggleClass('active')
		.on('mouseleave', function() {
			jQuery(this).removeClass('active');
		});
	});

	// smooth scroll on film strip nav
	var root = jQuery('html, body');
	jQuery('a.link-scroll').click(function() {
		jQuery(this).addClass('active').siblings().removeClass('active');
		var href = jQuery.attr(this, 'href');
		root.animate ({
			scrollTop: (jQuery(href).offset().top - 20)
		}, 500, 'swing', function () {
			window.location.hash = href;
		});
		return false;
	});

	// make the first item in the film-strip-nav be selected on default:
	jQuery('.film-strip-nav .film-strip-nav-item:first-child').addClass('active');

	var tabGroup = jQuery('.tab-group');
	// Eric's super-simple tab groups
	tabGroup.livequery(function() {
		jQuery(this).on('click','.tab-group-tabs-item', function() {
			jQuery(this).addClass('active').siblings().removeClass('active');
			var href = jQuery(this).attr('href');
			jQuery(this).closest('.tab-group').find('.tab-group-main-item').filter(href).addClass('active').siblings().removeClass('active');
			return false;
		});
	});

	// Extend hover functionality to tab groups
	jQuery('.tab-group-tabs-item.extend-hover').on('hover', function() {
		jQuery(this).addClass('active').siblings().removeClass('active');
		var href = jQuery(this).attr('href');
		jQuery(this).closest('.tab-group').find('.tab-group-main-item').filter(href).addClass('active').siblings().removeClass('active');
	});

	// On "Try Pentaho", the paragraph that starts with an asterisk into "small-text"
	jQuery('.cta-image-block-item p').filter(function() {
		return jQuery(this).text().search(/\*/) == 0;
	}).addClass('small-text');

	// On "Editions", hide the SPACER row from showing
	jQuery('.table-compare td .table-compare-popup-link').filter(function() {
		return jQuery(this).text().search(/SPACER/) == 0;
	}).closest('tr').addClass('no-show');

	// on the about us page, make the video-link play the youtube video
	jQuery('.video-link').on('click',function() {
		var youtube = jQuery(this).data('youtube');
		jQuery(this).addClass('play-youtube').find('.video-placeholder').show().append('<iframe width="630" height="354" src="http://www.youtube.com/embed/' + youtube + '?autoplay=1&rel=0" frameborder="0" allowfullscreen class="video-player"></iframe>').siblings().hide()
		return false;
	});

	// reset all the videos on tab change
	jQuery('.video-tab').on('click', function() {
		jQuery('.video-player').remove();
		jQuery('.video-placeholder').hide();
		jQuery('.video-image').show();
		jQuery('.video-copy').show();
	});

	// Toggle showing the drop-down items // WORKS. DO NOT CHANGE:
	var editIndustry = jQuery('#edit-industry-wrapper');

	// Adds a 500ms timer to not close tab
	var myTimer = false;
	jQuery(editIndustry).livequery(function() {
		var editIndustryNew = jQuery(this);
		var editIndustryTitle = jQuery(editIndustryNew).find('.title');
		// console.log(editIndustryText);

		var newLabel = jQuery(editIndustryNew).find('.form-item input:checked').next().text();
		if (newLabel != '- Any - ') {
			jQuery(editIndustryTitle).text(newLabel);
		}

		jQuery(editIndustryNew).on('click',function() {
			jQuery(editIndustryNew).addClass('active');
		});

		jQuery(editIndustryNew).on('hover',function() {
			// clearTimeout(myTimer);
		}, function() {
			// myTimer = setTimeout(function() {
				jQuery(editIndustryNew).removeClass('active');
			// }, 500);
		});

		jQuery('input#edit-product-all + label').text('All Products');
		jQuery('input#edit-type-all + label').text('New Resources');
	});

	// CLICK TOGGLE
	var clickToggle = jQuery('.click-toggle-wrapper');
	jQuery(clickToggle).on('click','.click-toggle',function(e) {
		if (jQuery(this).hasClass('dont-toggle')) {
			jQuery(this).addClass('active').siblings().removeClass('active');
			jQuery(this).find('.form-text').focus();
		} else {
			jQuery(this).toggleClass('active').siblings().removeClass('active');
		}
	});

	jQuery(clickToggle).on('mouseleave','.click-toggle',function() {
		jQuery('.click-toggle').removeClass('active');
	});

	// Gear up Partners for Atlas view:
	// var partnersAtlasLabel = jQuery('.partners-atlas label');
	// jQuery(partnersAtlasLabel).livequery(function() {
	// 	jQuery(this).on('click',function(){
	// 		jQuery(this).closest('.partners-section-wrapper').toggleClass('show-right');

	// 		// var regionID = jQuery(this).find('input').attr('value');
	// 		// var regionName = jQuery(this).find('label').text();
	// 		// jQuery(this).find('label').text('').append('<span class="title">'+regionName+'</span>').on('click',function(e) {
	// 		// 	jQuery(this).closest('.partners-section-wrapper').toggleClass('show-right');
	// 		// });
	// 		// jQuery(this).addClass('region-'+regionID);
	// 		// jQuery(this).append('<div class="overlay"></div>');

	// 	});
	// });

	// Partners page
	var partnersSectionWrapper = jQuery('.partners-section-wrapper');
	var partnersSection1Height = jQuery('.partners-section-1').height();
	var partnersSection2       = jQuery('.partners-section-2');

	// make partners list the same height as the maps content
	partnersSection2.css('height', partnersSection1Height + 'px');

	partnersSectionWrapper.on('click','.toggle-move', function() {
		jQuery(this).closest('.partners-section-wrapper').addClass('show-right').find('.tab-region').addClass('active').siblings().removeClass('active');
		jQuery('.tab-group-main-item').filter('[id*=tab-region]').addClass('active').siblings().removeClass('active');
		// reset partners list content height
		partnersSection2.css('height', 'auto');
		return false;
	}).on('click','.toggle-back, .partners-section-1', function() {
		jQuery(this).closest('.partners-section-wrapper').removeClass('show-right');
		// make partners list the same height as the maps content
		partnersSection2.css('height', partnersSection1Height + 'px');
		return false;
	});


	// var chooseRegion = partnersSectionWrapper.find('.choose-region');
	partnersSectionWrapper.livequery(function() {
		jQuery(this).on('click','.region', function() {
			var region = jQuery(this).attr('href');
			jQuery('.region').filter('[href='+region+']').addClass('active').siblings().removeClass('active');
			jQuery(region).addClass('active').siblings().removeClass('active');
			return false;
		});
	});

	// Slide Open Next
	// var slideOpenWrapperWrapper = jQuery('.slide-open-wrapper-wrapper');
	partnersSectionWrapper.on('click','.slide-open',function(e) {
		if (jQuery(this).hasClass('open')) {
			jQuery(this).removeClass('open').next().slideUp('fast');
		} else {
			jQuery(this).removeClass('open').next().slideUp('fast');
			jQuery(this).toggleClass('open').next().slideToggle('fast');
		}
		e.preventDefault();
	});

	// add the clicked section to the data attribute. For some reason, data jQuery was not working correctly at
	var partnersSectionWrapper = jQuery('.partners-section-wrapper');
	partnersSectionWrapper.livequery(function(){

		jQuery(this).on('mousedown','label',function() {
			var clickedSection = jQuery(this).closest('.tab-group-main-item').attr('id');
			var clickedRegion = jQuery('a.region').filter('.active').attr('href');
			// console.log(clickedRegion);
			jQuery('.partners-section-wrapper').attr({'data-clicked-section':clickedSection,'data-clicked-region':clickedRegion});
		});

	});



	// on partners page, on success, repopulate what's active
	jQuery(document).ajaxSuccess(function() {
		var dataClickedSection = jQuery('.partners-section-wrapper').attr('data-clicked-section');
		var dataClickedRegion = jQuery('.partners-section-wrapper').attr('data-clicked-region');

		// console.log('Region: '+dataClickedRegion);
		// console.log('Section: '+dataClickedSection);

		jQuery('#'+dataClickedSection).addClass('active').siblings().removeClass('active');
		jQuery('[href=#'+dataClickedSection+']').addClass('active');
		jQuery('[href='+dataClickedRegion+']').addClass('active');

		var currentTypes = jQuery('.exposed-filter-type').find('input:checked');
		currentTypes.each(function(){
			currentType = jQuery(this);
			currentTypeLabel = currentType.next('label').text().trim();
			if (currentTypeLabel != 'All') {
				currentType.closest('.tab-group').find('.tab-type').text('Type ('+currentTypeLabel+')')
			}
		})
		var currentRegions = jQuery('.exposed-filter-region').find('input:checked');
		currentRegions.each(function(){
			currentRegion = jQuery(this);
			currentRegionLabel = currentRegion.next('label').text().trim();
			if (currentRegionLabel != 'All') {
				currentRegion.closest('.tab-group').find('.tab-region').text('Region ('+currentRegionLabel+')')
			}
		})
	});

	// On resources, takes the data-link and puts it into the inbound cookie
	jQuery('.resource-link').on('click',function() {
		var dataLink = jQuery(this).attr('data-link');
		jQuery.cookie("inbound", dataLink, {path: '/', expires: 256 });
	})

	// On resources, where the links are loaded via ajax, we add the click function as a callback to ajaxComplete.
	// The function above only works on links that already exist on the page, it cannot add the click functionality
	// to links added after jQuery runs.
	jQuery(document).ajaxComplete(function() {
		jQuery('.resource-link').on('click',function() {
			var dataLink = jQuery(this).attr('data-link');
			jQuery.cookie("inbound", dataLink, {path: '/', expires: 256 });
		})
	});

	// target IE8 and add play-overlay spans:
	if (jQuery.browser.msie && navigator.userAgent.indexOf('Trident')!==-1) {
		jQuery('.play-overlay').append('<span class="play-overlay-button"></span>');
	};
})


	//Slide Open Next
	// var slideOpen = jQuery('.slide-open');
	// jQuery(slideOpen).livequery(function(){
	// 	jQuery(this).on('click', function(e) {
	// 		if (jQuery(this).hasClass('open')) {
	// 			jQuery(this).removeClass('open').next().slideUp('fast');
	// 		} else {
	// 			jQuery(slideOpen).removeClass('open').next().slideUp('fast');
	// 			jQuery(this).toggleClass('open').next().slideToggle('fast');
	// 		}
	// 		e.preventDefault();
	// 	})
	// });;
