<html>
<head>
    <meta name="layout" content="report" />
    <title><g:message code="clinical.searchResults" /></title>
    <g:javascript library="jquery" plugin="jquery"/>
</head>
<body>
<g:javascript src="jquery/jquery.ui.js" plugin="gcore"/>
<g:javascript src="jquery/jquery.styledButton.js" plugin="gcore"/>
<g:jqgrid />
<g:javascript>
	$(document).ready( function () {
		 // this is unfortunately needed due to a race condition in safari
		 // limit the selector to only what you know will be buttons :)
		$("span.bla").css({
			 'padding' : '3px 20px',
			 'font-size' : '12px'
		});
		$("span.bla").styledButton({
			'orientation' : 'alone', // one of {alone, left, center, right} default is alone
			<g:if test="${session.subgridModel != [:]}">
    'dropdown' : { 'element' : 'ul' },
    'role' : 'select', // one of {button, checkbox, select}, default is button. Checkbox/select change some other defaults
</g:if>
    <g:else>
        'role' : 'button', // one of {button, checkbox, select}, default is button. Checkbox/select change some other defaults
    </g:else>
    'defaultValue' : "foobar", // default value for select, doubles as default for checkboxValue.on if checkbox, default is empty
    'name' : 'testButton', // name to use for hidden input field for checkbox and select so form can submit values
    // enable a dropdown menu, default is none
    'clear' : true // in firefox 2 the buttons have to be floated to work properly, set this to true to have them display in a new line

});
} );

function showSaveSpinner(show) {
    if(show == true){
        $("#saveSpinner").css("visibility","visible");
        success();
    }else{
        $("#saveSpinner").css("visibility","hidden");
        jQuery('#message').css("display","block");
        success();
    }
}
</g:javascript>
<g:javascript>
		var selectedParentIds = {};
		var selectedChildIds = {};
		var currPage = 1;
		var selectAll = false;
		var allParentIds = ${session.allParentIds};
		var allChildIds = ${session.allChildIds};
		var parentChildMap = ${session.parentChildMap};
		$(document).ready(function(){
			jQuery("#searchResults").jqGrid({ 
				url:'view', 
				datatype: "json", 
				colNames:${session.columnNames}, 
				colModel:${session.columnJson}, 
				height: 350,
				rowNum:25,
				rowList:[25,50], 
				pager: jQuery('#pager'),
<g:if test="${session.subjectTypes.timepoints}">
    sortname: 'timepoint',
</g:if>
<g:else>
    sortname: 'id',
</g:else>
viewrecords: true,
sortorder: "desc",
multiselect: true,
beforeSelectRow: function() {
    return false;
},
subGrid: ${session.subgridModel != [:]},
				subGridUrl: 'biospecimen',
				subGridModel: ${session.subgridModel},
				caption: "Search Results",
				onSelectAll: function(all, checked) {
					selectAll = checked;
				},
				onPaging: function(direction) {
					// $(".cbox:checked").each(function() {
					// 	selectedIds[this.id] = this.id;
					// });
				},
				gridComplete: function() {
					currPage = jQuery("#searchResults").getGridParam("page");
					$('#cb_searchResults').attr('checked', selectAll);
					//setSelectAll();
					selectSaved();
					bindCheckboxes();
					$('a[href*="annotationLink"]').each(function() {
						$(this).parent("td").removeAttr("title");
						//console.log($("#" + this.innerHTML.replace(/ /g, "_").replace(/\./, '')));
						this.title = $("#" + this.innerHTML.replace(/ /g, "_").replace(/\./, '')).html();
					});
					$('a[href*="annotationLink"]').click(function(event) {
						event.preventDefault();
					});
					$('a[href*="annotationLink"]').tooltip({
						showURL: false,
						extraClass: 'annotationTooltip'
					});
				},
				onSortCol: function() {
					//selectAll = false;
					selectedIds = {};
				}
			});
<g:if test="${session.subgridModel != [:]}">
    jQuery("#listAdd li").click( function() {
</g:if>
<g:else>
    jQuery("#listAdd").click( function() {
</g:else>
var s = [];
var author = '${session.userId}';

				var selectedItem = this.title;
				var itemType;
				if(selectedItem)
					itemType = this.innerHTML
				else
					itemType = '${session.subjectTypes.parent}';
				var ids;
				if(itemType == '${session.subjectTypes.parent}') {
					ids = selectedParentIds;
				} else {
					ids = selectedChildIds;
				}
				$.each(ids, function(key, value) {
					s.push(key);
				});
				if(s.length == 0) {
					jQuery('#message').html("No IDs selected.")
					jQuery('#message').css("display","block");
					window.setTimeout(function() {
					  jQuery('#message').empty().hide();
					}, 10000);
				} else {
					var tags = new Array();
					tags.push("clinical");
					tags.push(itemType);
					var listName = jQuery('#list_name').val();
					listName = encodeURIComponent(listName);
${remoteFunction(action:'saveFromQuery',controller:'userList', update:'message', onLoading:'showSaveSpinner(true)', onComplete: 'showSaveSpinner(false)', params:'\'ids=\'+ s+\'&author.username=\'+author+\'&tags=\'+tags+\'&name=\'+listName')}
}
});

jQuery("#searchimages").click( function() {
            var s = [];
            var author = '${session.userId}';

            				var selectedItem = this.title;
            				var itemType;
            				if(selectedItem)
            					itemType = this.innerHTML
            				else
            					itemType = '${session.subjectTypes.parent}';
            				var ids;
            				if(itemType == '${session.subjectTypes.parent}') {
            					ids = selectedParentIds;
            				} else {
            					ids = selectedChildIds;
            				}
            				$.each(ids, function(key, value) {
            					s.push(key);
            				});
            				$("#q1").val(s);

            				if(s.length == 0) {
            					jQuery('#messageImaging').html("No IDs selected.")
            					jQuery('#messageImaging').css("display","block");
            					window.setTimeout(function() {
            					  jQuery('#messageImaging').empty().hide();
            					}, 10000);
            				} else {
                                $("#searchImaging").click();
            				}
            		});

			jQuery("#searchResults").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:false, refresh: false,position:'left'});
			jQuery("#searchResults").jqGrid('navButtonAdd','#pager',{
			       caption:"Export results",
			       onClickButton : function () {
				       $('#download').submit();
			       },
				   position:"last"
			});

			if($("#searchResults").width() < 900){
				$("#searchResults").setGridWidth(900);
			}
			if($("#searchResults").width() > 900){
				$("#searchResults").setGridWidth(1050);

			}
			$(document).bind('loadsubgrid', function() {
				bindCheckboxes();
				toggleChildren();
				selectSaved();
			});
		});

		function setSelectAll() {
			var checked = $('#cb_searchResults').attr('checked');
			jQuery("#searchResults").resetSelection();
			if(checked) {
				jQuery('#searchResults tbody tr').each(function() {
					jQuery("#searchResults").setSelection(this.id);
				});
				$('#searchResults tbody tr ui-widget-content').addClass("ui-state-highlight");
				$(".ui-subtblcell").addClass("ui-state-highlight");
				addAllIds();
			} else {
				$('#searchResults tbody tr ui-widget-content').removeClass("ui-state-highlight");
				$(".ui-subtblcell").removeClass("ui-state-highlight");
				selectedParentIds = {};
				selectedChildIds = {};
			}
			$(".cbox").attr('checked', checked);
			selectAll = checked;
		}
		function success() {
			jQuery('#list_name').val("");
			window.setTimeout(function() {
			  jQuery('#message').empty().hide();
			}, 10000);
		}

		function bindCheckboxes() {
			$('.cbox').unbind('click');
			$('.cbox').bind('click', function(event) {
				if(this.id == "cb_searchResults") {
					setSelectAll();
					return;
				}
				var checked = $(this).attr('checked');
				var parent = $(this).closest("tr");
				var sub = parent.next("tr");
				var id = getIdFromCheckboxId(this.id);
				if(checked) {
					if($(this).hasClass("subcbox")) {
						selectedChildIds[id] = id;
					} else {
						selectedParentIds[id] = id;
						if(${session.subgridModel != [:]}) {
							// Add children
							$.each(parentChildMap[id], function(index, childId) {
								selectedChildIds[childId] = childId;
							});
						}
					}
					parent.addClass("ui-state-highlight");
					if(sub.hasClass("ui-subgrid")) {
						sub.find(".cbox").each(function() {
							var childId = getIdFromCheckboxId(this.id);
							$(this).attr('checked', checked);
							selectedChildIds[childId] = childId;
						});
						sub.find("tr").addClass("ui-state-highlight");
					}
				} else {
					$('#cb_searchResults').attr('checked', false);
					selectAll = false;
					if($(this).hasClass("subcbox")) {
						delete selectedChildIds[id];
					} else {
						if(selectedParentIds[id])
							delete selectedParentIds[id];
						if(${session.subgridModel != [:]}) {
							// remove children
							$.each(parentChildMap[id], function(index, childId) {
								if(selectedChildIds[childId])
									delete selectedChildIds[childId];
							});
						}
					}
					parent.removeClass("ui-state-highlight");
					if(sub.hasClass("ui-subgrid")) {
						sub.find(".cbox").each(function() {
							var childId = getIdFromCheckboxId(this.id);
							$(this).attr('checked', checked);
							delete 	selectedChildIds[childId];
						});
						sub.find("tr").removeClass("ui-state-highlight");
					}
				}
			});
		}

		function toggleChildren() {
			$(".cbox:checked").each(function() {
				var parent = $(this).closest("tr");
				var sub = parent.next("tr");
				if(sub.hasClass("ui-subgrid")) {
					sub.find(".cbox").attr('checked', true);
					sub.find("tr").addClass("ui-state-highlight");
				}
			});
		}

		function selectSaved() {
			jQuery("#searchResults").resetSelection();
			$('#cb_searchResults').attr('checked', selectAll);
			$.each(selectedParentIds, function(key, value) {
				$("#jqg_searchResults_" + key).attr("checked", true).closest("tr").addClass("ui-state-highlight");
				jQuery("#searchResults").setSelection(key);
			})
		}

		function addAllIds() {
			$.each(allParentIds, function(key, value) {
				selectedParentIds[key] = key;
			})
			$.each(allChildIds, function(key, value) {
				selectedChildIds[key] = key;
			})
		}

		function getIdFromCheckboxId(cbox) {
			return cbox.substring(cbox.lastIndexOf("_") + 1);
		}

		function GetSelectedIds() {
            				var s = [];
            				var author = '${session.userId}';

            				var selectedItem = this.title;
            				var itemType;
            				if(selectedItem)
            					itemType = this.innerHTML
            				else
            					itemType = '${session.subjectTypes.parent}';
            				var ids;
            				if(itemType == '${session.subjectTypes.parent}') {
            					ids = selectedParentIds;
            				} else {
            					ids = selectedChildIds;
            				}
            				$.each(ids, function(key, value) {
            					s.push(key);
            				});
            				$("#q1").val(s);

            				if(s.length == 0) {
            					jQuery('#messageImaging').html("No IDs selected.")
            					jQuery('#messageImaging').css("display","block");
            					window.setTimeout(function() {
            					  jQuery('#messageImaging').empty().hide();
            					}, 10000);
            				} else {
            				}
            		}

</g:javascript>
<g:each in="${session.annotations}">
    <g:if test="${it.value}">
        <div id="${it.key.replace(' ', '_').replace('.', '')}" style="display: none;" align="left">
            Cell Line Details:<br/>
            <g:each in="${it.value.organizedData().sort { it.key }}" var="ann">
                ${ann.key}: ${ann.value}<br/>
            </g:each>
        </div>
    </g:if>
</g:each>
<div class="welcome-title"><g:message code="clinical.searchResults" /></div>
<div class="desc1"><g:message code="gcore.currentStudy" />:
<g:if test="${!session.study}"><g:message code="gcore.noStudy" /></g:if>
${session.study?.shortName}
</div>
<div id="centerContent">

    <g:if test="${!session.results}">
        <g:message code="clinical.noResults" />
    </g:if>
    <g:else>
        <g:if test="${session.userId}">
            <g:if test="${session.study}">
                <span id="Study" style="display:none">${session.study.schemaName}</span>
            </g:if>
            <g:form name="download" action="download">
            </g:form>

            <g:clinicalView label="Genotype"/>

            <div>
                <span style="vertical-align:5px"> <label for="list_name"><g:message code="clinical.listName" />:</label>
                <g:textField name="list_name" size="15" maxlength="15"/>
                </span>
                <span class="bla" id="listAdd">
                    <g:if test="${session.subgridModel != [:]}">
                        <g:message code="clinical.listSave" /> ⇣
                        <ul>
                            <li title="parent">${session.subjectTypes.parent}</li>
                            <li title="child">${session.subjectTypes.child}</li>
                        </ul>
                    </g:if>
                    <g:else>
                        <g:message code="clinical.listSave" />
                    </g:else>
                </span><br />

                <span id="message" style="display:none"></span>
                <span id="saveSpinner" style="visibility:hidden"><img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Wait'/></span>

                <g:if test="${session.study.hasImagingData()}"><br />This study has Imaging Data. Please select a Patient or a Group of Patients to explore their Imaging data.</br>
                    <span class="bla" id="searchimages"> View Images </span>
                    <span id="messageImaging" style="display:none"></span>
                    <g:form controller="Dicom" action="index" >
                        <g:hiddenField name="patid" id="q1" value=""/><g:hiddenField name="modality" id="modality" /><g:hiddenField name="gender" id="gender" /><g:hiddenField name="studyiuid" id="studyiuid" /><g:hiddenField name="age" id="age" />
                        <g:submitButton name="search" id="searchImaging" value="View Images" onclick="GetSelectedIds()" style="visibility: hidden" />
                    </g:form>
                </g:if>

            </div>
        </g:if>

        <table id="searchResults" class="scroll" cellpadding="0" cellspacing="0"></table>
        <div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
    </g:else>

</div>

</body>
</html>