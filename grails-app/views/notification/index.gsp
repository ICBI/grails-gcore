<html>
<head>
	<meta name="layout" content="main" />
	<g:javascript library="jquery" plugin="jquery"/>
	<jq:plugin name="tooltip"/>
	<title><g:message code="notifications.heading" /></title>         
</head>
<body>
	<g:javascript>
		jQuery(document).ready(function() {
			addToolTips();
			var refreshId = setInterval(function() {
		  	jQuery.ajax({
					type: "POST",
					url: "${createLink(controller: 'notification', action: 'check')}",
					success: function(data) {
						//console.log(data);
						//jQuery("#notifications_content").html(data);
						document.getElementById('notifications_content').innerHTML = data;
						
						var status = jQuery(".status").map(function() {
							return jQuery(this).html();
						});
						var allStats = jQuery.grep(status, function(item) {
							return (item.indexOf("Running") >= 0);
						});
						if(allStats && allStats.length == 0) {
							clearInterval(refreshId);
						}
						addToolTips();
					},
					error: function(data) {
						clearInterval(refreshId);
					}
				});
		  }, 5000);
		});
		
		function addClickHandler() {
			jQuery('.genePatternLink').click(function() {
				jQuery('#gpForm').submit();
				return false;
			})
		}
		
		function addToolTips() {
			jQuery('.errorStatus').tooltip({
				bodyHandler: function() { 
					return jQuery.ajax({
						type: "POST",
						async: false,
						data: {id: this.id},
						url: "${createLink(controller: 'notification', action: 'error')}"
					}).responseText;
				}, 
				showURL: false
			});
		}
		
	</g:javascript>
	<div class="welcome-title"><g:message code="notifications.heading" /></div>
    <div class="desc">Below are your running analyses.</div>

    <div class="features" style="min-height: 200px;">
        <g:render template="/notification/notificationTable"  plugin="gcore"/>
    </div>
	<br/>
</body>

</hmtl>