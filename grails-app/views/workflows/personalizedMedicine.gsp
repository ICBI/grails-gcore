    <html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
        <g:javascript src="workflow.js"/>
        <script type="text/javascript" >
        
        	var app_name          = "${appName()}";
        	var unique_data_types = new Array();
        	var data_types        = new Array();
			var studies           = new Array();
			var study 		      = '';
			var data_type         = '';
			var tool 		      = '';
			var selected_study;
			var tools             = new Array();
			var subject_matter    = '';    
        
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
					/*
					*   Moves to a given step in the workflow. Updates the workflow message accordingly
					*/

					$("#" + step_number).addClass('complete');
					$('#carousel').carousel(step_number);
					update_messages(step_number);
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
						$('#message').html('What type of data do you want to analyze?');
					}
					else if (step_number == 1) {
						$('#selections').html('<i>' + data_type + '</i>');
						$('#message').html('Great! Now, what study would you like to work with?');
					}
					else if (step_number == 2) {
						$('#selections').html('<i>' + data_type + ' &rarr; ' + study + '</i>');
						$('#message').text('Select your tool and you\'re finished!');
					}
				}
				
							

				function create_studies_section() {
					/*
					*   Generates the HTML for the studies section. Assumes an element with id=studies exists
					*/
			
					var html = '';
							
					for (var i = 0; i < studies.length; i++) {

						if (data_type == studies[i].disease) {	
							html += get_html_for_study(studies[i]);					
						}
					}

					$('#studies').html(html);
					create_study_click_handler();
				}
				
				function create_tools_section() {
					/*
					*   Generates the HTML for the tools section. Assumes an element with id=tools exists
					*/
				
					var html = '';
					var tools = new Array();
					
					//get_html_for_tools(studies[i].tools);
									
					for (var i = 0; i < studies.length; i++) {
						if (studies[i].studyName == study) {
							for (var j = 0; j < studies[i].tools.length; j++) {
								tools.push(studies[i].tools[j]);
							}
							break;
						}
					}
					
					var html = get_html_for_tools(tools);
					$('#tools').html(html);
					//create_tool_click_handler();
				}


				function create_data_type_section() {
					/*
					*   Generates the HTML for the data type section. Assumes an element with id=data_types exists
					*/
				
					var html = '';
									
					for (var i = 0; i < unique_data_types.length; i++) {
					
						var study_count = 0;
						for (var j = 0; j < data_types.length; j++) {
							if (data_types[j] == unique_data_types[i]) {
								study_count++;
							}
						}
						
					
						html += get_html_for_data_type(unique_data_types[i], study_count);
					}

					$('#data_types').html(html);
					
					create_data_type_click_handler();
				}
					
				
				function create_tool_click_handler() {
					/*
					*   When user selects a tool, what do we do next? This function handles that action.
					*/
				
					$('.tool').click(function() {
					
							
							tool = $(this).find('h5').text();
							
							for(var i = 0; i < tools.length; i++) {
								if (tools[i].name == tool) {
									window.location = tools[i].link;
								}
							}
							
							move_to(2);
							create_tools_section();
							
					});
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
							
							move_to(2);
							create_tools_section();
							
					});
				}

				function create_data_type_click_handler() {
					/*
					*   When user selects a data type, what do we do next? This function handles that action.
					*/
				
					$('.data_type').click(function() {
	
							data_type = $(this).find('h5').text();			
							move_to(1);
							create_studies_section();
					});
				}

			
				
				load_precision_medicine_studies(function(data) {
					/*
					*   The first function called. Gets the data needed for all of the workflow!
					*/
				
					for (var i = 0; i < data.length; i++) {
						studies.push(data[i]);
						data_types.push(data[i].disease);
					}

					unique_data_types = eliminateDuplicates(data_types);
					create_data_type_section();
				});
				
			});
        
        
        	
        </script>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css/bootstrap',  file: 'bootstrap.min.css')}"/>
        <link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'workflow.css')}"/>
    </head>
    <body>
    	<img class="workflow-img" src="${createLinkTo(dir: 'images',  file: 'pm.png')}" />
    	<div class="welcome-title" style="display: inline">Precision Medicine</div>
    	<br/>
    	<!-- Credit for design and implementation of bread-crumbs goes to Chris Spooner. Copy and pasted from: 
    		http://line25.com/tutorials/how-to-create-flat-style-breadcrumb-links-with-css
    	-->
    	
    	<div id="crumbs">
			<ul>
				<li><a id="0" href="#" class="complete step">Data</a></li>
				<li><a id="1" href="#" class="step">Study</a></li>
				<li><a id="2" href="#" class="step">Finish!</a></li>
			</ul>
		</div>
		<h5 class="desc" id="selections">&nbsp;</h5>
		</br>
		<div class="desc" id="message">What type of data collection do you want to analyze?</div>
		</br>
		<div id="carousel" class="carousel slide" data-ride="carousel">
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner">
		    
		  <div class="item active">
		  	<ul id="data_types" class="box_container">
		  		<img class="load_study" src="${createLinkTo(dir: 'images',  file: '295.gif')}"  />
		 	</ul>
		  </div>
		  		
			
		  <div class="item">
		  	<ul id="studies" class="box_container">
		 	</ul>
		  </div>
		  		
			
		  
		  <div class="item">
			<ul id="tools" class="box_container">
		 	</ul>
		  </div>
			
			
			
		  </div>
		</div>
  
    	
    	</br>		  
    </body>
</html>