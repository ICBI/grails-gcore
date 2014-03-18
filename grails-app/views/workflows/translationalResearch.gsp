    <html>
    <head>
        <title>${appLongName()}</title>
		<meta name="layout" content="workflowsLayout" />
		<g:javascript library="jquery" plugin="jquery"/>
        <g:javascript src="workflow.js"/>
        <script type="text/javascript" >
        
        	var app_name   = "${appName()}";
        	var unique_data_types = new Array();
        	var data_types = new Array();
			var studies    = new Array();
			var study_type = '';
			var subject_type = '';
			var selected_data_type  = '';

            	
            $(document).ready(function() {
		
				$('.step').click(function() {	
					// Allows user to move to steps that have been completed
					if ($(this).hasClass('complete')) {
						move_to(parseInt($(this).attr('id')));
					}
				});


				function move_to(step_number) {

					$("#" + step_number).addClass('complete');
					$('#carousel').carousel(step_number);
					update_messages(step_number);
				}


				// Prevents the carousel from automatically moving
				$('.carousel').each(function(){
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
						$('#selections').html('<i>' + selected_data_type + '</i>');
						$('#message').text('Select your subject matter');
					}
					else if (step_number == 2) {
						$('#selections').html('<i>' + selected_data_type + ' &rarr; ' + subject_type + '</i>');
						$('#message').html('Great! Now, what study would you like to work with?');
					}
					else if (step_number == 3) {
						$('#selections').html('<i>' + selected_data_type + ' &rarr; ' + study_type + '</i>');
						$('#message').text('Use this clinical tool');
					}
					else if (step_number == 4) {
						$('#selections').html('<i>' + selected_data_type + ' &rarr; ' + study_type + '</i>');
						$('#message').text('Select your tool and you\'re finished!');
					}
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
				
				
				function create_subject_matter_section() {
					/*
					*   Generates the HTML for the subject matter section. Assumes an element with id=subject_types exists
					*/
				
					var html = '';
					var available_subjectTypes = new Array();
							
					for (var i = 0; i < studies.length; i++) {
						
						if (selected_data_type == studies[i].disease) {	
							available_subjectTypes.push(studies[i].subjectType);
						}
					}
					
					available_subjectTypes = eliminateDuplicates(available_subjectTypes);
					
					for (var i = 0; i < available_subjectTypes.length; i++) {
							html += get_html_for_subject_type(available_subjectTypes[i]);
					}

					$('#subject_types').html(html);	
					
					create_subject_type_click_handler();
				}
		
		
				function create_studies_section() {
					/*
					*   Generates the HTML for the studies section. Assumes an element with id=studies exists
					*/
					
					
					var html = '';
							
					for (var i = 0; i < studies.length; i++) {

						if (selected_data_type == studies[i].disease && subject_type == studies[i].subjectType) {		
						
							html += get_html_for_study(studies[i]);				
						}
					}

					$('#studies').html(html);
				}


				
				
				function create_subject_type_click_handler() {
					/*
					*   When user selects a subject type, what do we do next? This function handles that action.
					*/
				
					$('.subject_type').click(function() {
	
							subject_type = $(this).find('h5').text();			
							move_to(2);
							create_studies_section();
					});
				}

				function create_data_type_click_handler() {
					/*
					*   When user selects a data type, what do we do next? This function handles that action.
					*/
				
					$('.data_type').click(function() {
	
							selected_data_type = $(this).find('h5').text();			
							move_to(1);
							create_subject_matter_section();
					});
				}
				
				function create_study_click_event() {
					/*
					*   When user selects a study, what do we do next? This function handles that action.
					*/
				
					$('.study_type').click(function() {
						study_type = $(this).find('h5').text();	
						move_to(3);
					});
				} 

				
				load_translational_research_studies(function(data) {
					/*
					*   The first function called. Gets the data needed for all of the workflow.
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
    	
    	<img class="workflow-img" src="${createLinkTo(dir: 'images',  file: 'tr.png')}"  />
    	<div class="welcome-title" style="display: inline">Translational Research</div>
    	
    	<br/>
    	<!-- Credit for design and implementation of bread-crumbs goes to Chris Spooner. Copy and pasted from: 
    		http://line25.com/tutorials/how-to-create-flat-style-breadcrumb-links-with-css
    	-->
    	<div id="crumbs">
			<ul>
				<li><a id="0" href="#" class="complete step">Data Type</a></li>
				<li><a id="1" href="#" class="step">Subject Matter</a></li>
				<li><a id="2" href="#" class="step">Study</a></li>
				<li><a id="3" href="#" class="step">Clinical Search</a></li>
				<li><a id="4" href="#" class="step">Finish!</a></li>
			</ul>
		</div>
		<h5 class="desc" id="selections">&nbsp;</h5>
		</br>
		<div class="desc" id="message">What type of data do you want to analyze?</div>
		</br>
		<div id="carousel" class="carousel slide" data-ride="carousel">
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner">		  
			  <div class="item active">
				<ul id="data_types" class="box_container">
				</ul>
			  </div>
				
			
			  <div class="item">
				<ul id="subject_types" class="box_container">
				</ul>
			  </div>
				
			
			  <div class="item">
				<ul id="studies" class="box_container">
				</ul>
			  </div>
		  
			  <div class="item">
				<div id="clinical" class="features">
				</div>
			  </div>
		  
		  
			   <div class="item">
				<div id="tools" class="features">
				</div>
			  </div>
		  </div>
		</div>
    	</br>		  
    </body>
</html>