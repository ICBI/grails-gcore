<html>
<head>
<title>${appLongName()}</title>
<meta name="layout" content="workflowsLayout" />
<g:javascript library="jquery" plugin="jquery"/>
<g:javascript src="workflow.js"/>
<g:javascript src="bootstrap.min.js"/>
<g:javascript src="bootstrap-select.min.js"/>

<script type="text/javascript" >

    var app_name          = "${appName()}";
    var unique_data_types = new Array();
    var data_types        = new Array();
    var studies           = new Array();
    var study 		      = '';
    var data_type         = '';
    var tool 		      = '';
    var selected_study = '';
    var selected_study_name = '';
    var tools             = new Array();
    var subject_matter    = '';
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
                $('#message').html('What type of data do you want to analyze?');
            }
            else if (step_number == 1) {
                $('#selections').html('<i>' + data_type + '</i>');
                $('#message').html('Great! What ' + data_type.toLowerCase() + ' study would you like to work with?');
            }
            else if (step_number == 2) {
                $('#selections').html('<i>' + data_type + ' &rarr; ' + study + '</i>');
                $('#message').html('Study Selected! ' + data_type + ' &rarr; ' + study + '');
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
            /* Adding Descirption Popovers for tools */
            for (j = 0; j < tools.length; j++) {
                $('#element'+j+'').popover();
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

            $('#data_types').html(html);

            create_data_type_click_handler();
        }


       /* function create_tool_click_handler() {
            /*
             *   When user selects a tool, what do we do next? This function handles that action.
             */

         /*   $('.tool').click(function() {


                tool = $(this).find('h5').text();

                for(var i = 0; i < tools.length; i++) {
                    if (tools[i].name == tool) {
                        window.location = tools[i].link;
                    }
                }

                move_to(2);
                create_tools_section();

            });
        }*/


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

            }).find('.more').on('click', function (e) {
                e.stopPropagation();
                study = $(this).parent().find('h5').text();
                selected_study = null;

                for(var i = 0; i < studies.length; i++) {
                    if (studies[i].studyName == study) {
                        selected_study = studies[i];
                        break;
                    }
                }


                create_study_modal_click_handler();
                $('#myModalLabel').text(study);
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
<g:javascript src="bootstrap.min.js"/>
<g:javascript src="bootstrap-select.min.js"/>
</head>
<body>
    <div class="welcome-title">Precision Medicine</div>
    <div class="desc" id="message" style="clear: both;">What type of data collection do you want to analyze?</div>
    </br>
    <!-- Credit for design and implementation of bread-crumbs goes to Chris Spooner. Copy and pasted from:
                http://line25.com/tutorials/how-to-create-flat-style-breadcrumb-links-with-css
            -->
    <div id="crumbs" style="clear: both; margin-left: -340px; padding-bottom: 5px;">
        <ul>
            <li><a id="-1" href="#" class="workflow_logo complete step"><img class="workflow-img" src="${createLinkTo(dir: 'images',  file: 'pm_sm.png')}" /></a></li>
            <li><a id="0" href="#" class="active step">Data</a></li>
            <li><a id="1" href="#" class="step">Study</a></li>
            <li><a id="2" href="#" class="step">Finish!</a></li>
        </ul>
    </div>
    <div id="carousel" class="carousel slide" data-ride="carousel">
        <!-- Wrapper for slides -->
        <div class="carousel-inner">

            <div class="item active features" style="min-height: 270px;">
                <ul id="data_types" class="box_container">
                    <img class="load_study" src="${createLinkTo(dir: 'images',  file: '295.gif')}"  />
                </ul>
            </div>

            <div class="item features" style="min-height: 270px;">
                <ul id="studies" class="box_container">
                </ul>
            </div>

            <div class="item features" style="min-height: 270px;">
                <ul id="tools" class="box_container">
                </ul>
            </div>

        </div>
    </div>

    <g:render template="/workflows/studyModal" plugin="gcore"/>


</body>
</html>