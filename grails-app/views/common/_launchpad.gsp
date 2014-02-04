    <g:javascript src="js_launchpad1.js"/>
    <g:javascript src="js_launchpad2.js"/>
    <g:javascript src="js_launchpad3.js"/>
    <g:javascript src="js_launchpad4.js"/>
    <g:javascript src="js_launchpad5.js"/>

    <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'launchpad.css')}"/>
    <script type="text/javascript">
    <!--//--><![CDATA[//><!--
    jQuery.extend(Drupal.settings, {"basePath":"\/","pathPrefix":"","ajaxPageState":{"theme":"gdoc","theme_token":"jRrvBFlpAZ7ZO-4AWtEyiEveO8GB5cr8bmJHSUixyGs","js":{"http:\/\/munchkin.marketo.net\/munchkin.js":1,"0":1,"sites\/all\/modules\/jquery_update\/replace\/jquery\/1.7\/jquery.min.js":1,"misc\/jquery.once.js":1,"misc\/drupal.js":1,"misc\/ajax.js":1,"sites\/all\/modules\/media_colorbox\/media_colorbox.js":1,"http:\/\/admin.brightcove.com\/js\/BrightcoveExperiences.js":1,"sites\/all\/libraries\/colorbox\/jquery.colorbox-min.js":1,"sites\/all\/modules\/colorbox\/js\/colorbox.js":1,"sites\/all\/modules\/colorbox\/styles\/default\/colorbox_style.js":1,"sites\/all\/modules\/colorbox\/js\/colorbox_load.js":1,"sites\/all\/modules\/colorbox\/js\/colorbox_inline.js":1,"sites\/all\/modules\/views_slideshow\/js\/views_slideshow.js":1,"sites\/all\/modules\/ctools\/js\/auto-submit.js":1,"misc\/progress.js":1,"sites\/all\/modules\/colorbox_node\/colorbox_node.js":1,"sites\/all\/themes\/pentaho\/_js\/master.js":1},"css":{"modules\/system\/system.base.css":1,"modules\/system\/system.menus.css":1,"modules\/system\/system.messages.css":1,"modules\/system\/system.theme.css":1,"modules\/aggregator\/aggregator.css":1,"sites\/all\/modules\/colorbox_node\/colorbox_node.css":1,"sites\/all\/modules\/date\/date_api\/date.css":1,"sites\/all\/modules\/date\/date_popup\/themes\/datepicker.1.7.css":1,"sites\/all\/modules\/date\/date_repeat_field\/date_repeat_field.css":1,"modules\/field\/theme\/field.css":1,"modules\/node\/node.css":1,"modules\/search\/search.css":1,"sites\/all\/modules\/search_krumo\/search_krumo.css":1,"modules\/user\/user.css":1,"sites\/all\/modules\/views\/css\/views.css":1,"sites\/all\/modules\/colorbox\/styles\/default\/colorbox_style.css":1,"sites\/all\/modules\/ctools\/css\/ctools.css":1,"sites\/all\/modules\/views_slideshow\/views_slideshow.css":1,"http:\/\/fonts.googleapis.com\/css?family=Open+Sans:300,400,600,700":1,"sites\/all\/themes\/pentaho\/_css\/master.css":1,"sites\/all\/themes\/pentaho\/_css\/override.css":1,"\/sites\/all\/themes\/pentaho\/_css\/old-ie.css":1}},"colorbox":{"transition":"elastic","speed":"350","opacity":"0.85","slideshow":false,"slideshowAuto":true,"slideshowSpeed":"2500","slideshowStart":"start slideshow","slideshowStop":"stop slideshow","current":"{current} of {total}","previous":"\u00ab Prev","next":"Next \u00bb","close":"Close","overlayClose":true,"maxWidth":"98%","maxHeight":"98%","initialWidth":"300px","initialHeight":"480","fixed":true,"scrolling":true}});
    //--><!]]>
    </script>

	<div class="featured-customer-wrapper">

		<div class="featured-customer-column">

			<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
					<h3>
						<a href="">My Studies</a>
					</h3>
					<div class="p">
						<p>All data in G-DOC is organized in studies. Following are your latest visited studies: </p>
						<ul>
							<li><a href="">BRC_IMAGING_TCIA_02</a></li>
							<li><a href="">BRC_LOI_2008_01</a></li>
							<li><a href="">BRC_ZHOU_2008_01</a></li>
						</ul>
					</div>
					<div class="featured-customer-links">
						<div class="short-title node node-press-release"> <!-- open-div -->
							<a href="" class="news-event-item link-parent">
								<p class="link-child">My Studies</p>
							</a>
						</div><!-- close-div -->
						<div class="short-title node node-resource"> <!-- open-div -->
							<a href="/${appName()}/studyDataSource/" class="news-event-item link-parent">
								<p class="link-child">All Studies</p>
							</a>
						</div> <!-- close-div -->
					</div>
				</div>

				<div class="featured-customer-image">
						<div class="icon">
							<img src="/${appName()}/images/launchpad/mystudies.png" class="ft1" alt="">
						</div>
						<h2 >My Studies</h2>
				</div>
			</div> <!-- close-div -->

			<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
					<h3>
						<a href="/${appName()}/collaborationGroups/">My Groups</a>
					</h3>
					<div class="p">
						<p>In G-DOC you can create collaboration groups, invite users to access your groups and also request access to other user groups.</p>
					</div>
					<div class="featured-customer-links">
						<div class="short-title node node-resource"> <!-- open-div -->
							<a href="/${appName()}/collaborationGroups/" class="link-parent colorbox-node resource-link init-colorbox-node-processed-processed">
								<p class="link-child">My Groups</p>
							</a>
						</div> <!-- close-div -->
					</div>
				</div>
				<div class="featured-customer-image">
						<div class="icon">
							<img src="/${appName()}/images/launchpad/mygroups.png" class="ft1" alt="">
						</div>
						<h2 >My Groups</h2>
				</div>
			</div> <!-- close-div -->
		</div>

		<div class="featured-customer-column">

			<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
					<h3>
						<a href="/${appName()}/userList/list">Saved Lists</a>
					</h3>
					<div class="p">
						<p>G-DOC enables you to save your lists for future use and sharing. Lists may be composed of either genes or patients and exported into multiple formats, including Microsoft Excel.</p>
					</div>
					<div class="featured-customer-links">
						<div class="short-title node node-resource"> <!-- open-div -->
							<a href="/${appName()}/userList/list" class="link-parent colorbox-node resource-link init-colorbox-node-processed-processed">
								<p class="link-child">Saved Lists</p>
							</a>
						</div> <!-- close-div -->
					</div>
				</div>
				<div class="featured-customer-image">
								<div class="icon">
									<img src="/${appName()}/images/launchpad/mylists.png" class="ft1" alt="">
								</div>
								<h2 >Saved Lists</h2>
				</div>
			</div> <!-- close-div -->


			<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
					<h3>
						<a href="/${appName()}/notification">Notifications</a>
					</h3>
					<div class="p">
						<p>G-DOC allows you to track your running Analysis</p>
                        <g:if test="${session.notifications}">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You have running analysis. Click on View below to access it.
                        </g:if>
                        <g:else>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<g:message code="notifications.none" />
                        </g:else>
					</div>
					<div class="featured-customer-links">
						<div class="short-title node node-resource"> <!-- open-div -->
							<a href="/${appName()}/notification" class="link-parent colorbox-node resource-link init-colorbox-node-processed-processed">
								<p class="link-child">View Notifications</p>
							</a>
						</div> <!-- close-div -->
					</div>
						</div>
					<div class="featured-customer-image">
							<div class="icon">
								<img src="/${appName()}/images/launchpad/notifications.png" class="ft1" alt="">
							</div>
							<h2 >Notifications
							    <span class="badge">
                                    <g:if test="${session.notifications}">1</g:if>
                                    <g:else>0</g:else>
                                </span>
							</h2>
					</div>
			</div> <!-- close-div -->
		</div>

		<div class="featured-customer-column last">

			<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
				<h3>
					<a href="/${appName()}/savedAnalysis/">Saved Analysis</a>
				</h3>
								<div class="p">
					<p>G-DOC support your research needs by saving your analysis for future use and sharing.</p></div>
					<div class="featured-customer-links">
						<div class="short-title node node-resource"> <!-- open-div -->
							<a href="/${appName()}/savedAnalysis/" class="link-parent colorbox-node resource-link init-colorbox-node-processed-processed">
								<p class="link-child">Saved Analysis</p>
							</a>
						</div> <!-- close-div -->
					</div>
			</div>
			<div class="featured-customer-image">
					<div class="icon">
						<img src="/${appName()}/images/launchpad/myanalysis.png" class="ft1" alt="">
					</div>
					<h2 >Saved Analysis</h2>
			</div>
		</div> <!-- close-div -->


		<div class="featured-customer-item node node-customer"> <!-- open-div -->
				<div class="featured-customer-details">
					<h3>
						<a href="/${appName()}/workflows/choosePath">It All Starts Here!</a>
					</h3>
					<div class="p">
					   <p>G-DOC has over seventy studies, We know this can be overwhelming! Let us guide you to choose the study that is relevant for your research.</p> </div>
						<div class="featured-customer-links">
							<div class="short-title node node-resource"> <!-- open-div -->
								<a href="/${appName()}/workflows/choosePath" class="link-parent colorbox-node resource-link init-colorbox-node-processed-processed">
									<p class="link-child">Let's Go!</p>
								</a>
							</div> <!-- close-div -->
						</div>
				</div>
                <div class="featured-customer-image">
                        <div class="icon">
                            <img src="/${appName()}/images/launchpad/launch.png" class="ft1" alt="">
                        </div>
                        <h2 >Help me pick a study</h2>
                </div>
		</div> <!-- close-div -->
	</div>

	</div>

