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

function get_html_for_tools(tools) {
		var html = '';
		
		for (var i = 0; i < tools.length; i++) {
			html += '<a style="none" href="' + tools[i].link + '"><div id="personalized" class="gradButton gray tool box">';
			html += '<div class="center-content">';
			html += '<h5>' + tools[i].name + '</h5>';
			html += '</div>';
			html += '</div></a>';	
		}
		
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
