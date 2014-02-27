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

	
	$.ajax({
				url: "/" + app_name + "/studyDataSource/justSetStudy",
				dataType: 'json',
				data: { 
					study: study_id
				},
				success: function() {
						
				},
				error: function(request, status, error) {
					console.log(error)
				},
				complete: function() {
				}
		});
}


function load_studies(success_callback) {

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


function get_html_for_study(study_name, study_long_name) {
		var html = '<div id="personalized" class="gradButton gray workflowBox study">';
		html 	+= '<div class="center-content">';
		html 	+= '<h5>' + study_name + '</h5>';
		html 	+= '</div>';
		html 	+= '<p style="font-size:.8em;padding:0px">' + study_long_name + '</p>';
		html 	+= '</div>';
		return html;
}


function get_html_for_subject_type(subject_type_name) {
		var html = '<div id="personalized" class="gradButton gray workflowBox subject_type">';
		html += '<div class="center-content">';
		html += '<h5>' + subject_type_name + '</h5>';
		html += '</div>';
		html += '</div>';
		return html;
}

function get_html_for_tool(tool_name) {
		var html = '<div id="personalized" class="gradButton gray workflowBox tool">';
		html 	+= '<div class="center-content">';
		html 	+= '<h5>' + tool_name + '</h5>';
		html 	+= '</div>';
		html 	+= '</div>';
		return html;
}

function get_html_for_data_type(data_type_name) {
			var html = '<div id="personalized" class="gradButton gray workflowBox data_type">';
			html += '<div class="center-content">';
			html += '<h5>' + data_type_name + '</h5>';
			html += '</div>';
			html += '</div>';
			return html;
}
