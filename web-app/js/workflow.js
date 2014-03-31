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
				success: function() {
						
				},
				error: function(request, status, error) {
					console.log('function set_study(study_id) has failed. Here is the reason: ' + error);
				},
				complete: function() {
				}
		});
}


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

		var html = '<div id="personalized" class="gradButton gray study box">';
		html 	+= '<h5>' + study.studyName + '</h5>';
		html 	+= '<p class="_title"><b>Title: </b>' + study.studyLongName + '</p>';
		html 	+= '<p class="abstract"><b>Abstract: </b>' + study.abstract + '</p>';
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
		var i;
		for (i = 0; i < tools.length; i++) {
		
			if (types.indexOf(tools[i].type) == -1) {
				types.push(tools[i].type);
			}
		}
		
		
		var html = '<div class="hero-unit" style="float: inline-block; min-height: 250px; background: #fff;">';
		html += '<p style="padding-left: 0px;" class="lead">Based upon the study you picked, here is a list of tools you can use:</p>';
		
		// We now have all types specific to this set of tools
		for (i = 0; i < types.length; i++) {
			
			html += '<div id="'+ types[i].toLowerCase() +'" style="float: left; width:33%; padding-left: 20px; ">' + types[i] + '<ul>';
			
			for (j = 0; j < tools.length; j++) {
			
				if (tools[j].type == types[i]) {
					html += '<li><a href="' + tools[j].link + '"><small>' + tools[j].name + '</small></a></li>';	
				}
			}
		
			html += '<ul></div>';
		}

		html += '</div>';
		
		return html;
}

function get_html_for_data_type(data_type_name, study_count) {
			var studies = study_count + ' studies available';
			
			if (study_count < 2) {
				studies = study_count + ' study available';
			}

			var html = '<div id="personalized" class="gradButton gray data_type box">';
			html += '<div class="center-content">';
			html += '<h5>' + data_type_name + '</h5>';
			html += '<span class="studycount count"><i>' + studies +'</i></span>';
			html += '</div>';
			html += '</div>';
			return html;
}
