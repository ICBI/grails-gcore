

<jq:plugin name="tooltip"/>
<jq:plugin name="ui"/>
<g:javascript>
	var count = 0;
	var targetField = "";
	$(document).ready(function (){
		$('.info').tooltip({showURL: false});
		$('.close').click(function() {
			$(this).parents('.clinicalSearch').hide('slow');
		});
		$('#sfSubmit').click(function() {
			$('#filterResults').html("<span><img src='${createLinkTo(dir:'images',file:'295.gif')}' border='0' /></span>");
		});
		$('.splitAtt').change(function() {
			var splitAtt = $(this).val();
			console.log(splitAtt);
			if ($('input:checkbox:checked').length == 0){
				console.log("no checkboxes, refresh page");
				window.location = "/gdoc/clinical?splitAttribute="+splitAtt;
			}
			else{
				$('#splitAttribute').val($(this).val());
				var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
				//console.log($('#splitAttribute').val());
				$('#sfSubmit').click();
			}
			
		});
		//send request based on checbox click
		$('.cb').click(function() {
			if($(this).is(":checked")){
				var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
				console.log(pageurl);
				//then create breadcrumb
				//console.log($(this).val());
				addToBreadcrumb($(this).val());
				$('#sfSubmit').click();
			}else{
				var simName = $(this).attr("name");
				var substr = $(this).attr('id').split('vocab_')[1];
				var arr = [];
				$("input[name*="+simName+"]").each(function() { 
					//console.log($(this).attr('type'));
					 if($(this).attr('type')=='checkbox' && $(this).is(':checked')){
						//console.log('checked');
						arr.push("1");
					}
				 });
				console.log(arr.length);
				if(arr.length < 1){
					$("input[id*="+substr+"_category]").attr('checked', false);
				}else{
					$("input[id*="+substr+"_category]").attr('checked', true);
				}
				//$("input[id*="+substr+"_category").each(function() { 
				//	console.log($(this).attr('name'));
				//	 $(this).attr('checked', true);
				// });
				removeBreadcrumb($(this).val());
			}
			
		});
		//send request based on key for numerical ranges
		//stub here
		
		$("input[name*='_range_']").each(function() { 
			if($(this).attr('type')!='hidden'){
				var rangeArray = $(this).val().split(" - ");
				var low = parseInt(rangeArray[0]);
				var up = parseInt(rangeArray[1]);
				//console.log(low + " - "+up);
				$(this).val(low + " - "+up)
			}
			
		});
		
		//iterate over checkboxes to pre-check the category (eg....'Male' is checked, so check 'Gender')
		$('.cb').each(function() {
			if($(this).is(":checked")){
				var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
				//console.log(pageurl);
				//then create breadcrumb
				//console.log($(this).val());
				addToBreadcrumb($(this).val());
				$('#sfSubmit').click();
			}else{
				//console.log('not checked');
			}

		});
		
		//select/unselect all under appropriate category and do a query 
		$('.category').click(function() {
			if($(this).is(":checked")){
				var substr = $(this).attr('id').split('_category')[0];
				$("#"+substr+"_div").find('input:checkbox').attr('checked', 'checked');
				var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
				addToBreadcrumb(substr);
				$('#sfSubmit').click();
			}else{
				var substr = $(this).attr('id').split('_category')[0];
				$("#"+substr+"_div").find('input:checkbox').attr('checked', false);
				removeBreadcrumb(substr);
			}	
		});
		
		//show attributes that are hidden from view
		$('.more').click(function() {
			var elId = $(this).attr('id');
			if($("#"+elId+"_div").css('display') == 'none'){
				console.log(elId+"_div");
				//$("#"+elId+"_div").css('display','block');
				$("#"+elId+"_div").css('display','block');
			}
			else{
				console.log("hide "+elId);
				$("#"+elId+"_div").css('display','none');
			}
		});
		$('.slider-range').each(function() {
			var upper = parseInt(jQuery(this).data("maxval"));
			var lower = parseInt(jQuery(this).data("minval"));
			var lowerVal = lower;
			var upperVal = upper;
			var rangeInput = jQuery(this).parents('div').children('.rangeValue');
			if(rangeInput.val()) {
				var values = rangeInput.val().split(' - ');
				lowerVal = values[0];
				upperVal = values[1];
			} else {
				rangeInput.val(lower + ' - ' + upper);
			}
			jQuery(this).slider({
				range: true,
				min: lower,
				max: upper,
				values: [lowerVal, upperVal],
				slide: function(event, ui) {
								rangeInput.val(ui.values[0] + ' - ' + ui.values[1]);
				}
			});
		});
		
		$(":input").each(function(index){
			$(this).keypress(function(e){
	      		if(e.which == 13){
					//alert($('#searchForm') + "  submit");
					$(this).blur();
					e.preventDefault();
	       			$('#submit').focus().click();
					
	       		}
	      	});
		});
		var vars = [], hash;
		var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
		if(hashes.length <= 1){
			
			//console.log($("input[name="+targetField+"]"));
			var targetElem = $("input[name="+targetField+"]");
			$("input[name=splitAttribute]").val("");
			targetElem.attr("checked","checked");
			var substr = targetElem.attr('id').split('_category')[0];
			console.log("target field is "+substr+"_div");
			$("#"+substr+"_div").find('input:checkbox').attr('checked', 'checked');
			//$("input[name*="+substr+"]").each(function() { 
				//console.log($(this).attr('name'));
			//	 $(this).attr('checked', true);
			// });
			$('#sfSubmit').click();
		}
		
		
		
	});

//keep track of request params so user can navigate to page again and reproduce query with URL
function check(form){
	$("#sf").attr('method','GET');
	$("input[id*='_category']").each(function() { 
		$(this).attr('disabled','disabled');
	});
	var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
	//console.log(pageurl);
	window.history.pushState({test:pageurl},'',pageurl);
	return false;
}

//add criteria to breadcrumb
function addToBreadcrumb(termId){
	//console.log("add to breadcrumb");
	var formSerialized = $("#sf :input[value]").serialize().split("&");
	var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
	$.each(formSerialized,function(index){
		console.log(formSerialized[index]);
	});
	$(".breadcrumbs").append("<a class='crumb' href='# style='cursor:pointer' id='"+termId+"_crumb'"+">"+termId+" ></a>&nbsp&nbsp");
	$("#"+termId+"_crumb").click(function(){
	         // do something
	         // For example, you could place an AJAX call here:
	        $.ajax({
	          type: "POST",
	          url: pageurl,
	          success: function(msg){
	            //console.log(msg);
				$("#filterResults").html(msg);
	          }
	       });
	   });
	
}

//remove criteria from breadcrumb
function removeBreadcrumb(termId){
	$("#"+termId+"_crumb").remove();
	//console.log("remove breadcrumb");
	if ($('input:checkbox:checked').length == 0){
		var splitAtt = $('#splitAttribute').val();
		console.log("no checkboxes, refresh page");
		window.location = "/gdoc/clinical?splitAttribute="+splitAtt;
	}else{
		var pageurl = "/gdoc/clinical/filter?" + $("#sf :input[value]").serialize();
		$('#sfSubmit').click();
	}
	
}

function cleanUp(){
	//console.log('clean up');
	$("input[id*='_category']").each(function() { 
		$(this).removeAttr('disabled');
	});
	displayFilterTable();
	var targetElem = $("input[name="+targetField+"]");
	targetElem.attr("checked","checked");
	var substr = targetElem.attr('id').split('_category')[0];
	$("input[name*="+substr+"]").each(function() { 
		//console.log($(this).attr('name'));
		 $(this).attr('checked', false);
	 });
	$("input[name=splitAttribute]").val(substr);
}


</g:javascript>

<g:if test="${session.study}">
<g:formRemote id="sf" name="searchForm" url="[controller: 'clinical', action:'filter']" before="check(this)" update="filterResults" onComplete="cleanUp()">
	<g:if test="${session.subjectTypes.timepoints}">
	<div class="clinicalSearch">
		<div style="float: left">
			Timepoint
			<img class="info" title="Timepoint" src="${createLinkTo(dir:'images',file:'information.png')}" border="0" />
		</div>
	
	<br/>
	<br/>
		<div align="left">
			<g:if test="${flash.params}">
				<g:select name="timepoint" 
						noSelection="${['':'Select One...']}" value="${flash.params['timepoint']}"
						from="${session.subjectTypes.timepoints}" >
				</g:select>
			</g:if>
			<g:else>
				
				<g:select name="timepoint" 
						noSelection="${['':'Select One...']}"
						from="${session.subjectTypes.timepoints}">
				</g:select>
			</g:else>
		</div>
		<br/>
	</div>
	</g:if>
	<g:each in="${session.groups}" var="types">
		<span style="font-weight:bold;cursor:pointer" class="group" >${types.key}</span><br/>
		
		<g:each in="${types.value}" status="i" var="it">
			<g:set var="use" value="false"/>
			
			<g:if test="${it.target == session.subjectTypes.parent.value()}">
				<g:set var="type" value="parent"/>
			</g:if>
			<g:else>
				<g:set var="type" value="child" />
			</g:else>
			<g:if test="${i == 3}">
				<span class="more" id="${types.key}" style="cursor:pointer">${types.value.size()-3} more...<br /></span>
				<span id="${types.key+'_div'}" style="display:none" >
				<br />
			</g:if>
			<g:if test="${(session.splitAttribute && session.splitAttribute!=it.shortName) || (!session.splitAttribute && !session.cohort)}">
					<g:set var="use" value="block"/>
			</g:if>
			<g:else>
					<g:set var="use" value="none"/>
					<g:javascript>
						targetField = "${type.replace('_','') + '_category_' + it.shortName}";
					</g:javascript>
			</g:else>
			<div class="clinicalFilter" style="display:${use}" id="${it.shortName+'_div'}">
				<div>
				<g:checkBox name="${type.replace('_','') + '_category_' + it.shortName}" value="${it.shortName}" checked="false" id="${it.shortName}_category" class="category"/>
				<label for="${type.replace('_','') + '_category_' + it.shortName}">${it.longName}</label>
				<img class="info" title="${it.definition}" src="${createLinkTo(dir:'images',file:'information.png')}" border="0" />
				</div>
				<g:if test="${it.vocabulary}">
					<div align="left">
						<g:if test="${flash.params}">
							<g:select class="att" name="${type + '_vocab_' + it.shortName}" 
									noSelection="${['':'Select One...']}" value="${flash.params[type + '_' + it.shortName]}"
									from="${it.vocabs.findAll{item -> session.usedVocabs[it.id]?.contains(item.term)}.sort{it.term}}" optionKey="term" optionValue="termMeaning" multiple="true">
							</g:select>
						</g:if>
						<g:else>
							
							
							<g:each in="${it.vocabs.findAll{item -> session.usedVocabs[it.id]?.contains(item.term)}.sort{it.term}}" var="v" status="j">
							    <span style="display:block">
								<g:if test="${outcome && it.shortName==outcome}">
							    &nbsp;
								</g:if>
								<g:else>
								<g:checkBox name="${type.replace('_','') + '_vocab_' + it.shortName}" value="${v.term}" checked="${params[type + '_vocab_' + it.shortName] == v.term}" class="cb" />
							    <label for="${type.replace('_','') + '_vocab_' + it.shortName}">${v.termMeaning}</label>
								</g:else>
								</span>
							</g:each>
							
							
						</g:else>
					</div>
					<br/>
				</g:if>
				<g:elseif test="${it.qualitative}">
					<g:if test="${flash.params}">
						<g:textField class="att" name="${type + '_' + it.shortName}"  value="${flash.params[type + '_' + it.shortName]}"/>
					</g:if>
					<g:else>
						<g:textField class="att" name="${type + '_' + it.shortName}"  />
					</g:else>
					<br/>
				</g:elseif>
				<%--g:elseif test="${it.lowerRange != null && it.upperRange != null}">
					<div align="left">
						<label for="rangeValue" style="padding-left: 0px">Range:</label>
						
						<g:if test="${flash.params}">
							<g:textField name="${type + '_range_' + it.shortName}" class="rangeValue" value="${flash.params[type + '_range_' + it.shortName]}" style="border:0; font-weight:bold; background: #E6E6E6;"  />
						</g:if>
						<g:else>
							<g:textField name="${type + '_range_' + it.shortName}" class="rangeValue" style="border:0; font-weight:bold; background: #E6E6E6;"  />
						</g:else>
						<br/>
						<br/>
						<table>
							<tr>
								<td style="padding-right: 10px">${it.lowerRange}</td>
								<td>
									<div class="slider-range" style="width: 150px"></div>
								</td>
								<td style="padding-left: 10px">${it.upperRange}</td>
							</tr>
						</table>
					</div>
					<script type="text/javascript">
						count = count + 1;
						//console.log(count);
						var item = jQuery('.slider-range').get(count - 1); 
						//console.log(jQuery('.slider-range').size() - 1);
						jQuery(item).data("minval", "${it.lowerRange}");
						jQuery(item).data("maxval", "${it.upperRange}");
					</script>
					<br/>
				</g:elseif--%>
				<g:else>
					<g:set var="median" value='${(it.lowerRange+it.upperRange)/2}' />
						<span style="display:none">
						<span>Low Range</span>
						<g:checkBox name="${type.replace('_','') + '_range_' + it.shortName}" checked="${params[type + '_' + it.shortName]}" class="cb" value="${it.lowerRange + ' - ' +median}" />
						<label for="${type.replace('_','') + '_' + it.shortName}">${it.lowerRange + ' to ' +median}</label>
						<br />
						<span>High Range</span>
						<g:checkBox name="${type.replace('_','') + '_range_' + it.shortName}" checked="${params[type + '_' + it.shortName]}" class="cb" value="${median + ' - ' +it.upperRange}" />
						<label for="${type.replace('_','') + '_' + it.shortName}">${median + ' to ' +it.upperRange}</label>
						</span>
						
						
				</g:else>
				
			</div>
	
			<g:if test="${i == types.value.size()-1}">
				</span><br />
			</g:if>
			
		</g:each>
		
	</g:each>
	
	
	<g:hiddenField name="splitAttribute" id="splitAttribute" value="${session.splitAttribute}" />
	
	<br/>
	<br/>
	<g:submitButton name="submit" id="sfSubmit" class="submit" value="${message(code: 'gcore.submit')}"/>
</g:formRemote>
</g:if>

<g:else>
<p><g:message code="gcore.noStudy" /></p>
</g:else>

