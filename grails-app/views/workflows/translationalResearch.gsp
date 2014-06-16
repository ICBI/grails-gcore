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
			var selected_study_name;
			var selected_study;
			var selected_data_type  = '';
			var current_step_number = 0;

            	
            $(document).ready(function() {
		
				$('.step').click(function() {	
					// Allows user to move to steps that have been completed
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
						$('#message').text('Select your sample type.');
					}
					else if (step_number == 2) {
						$('#selections').html('<i>' + selected_data_type + ' &rarr; ' + subject_type + '</i>');
						$('#message').html('Great! Now, what '+ selected_data_type.toLowerCase() + ' study would you like to work with?');
					}
					else if (step_number == 3) {
						$('#message').html('Study selected! '+ selected_data_type + ' &rarr; ' + subject_type + ' &rarr; ' +  selected_study_name + '');
					}
				}
				
				
				function create_data_type_section() {
					/*
					*   Generates the HTML for the data type section. Assumes an element with id=data_types exists
					*/
				
					var html = '';



                    for (var i = 0; i < unique_data_types.length; i++) {

                        var study_count = 0;
                        var patient_count = 0;
                        var biospecimen_count = 0;

                        for (var j = 0; j < data_types.length; j++) {
                            if (data_types[j] == unique_data_types[i]) {
                                study_count++;
                            }
                        }

                        for (var k = 0; k < studies.length; k++) {
                            if (unique_data_types[i] == studies[k].disease) {
                                patient_count = patient_count + studies[k].patients;
                                biospecimen_count = biospecimen_count + studies[k].biospecimen;
                            }
                        }

                        html += get_html_for_data_type(unique_data_types[i], study_count, patient_count, biospecimen_count);
                    }


				/*	for (var i = 0; i < unique_data_types.length; i++) {

                        var study_count = 0;
						for (var j = 0; j < data_types.length; j++) {
							if (data_types[j] == unique_data_types[i]) {
								study_count++;
							}
						}

						html += get_html_for_data_type(unique_data_types[i], study_count, patient_count);
					}*/

					$('#data_types').html(html);
					
					create_data_type_click_handler();
				}
				
				
				function create_tools_section() {
					/*
					*   Generates the HTML for the tools section. Assumes an element with id=tools exists
					*/
				
					var html = '';
					var tools = new Array();
					
			
									
					for (var i = 0; i < studies.length; i++) {
						if (studies[i].studyName == selected_study_name) {
							for (var j = 0; j < studies[i].tools.length; j++) {
								tools.push(studies[i].tools[j]);
							}
							break;
						}
					}
					
					var html = get_html_for_tools(tools);
					$('#tools').html(html);

                    /* Adding Descirption Popovers for tools */
                    for (j = 0; j < tools.length; j++) {
                        $('#element'+j+'').popover();
                    }
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

                    create_study_click_handler();

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



				function create_study_click_handler() {
					/*
					*   When user selects a study, what do we do next? This function handles that action.
					*/
                    var html = '';
					$('.study').click(function() {

							selected_study_name = $(this).find('h5').text();
							selected_study = null;

							for(var i = 0; i < studies.length; i++) {
								if (studies[i].studyName == selected_study_name) {
									selected_study = studies[i];
									break;
								}
							}

							set_study(selected_study.studyId);

							move_to(3);
							create_tools_section();

					}).find('.more').on('click', function (e) {
                        e.stopPropagation();
                        selected_study_name = $(this).parent().find('h5').text();
                        selected_study = null;

                        for(var i = 0; i < studies.length; i++) {
                            if (studies[i].studyName == selected_study_name) {
                                selected_study = studies[i];
                                break;
                            }
                        }

                       // set_study_no_history(selected_study.studyId);
                        create_study_modal_click_handler();
                        $('#myModalLabel').text(selected_study_name);
                        $('#studyTitle').html(selected_study.studyLongName);
                        $('#studyAbstract').html(selected_study.abstract);
                        $('#studyPatients').html(selected_study.patients);
                        $('#studyBiospecimen').html(selected_study.biospecimen);
                        $('#studyId').html(selected_study.studyId);
                        $('#myModal').modal();

                    });

				}


                function create_study_modal_click_handler() {
                    /*
                     *   When user selects a study, what do we do next? This function handles that action.
                     */
                    $('#selectStudy').click(function() {
                        set_study(selected_study.studyId);
                        move_to(3);
                        create_tools_section();

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

    	<div class="welcome-title">Translational Research</div>
        <div class="desc" id="message" style="clear: both;">What type of data collection do you want to analyze?</div>

    	<!-- Credit for design and implementation of bread-crumbs goes to Chris Spooner. Copy and pasted from: 
    		http://line25.com/tutorials/how-to-create-flat-style-breadcrumb-links-with-css
    	-->
         </br>
    	<div id="crumbs" style="clear: both; margin-left: -150px; padding-bottom: 5px;">
			<ul>
				<li><a id="-1" href="#" class="workflow_logo complete step"><img class="workflow-img" src="${createLinkTo(dir: 'images',  file: 'tr_sm.png')}"  /></a></li>
				<li><a id="0" href="#" class="active step">Data</a></li>
				<li><a id="1" href="#" class="step">Sample</a></li>
				<li><a id="2" href="#" class="step">Study</a></li>
				<li><a id="3" href="#" class="step">Finish!</a></li>
			</ul>
		</div>

		<div id="carousel" class="carousel slide features" data-ride="carousel" style="min-height: 270px;">
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner ">

			  <div class="item active">
				<ul id="data_types" class="box_container">
					<img class="load_study" src="${createLinkTo(dir: 'images',  file: '295.gif')}"  />
				</ul>
			  </div>

			  <div class="item" >
				<ul id="subject_types" class="box_container">
				</ul>
			  </div>

			  <div class="item">
				<ul id="studies" class="box_container">
				</ul>
			  </div>

			   <div class="item">
				<div id="tools" class="box_container">
				</div>
			  </div>

		  </div>
		</div>

        <g:render template="/workflows/studyModal" plugin="gcore"/>

    </body>
</html>