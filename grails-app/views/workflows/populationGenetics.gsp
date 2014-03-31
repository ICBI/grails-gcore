    <html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />	
		<g:javascript library="jquery" plugin="jquery"/>
        <g:javascript src="workflow.js"/>  
        <script type="text/javascript" >
        
        	var app_name   		= "${appName()}";
        	var data_types 		= new Array();
			var studies    		= new Array();
			var tool 			= '';
			var selected_study;
			var tools 			= new Array();
			var subject_matter  = '';
			var current_step_number = 0;
        
        
		$(document).ready(function() {
		
		
				$('.step').click(function() {	
					/*
					*   Restricts the user to moving to steps without having completed prior ones
					*/
					
					if ($(this).hasClass('complete')) {
						move_to(parseInt($(this).attr('id')));
					}
				});


				function move_to(step_number) {
				
					// Ignore; User clicked on logo;
					if (step_number == -1) {
						return;
					}
				
					// Modify the step we were on
					$("#" + current_step_number).removeClass('active');
					$("#" + current_step_number).addClass('complete');
					
					// Modify the step we went to
					$("#" + step_number).addClass('active');
					$("#" + step_number).removeClass('complete');
					$('#carousel').carousel(step_number);
					update_messages(step_number);
					
					current_step_number = step_number;
				}


				$('.carousel').each(function(){
					/*
					*   Prevents the carousel from automatically moving through each section
					*/
				
					$(this).carousel({
						interval: false
					});
				});
				
				
				function update_messages(step_number) {
					/*
					*   Messages to guide user on each section
					*   Each step number represents a section for the carousel
					*/
				
					if (step_number == 0) {
						$('#selections').html(' ');
						$('#message').html('What study would you like to work with?');
					}
					else if (step_number == 1) {
						$('#selections').html('<i>' + selected_study.studyName + '</i>');
						$('#message').text('');
					}
				}
				
				
				function create_studies_section() {
					/*
					*   Generates the HTML for the studies section. Assumes an element with id=studies exists
					*/
				
					var html = '';
							
					for (var i = 0; i < studies.length; i++) {
						html += get_html_for_study(studies[i]);
					}

					$('#studies').html(html);
					create_study_click_handler();
				}
				
				function create_tools_section() {
					/*
					*   Generates the HTML for the tools section. Assumes an element with id=tools exists
					*/
					
					var html = '';
					tools = new Array();
									
					for (var i = 0; i < studies.length; i++) {
						if (studies[i].studyName == selected_study.studyName) {
							
							for (var j = 0; j < studies[i].tools.length; j++) {
								tools.push(studies[i].tools[j]);
							}
							
							// Break since we found the tools particular to this study
							break;
						}
					}
					
					
					html = get_html_for_tools(tools);
					

					$('#tools').html(html);	
				}
				
				function create_study_click_handler() {
					/*
					*   When user selects a study, what do we do next? This function handles that action.
					*/
				
					$('.study').click(function() {

							study = $(this).find('h5').text();
							selected_study = null;
							
							for(var i = 0; i < studies.length; i++) {
								if (studies[i].studyName == study) {
									selected_study = studies[i];
									break;
								}
							}
							
							set_study(selected_study.studyId);
							
							move_to(1);
							create_tools_section();
							
					});
				}

			

				load_population_genetics_studies(function(data) {
					/*
					*   The first function called. Gets the data needed for all of the workflow!
					*/
					
					for (var i = 0; i < data.length; i++) {
						studies.push(data[i]);
						data_types.push(data[i].disease);
					}

					create_studies_section();
				});
				
			});
		</script>	
        
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'workflow.css')}"/>
    </head>
    <body>
    	<br />
    	<div class="welcome-title" style="float: left; padding-bottom: 50px;">Population Genetics</div>
    	<!-- Credit for design and implementation of bread-crumbs goes to Chris Spooner. Copy and pasted from: 
    		http://line25.com/tutorials/how-to-create-flat-style-breadcrumb-links-with-css
    	-->
    	<div id="crumbs" style="clear: both; margin-left: -560px;">
			<ul>
				<li><a id="-1" href="#" class="workflow_logo complete step"><img class="workflow-img" src="${createLinkTo(dir: 'images',  file: 'pop.png')}"  /></a></li>
				<li><a id="0" href="#" class="active step">Study</a></li>
				<li><a id="1" href="#" class="step">Finish!</a></li>
			</ul>
		</div>
		<h5 class="desc" id="selections" style="float: left; clear: both;">&nbsp;</h5>
		</br>
		<div class="desc" id="message" style="float: left; clear: both;">Which study do you wish to choose from?</div>
		</br>
		<div id="carousel" class="carousel slide" data-ride="carousel">
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner features">
		  	  
			  <div class="item active">
		  		<ul id="studies" class="box_container">
		  			<img class="load_study" src="${createLinkTo(dir: 'images',  file: '295.gif')}"  />
		  		</ul>
		 	 </div>			
		 	 
		 	 
			  <div class="item">
				<ul id="tools" class="box_container">
				</ul>
			  </div>
		  </div>
		  </div>
		</div>
  
    	
    	</br>		  
    </body>
</html>