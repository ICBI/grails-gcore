<html>
    <head>
        <meta name="layout" content="report" />
        <title><g:message code="clinical.searchResults" /></title>      
<g:javascript library="jquery"/>   
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
				sortname: 'id', 
				viewrecords: true, 
				sortorder: "desc", 
				multiselect: true, 
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
						console.log($("#" + this.innerHTML.replace(/ /g, "_")));
						this.title = $("#" + this.innerHTML.replace(/ /g, "_")).html();
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
			jQuery("#searchResults").jqGrid('navGrid','#pager',{add:false,edit:false,del:false,search:false, refresh: false,position:'left'});
			jQuery("#searchResults").jqGrid('navButtonAdd','#pager',{
			       caption:"Export results", 
			       onClickButton : function () { 
				       $('#download').submit();
			       },
				   position:"last"
			});
			
			if($("#searchResults").width() < 300){
				$("#searchResults").setGridWidth(700);
			}
			if($("#searchResults").width() > 900){
				$("#doc3").css("width",$("#searchResults").width()+70);
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
						delete selectedParentIds[id];
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
	</g:javascript>
	<br/>
	<g:each in="${session.annotations}">
		<g:if test="${it.value}">
			<div id="${it.key.replace(' ', '_')}" style="display: none;" align="left">
				Cell Line Details:<br/>
				<g:each in="${it.value.data.sort { it.type }}" var="ann">
					${ann.type}: ${ann.value}<br/>
				</g:each>
			</div>
		</g:if>
	</g:each>
	<p style="font-size:14pt"><g:message code="clinical.searchResults" /></p>
	<div id="centerContent">
		<br/>
			<p style="font-size:12pt"><g:message code="gcore.currentStudy" />: 
			<span id="label" style="display:inline-table">
				<g:if test="${!session.study}"><g:message code="gcore.noStudy" /></g:if>
				${session.study?.shortName}
			</span>
			</p>
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
				<div style="margin:5px 5px 5px 50px">
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
				</div>
				</div>
				</g:if>
				<table id="searchResults" class="scroll" cellpadding="0" cellspacing="0"></table>
				<div id="pager" class="scroll" style="text-align:center;height: 45px"></div>
			</g:else>
			<br/>
			<br/>
	</div>

	</body>
	
</html>