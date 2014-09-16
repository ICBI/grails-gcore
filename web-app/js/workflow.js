if(!window.console) console = {log: function() {}};
// Function copied from http://dreaminginjavascript.wordpress.com/2008/08/22/eliminating-duplicates/
function eliminateDuplicates(arr) {
	  var i,
	  len=arr.length,
	  out=[],
	  obj={};

		for (i=0;i<len;i++) {
			obj[arr[i]]=0;
		}

		for (i in obj) {
			out.push(i);
		}

	return out;
}

function set_study(study_id) {

	console.log(study_id);
	console.log("/" + app_name + "/studyDataSource/justSetStudy");
	$.ajax({
				url: "/" + app_name + "/studyDataSource/justSetStudy",
				dataType: 'json',
				data: {
					study: study_id
				},
				success: function(study_id) {
                    success_callback(study_id);
				},
				error: function(request, status, error) {
					//console.log('function set_study(study_id) has failed. Here is the reason: ' + error);
				},
				complete: function() {
				}
		});
}
/*
function set_study_no_history(study_id) {

    console.log(study_id);
    console.log("/" + app_name + "/studyDataSource/setStudyNoHistory");
    $.ajax({
        url: "/" + app_name + "/studyDataSource/setStudyNoHistory",
        dataType: 'json',
        data: {
            study: study_id
        },
        success: function() {

        },
        error: function(request, status, error) {
            console.log('function set_study(study_id) has failed. Here is the reason: ' + error);
        },
        complete: function() {
        }
    });
}
*/


function load_precision_medicine_studies(success_callback) {

		$.ajax({
				url: "/" + app_name + "/studyDataSource/findStudiesForPersonalizedMedicine",
				dataType: 'json',
				success: function(data) {
					success_callback(data);
				},
				error: function(request, status, error) {
					console.log(error)
				},
				complete: function() {
				}
		});				
}

function load_population_genetics_studies(success_callback) {

		$.ajax({
				url: "/" + app_name + "/studyDataSource/findStudiesForPopulationGenetics",
				dataType: 'json',
				success: function(data) {
					success_callback(data);			
				},
				error: function(request, status, error) {
					console.log(error)
				},
				complete: function() {
				}
		});				
}

function load_translational_research_studies(success_callback) {

		$.ajax({
				url: "/" + app_name + "/studyDataSource/findStudiesForTranslationalResearch",
				dataType: 'json',
				success: function(data) {
					success_callback(data);			
				},
				error: function(request, status, error) {
					console.log(error)
				},
				complete: function() {
				}
		});				
}



function get_html_for_study(study) {
        var patients ='<b style="font-size: 14px;">'+ study.patients +'</b><br/>  <i>samples</i>';
        var biospecimen ='<b style="font-size: 14px;">'+ study.biospecimen + '</b> <br/><i>biospecimen</i>';
        var myString = study.abstract;
        var myTruncatedString = myString.substring(0,200);

		var html = '<div id="personalized" class="gradButton gray study box1">';
		html 	+= '<h5>' + study.studyName + '</h5>';
		html 	+= '<p class="_title"><b>Title: </b>' + study.studyLongName + '</p>';
        html 	+= '<p class="data_details"><b>Data Type Details: </b>' + study.content + '</p>';
      /*  html 	+= '<p class="data_details"><b>Patients: </b>' + study.patients + '</p>';
        html 	+= '<p class="data_details"><b>Biospecimens: </b>' + study.biospecimen + '</p>';*/
		html 	+= '<p class="abstract"><b>Abstract: </b>' + study.abstract + '...</p>';
        html    +='<table height="50px" width="230px" style="position: absolute;left: 28px;bottom: 30px;">';
        html    +='<td width="50%"  style="padding-left:8px;"><span class="patientcount count"><br/>' + patients +'</span></td>';
        html    +='<td width="50%"><span class="biospecimencount count"><br/>' + biospecimen +'</span></td>';
        html    +='</table>';
        html 	+= '<div class="more"><a class="test" data-toggle="modal" data-target="#myModal">More>></a></div>';
		html 	+= '</div>';
		return html;
}


function get_html_for_subject_type(subject_type_name) {
		var html = '<div id="personalized" class="gradButton gray subject_type box">';
		html += '<div class="center-content">';
		html += '<h5>' + subject_type_name + '</h5>';
		html += '</div>';
		html += '</div>';
		return html;
}


/*
				<div class="hero-unit" style="float: inline-block; min-height: 250px; background: #fff; -moz-border-radius: 10px; border-radius: 10px;border: 1px solid #EFEFEF;border-right: 2px solid #EFEFEF; border-bottom: 5px solid #EFEFEF;">
				  <p style="padding-left: 0px;" class="lead">
				  ${flash.operationNotSupported}
				  Based upon the study you picked, here is a list of
				  tools you can use:</p>
				  
				  
	              	<div id="${type.toLowerCase()}" style="float:left; width:33%; padding-left: 20px; ">${type}
		              		<ul>
		             		<g:each in="${operations[type]}" var="operation">
		             			<li><a href="${createLink(controller: operation.controller, action: operation.action)}"><small>${operation.name}</small></a>
		             		</g:each>
	             		</ul>
	             		</div>         		
             		</g:each>				  

				</div>	
*/







function get_html_for_tools(tools) {
		/*
		 *  Generates HTML to display tools grouped by their types
		 *  A simple click of the tools link will take you to its page
		 *
		 */
		
		// This block of code identifies what types exist given this set of tools
		var types = [];
		var i = 0;
         // Fixing compatibility with IE8 and lower
        if(!Array.prototype.indexOf){
            for (i = 0; i < tools.length; i++) {
                if ($.inArray(tools[i].type,types)) {
                    types.push(tools[i].type);
                }
            }
        }
        else{
            for (i = 0; i < tools.length; i++) {

                if (types.indexOf(tools[i].type) == -1) {
                    types.push(tools[i].type);
                }
            }
        }

		

		var html = '<div>';
		html += '<p style="padding:10px 0 0 30px;" class="lead">Based upon the study you picked, here is a list of tools you can use:</p>';
		
		// We now have all types specific to this set of tools
		for (i = 0; i < types.length; i++) {
			
			html += '<div id="'+ types[i].toLowerCase() +'" style="float: left; width:33%; height: 220px; padding-left: 60px; font-size: 15px; font-weight: 200; line-height: 30px;"> <p style="font-size: 18px;">' + types[i] + '</p><ul>';
			
			for (j = 0; j < tools.length; j++) {
			
				if (tools[j].type == types[i]) {
					html += '<li><a id="element'+j+'" style="font-size: 18px; line-height: 30px;"  data-toggle="popover" data-placement="right" data-content="'+ tools[j].description +'" data-trigger="hover" href="' + tools[j].link + '"><small>' + tools[j].name + '</small></a></li>';
				}
			}
		
			html += '<ul></div>';
		}

		html += '</div>';
		
		return html;
}

function get_html_for_data_type(data_type_name, study_count,patient_count,biospecimen_count) {
    var studies = '<b style="font-size: 14px;">'+study_count + '</b> <br/> <i>studies</i>';
    var patients ='<b style="font-size: 14px;">'+ patient_count +'</b>  <br/> <i>samples</i>';
    var biospecimen ='<b style="font-size: 14px;">'+ biospecimen_count + '</b> <br/> <i>biospecimen</i>';

    if (study_count < 2) {
        studies = '<b style="font-size: 14px;">'+ study_count + ' </b> <br/> <i>study</i>';
    }

    var html = '<div id="personalized" class="gradButton gray data_type box">';
    html +='<div>';
    html +='<h5>' + data_type_name + '</h5>';
    html +='</div>';
    html +='<table height="65px" width="230px">';
    html +='<td width="60px" style="padding-left:8px;"><span class="studycount count"><br/>' + studies +'</span></td>';
    html +='<td width="70px"><span class="patientcount count"><br/>' + patients +'</span></td>';
    html +='<td width="80px"><span class="biospecimencount count"><br/>' + biospecimen +'</span></td>';
    html +='</table>';
    html += '</div>';

    return html;

    /*var html = '<div id="personalized" class="gradButton gray data_type box">';
    html += '<div class="center-content">';
    html += '<h5>' + data_type_name + '</h5>';
    html += '<span class="studycount count"><i>' + studies +'</i></span>';
    html += '<span class="patientcount count"><br/><i>' + patients +'</i></span>';
    html += '<span class="biospecimencount count"><br/><i>' + biospecimen +'</i></span>';
    html += '</div>';
    html += '</div>';
    return html;*/
}

