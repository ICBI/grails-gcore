<jq:plugin name="tooltip"/>
<jq:plugin name="ui"/>
<g:javascript>
	var count = 0;
	var targetField = "";
	var breadcrumbs = [];
	$(document).ready(function (){
		$('.info').tooltip({showURL: false});
		$('.close').click(function() {
			$(this).parents('.clinicalFilter').hide('slow');
		});
		
		//submit the form
		$('#sfSubmit').click(function() {
			console.log("clicked");
			$(":input[value='']").attr('disabled', true);
			// var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value][value!='']").serialize();
			// 			console.log("2 url "+pageurl);
			// 			window.history.pushState({test:pageurl},'',pageurl);
			$.blockUI({ message: '<h3><img style="height: 15px" src="<%= createLinkTo(dir:"images",file:"indicator.gif", plugin: "gcore") %>" border="0" /> Filtering subjects...</h3>' }); 
			//$('#filterResults').html("<span><img src='${createLinkTo(dir:'images',file:'295.gif')}' border='0' /></span>");
		});
		$('.splitAtt').chosen().change(function() {
			var splitAtt = $(this).val();
			//console.log(splitAtt);
			if ($('input:checkbox:checked').length == 0){
				//console.log("no checkboxes, refresh page");
				window.location = "${grailsApplication.config.grails.serverURL}/clinical?splitAttribute="+splitAtt;
			}
			else{
				//console.log("split attribute was "+$('#splitAttribute').val());
				var showDivName = $('#splitAttribute').val()+"_div";
				$('#splitAttribute').val(splitAtt);
				var hideDivName = splitAtt+"_div";
				var hideElementId = splitAtt+"_category";
				//console.log("set new target field? "+$("#"+hideElementId).attr("name"));
				targetField = $("#"+hideElementId).attr("name");
				//$("#"+showDivName).css('display','block');
				//$("#"+hideDivName).css('display','none');
				$("#"+hideDivName).attr("disabled",true);
				//console.log("split attribute is "+$('#splitAttribute').val());
				var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value]").serialize();
				//console.log(pageurl);
				$('#sfSubmit').click();
			}
			
		});
		
		//send request based on checbox click
		$('.cb').bind('click',function() {
			//console.log("checked a cb box");
			if($(this).is(":checked")){
				var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value]").serialize();
				var substr = "";
				if($(this).attr('id').indexOf("vocab_") !=-1){
					substr = $(this).attr('id').split('vocab_')[1];
				}
				if($(this).attr('id').indexOf("range_") !=-1){
					substr = $(this).attr('id').split('range_')[1];
				}
				if($(this).attr('id') == 'timepoint'){
					substr = 'timepoint'
				}
				substr=substr.replace(/\//g,"\\/");
				$("input[id*="+substr+"_category]").attr('checked', true);
				//then create breadcrumb
				//console.log($(this).val());
				addToBreadcrumb($(this).attr("name"),$(this).val(),false);
				$('#sfSubmit').click();
				$("#sf :input").attr("disabled", true);
			}else{
				evaluateUnchecked($(this));
			}
			
		});
		
		//parse all ranges as floats
		$("input[name*='_range_']").each(function() { 
			if($(this).attr('type')!='hidden'){
				var rangeArray = $(this).val().split(" - ");
				var low = parseFloat(rangeArray[0]);
				var up = parseFloat(rangeArray[1]);
				$(this).val(low + " - "+up)
			}
			
		});
		
		//iterate over checkboxes to pre-check the category (eg....'Male' is checked, so check 'Gender'), then submit form
		$('.cb').each(function() {
			if($(this).is(":checked")){
				console.log("coming from cb "+$(this).val());
				var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value]").serialize();
				$('#sfSubmit').click();
			}
		});
		
		//select/unselect all under appropriate category and do a query 
		$('.category').click(function() {
			if($(this).is(":checked")){
				//console.log("checked a category");
				var substr = $(this).attr('id').split('_category')[0];
				substr=substr.replace(/\//g,"\\/");
				$("#"+substr+"_div").find('input:checkbox').attr('checked', 'checked');
				var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value]").serialize();
				addToBreadcrumb($(this).attr("name"),"All",false);
				$('#sfSubmit').click();
				//$("#sf :input").attr("disabled", true);
			}else{
				//console.log("unchecked a category");
				var substr = $(this).attr('id').split('_category')[0];
				substr=substr.replace(/\//g,"\\/");
				$("#"+substr+"_div").find('input:checkbox').attr('checked', false);
				removeBreadcrumb($(this).attr("name"),"All",true);
				//$('#sfSubmit').click();
			}	
		});
		
		//show attributes that are hidden from view
		$('.more').click(function() {
			//console.log($(this).attr("rel"));
			var targetClass = $(this).attr("rel");
			if($("."+targetClass).css("display")=="none"){
				$("."+targetClass).css("display","block");
			}
			else{
				$("."+targetClass).css( "display","none" );
			}
			return false;
		});
		
		
		//on each click , submit the form ... TODO possibly remove
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
		
		
		$('.clueLink').click(function() {
			//console.log($(this).attr("rel"));
			var targetClass = $(this).attr("rel");
			$("."+targetClass).toggle( "blind", null, 500 );
			return false;
		});
		
		
		//on page load provide deeplinks...look at checked fields based on url and submit form
		var vars = [], hash;
		//console.log("split the href and serialize arrayz");
		
			var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
			if(hashes.length <= 1){
				//console.log("targetField"+targetField)
				var targetElem = $("input[name="+targetField+"]");
				$("input[name=splitAttribute]").val("");
				targetElem.attr("checked","checked");
				var substr = targetElem.attr('id');
				if(substr != undefined){
					substr = substr.split('_category')[0];
					//console.log("target field is "+substr);
					$("#"+substr+"_div").find('input:checkbox').attr('checked', 'checked');
					$("#sf :input[value][value!='']").serialize();
					//console.log($("#sf :input[value]").serialize());
					$('#sfSubmit').click();
					//$("#sf :input").attr("disabled", true);
				}else{
					//console.log("nada");
					//$("#sf :input[value][value!='']").serialize();
					$('#sfSubmit').click();
				}
			}else{
				console.log("hashes are"+hashes);
			}	
		
		
		
		
		
	});

//keep track of request params so user can navigate to page again and reproduce query with URL
function check(form){
	console.log("check before submit");
	$("#sf").attr('method','GET');
	// $("input[id*='_category']").each(function() { 
	// 		$(this).attr('disabled','disabled');
	// 	});
	var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value][value!='']").serialize();
	//console.log("url "+pageurl);
	window.history.pushState({test:pageurl},'',pageurl);
	return false;
}

//add criteria to breadcrumb TODO: make this cleaner
function addToBreadcrumb(name,value,removal){
	//var formSerialized = $("#sf :input[value][val]").serialize().split("&");
	
	var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value][value!='']").serialize();
	//console.log("add "+name+"&"+value);
	var crumbId = (name+"--"+value).replace(/ /g,"__");
	crumbId = crumbId.replace(/\./g,"_dot_");
	var nameTrunc = ""
	if(name.indexOf("vocab_") != -1){
		nameTrunc = name.split("vocab_")[1];
	}
	if(name.indexOf("range_") != -1){
		nameTrunc = name.split("range_")[1];
	}
	if(name.indexOf("_category") != -1){
		nameTrunc = name.split("category_")[1];
	}
	var crumbLabel = ""
	if(removal){
		crumbLabel = nameTrunc+"("+value+" removed) >";
	}
	else{
		crumbLabel = nameTrunc+"("+value+") >";
	}
	if(removal){
		crumbId = crumbId+"_rem";
	}
	//console.log("label is "+crumbLabel);
	var existingNumberBC = 0;
	if(breadcrumbs.length > 0){
		$.each(breadcrumbs, function(key, value) { 
		  //console.log(key + ': ' + value); 
		  if(value.indexOf(crumbId) != -1){
			existingNumberBC++;
		  }
		});
	}
	if(crumbId.indexOf("_category_")!=-1){
		crumbId = crumbId;
	}
	else{
		crumbId = crumbId + "_x_" + (existingNumberBC);
	}
	
	$(".breadcrumbs").append("<span style='padding-right:10px;border:0px solid black' class='crumb' id='"+crumbId+"_crumb'"+"><a href='' style='cursor:pointer;text-decoration:none;color:#666666'>"+crumbLabel+"</a></span>");
	breadcrumbs.push(crumbId);
	//console.log("added "+crumbId+" to breadcrumbs "+breadcrumbs+" with a page url of "+pageurl);
	
	var findCrumb = crumbId;
	findCrumb=findCrumb.replace(/\//g,"\\/");
	$("#"+findCrumb+"_crumb").click(function(){
	        
	        $.ajax({
	          type: "POST",
	          url: pageurl,
	          success: function(msg){
	            //console.log(msg);
				//console.log("request and replaceState the url with"+pageurl);
				$("#filterResults").html(msg);
				displayFilterTable();
				history.replaceState(null, null, pageurl);
				//console.log("split page attribute");
				var sa = pageurl.split("splitAttribute=")[1];
				//console.log("show will be"+$("#user_switchAttribute").val());
				var showDivName = $("#user_switchAttribute").val()+"_div";
				var hideDivName = sa+"_div";
				var hideElementId = sa+"_category";
				//console.log("succes,set new target field? "+$("#"+hideElementId).attr("name"));
				targetField = $("#"+hideElementId).attr("name");
				$("#"+showDivName).css('display','block');
				$("#"+hideDivName).css('display','none');
				$("#user_switchAttribute").val(sa);
				verifyURLParams(pageurl);
	          }
	       });
			var tbdCrumbs = [];
			var startAdding = false;
			for(var b=0;b<breadcrumbs.length;b++){
				//console.log(breadcrumbs[b]);
				if(startAdding){
					//console.log("add "+breadcrumbs[b]+ " to remove stack");
					tbdCrumbs.push(breadcrumbs[b]);
				}
				if(breadcrumbs[b]==crumbId){
					startAdding = true;
				}
			}
			//console.log("tbd crumbs "+tbdCrumbs);
			for(var r=0;r<tbdCrumbs.length;r++){
				//$("#"+tbdCrumbs[r]+"_crumb").remove();
				var tbdcrumb=tbdCrumbs[r];
				tbdcrumb=tbdcrumb.replace(/\//g,"\\/");
				//console.log("removed "+"#"+tbdcrumb+"_crumb");
				var delElementArray = tbdCrumbs[r].split("--");
				var delName = delElementArray[0];
				var delValue = delElementArray[1];
				removeBreadcrumb(delName,delValue,false);
			}
			//$('#filterResults').html("<span><img src='${createLinkTo(dir:'images',file:'295.gif')}' border='0' /></span>");
			$.blockUI({ message: '<h3><img style="height: 15px" src="<%= createLinkTo(dir:'images',file:'indicator.gif', plugin: 'gcore') %>" border="0" /> Filtering subjects...</h3>' }); 
			return false;
	   });
	
}

//remove criteria from breadcrumb
function removeBreadcrumb(name,value,refreshData){
	//console.log("remove "+name+" and "+value);//+", from "+breadcrumbs);
	if ($('input:checkbox:checked').length == 0){
		var splitAtt = $('#splitAttribute').val();
		//console.log("no checkboxes, refresh page");
		window.location = "${grailsApplication.config.grails.serverURL}/clinical?splitAttribute="+splitAtt;
	}else{
		//clean name
		if(name.indexOf("_category_")!=-1){
			//console.log("it's a category,clean name");
			var cleanedName = name.split("_category_")[1];
			//console.log("is "+cleanedName+" now equal to "+value+"?");
			if(cleanedName == value){
				value = "All";
			}
		}
		var crumbId = (name+"--"+value).replace(/ /g,"__");
		crumbId=crumbId.replace(/\//g,"\\/");
		//console.log("remove "+crumbId+"_crumb");
		$("#"+crumbId+"_crumb").remove();
		var delIndex = null;
		$.each(breadcrumbs, function(key, value) { 
		  if(value.indexOf(crumbId) != -1){
			//console.log(crumbId+" has been found and will be removed.");
			delIndex = key;
		  }else{
			//console.log(crumbId+" not found in crumbs, crumb not removed.");
		  }
		});
		if(delIndex != null){
			//console.log("splice index "+delIndex);
			breadcrumbs.splice(delIndex,1);
		}
		//console.log("breadcrumbs now "+breadcrumbs);
		//clean value
		value = value.replace(/__/g," ");
		value = value.replace(/_dot_/g,".");
		//console.log("split the value _x_");
		var valueArray = value.split("_x_");
		var finalValue = valueArray[0];
		name=name.replace(/\//g,"\\/");
		//console.log("remove "+finalValue+" from "+name);
		$("input[name='"+name+"']").each(function() {
			if(finalValue == "All"){
				var attName = $(this).attr("name");
				//console.log(attName + " split");
				var substr = attName.split('category_')[1];
				var tmpCrumb = substr;
				substr=substr.replace(/\//g,"\\/");
				var crumbName = tmpCrumb;
				//console.log("remove the checkboxes in "+"#"+substr+"_div");
				//console.log("will now look for crumbs with "+crumbName);
				$("#"+substr+"_div").find('input:checkbox').attr('checked', false);
				$(this).attr('checked', false);
				var tbdCrumbs = [];
				var delIndices = [];
				for(var b=0;b<breadcrumbs.length;b++){
					var desired = "_"+crumbName+"--";
					//console.log("check if "+desired +" found in "+breadcrumbs[b]);
					if(breadcrumbs[b].indexOf(desired)!=-1){
						//console.log("add "+breadcrumbs[b]+ " to remove stack");
						delIndices.push(b);
						tbdCrumbs.push(breadcrumbs[b]);
					}
				}
				//console.log("tbd crumbs will be removed with similar names"+tbdCrumbs+ " and indices "+delIndices);
				for(var r=0;r<tbdCrumbs.length;r++){
					var tbdname = tbdCrumbs[r];
					tbdname = tbdname.replace(/\//g,"\\/");
					$("#"+tbdname+"_crumb").remove();
				}
				if(delIndices.length > 0){
					for(var i=0;i<delIndices.length;i++){
						breadcrumbs.splice(delIndices[i],1);
						//console.log("removed index "+i);
					}
				}
			}
			else{
				if($(this).is(":checkbox") && $(this).val() == finalValue){
				//console.log("got in here for spliy");
				$(this).attr('checked', false);
				var substr = "";
				if($(this).attr('id').indexOf("vocab_") !=-1){
					substr = $(this).attr('id').split('vocab_')[1];
				}
				if($(this).attr('id').indexOf("range_") !=-1){
					substr = $(this).attr('id').split('range_')[1];
				}
				var remaining = [];
				substr=substr.replace(/\//g,"\\/");
				$("#"+substr+"_div").find('input:checkbox').each(function(){
					if($(this).is(':checked') && $(this).attr('class')=="cb"){
						//console.log($(this).attr("name") + " and "+ $(this).attr("value") + " is checked");
						remaining.push(1);
					}
				});
				//console.log("see if any remaining for "+substr+"_category"+remaining);
				if(remaining.length < 1){
					$("input[id="+substr+"_category]").attr('checked', false);
				}
				remaining = [];
			 }
			}
		});
		//console.log("breadcrumbs cleaned, should now be "+breadcrumbs);
		var pageurl = "${grailsApplication.config.grails.serverURL}/clinical/filter?" + $("#sf :input[value]").serialize();
		if(refreshData){
			$('#sfSubmit').click();
		}
		//$("#sf :input").attr("disabled", true);
	}
	
}

function evaluateUnchecked(element){
	var simName = $(element).attr("name");
	var value = $(element).val();
	//console.log("evaluate the unchecked of "+simName+" with value of "+value);
	var substr = "";
	if($(element).attr('id').indexOf("vocab_") !=-1){
		substr = $(element).attr('id').split('vocab_')[1];
	}
	if($(element).attr('id').indexOf("range_") !=-1){
		substr = $(element).attr('id').split('range_')[1];
	}
	var arr = [];
	simName=simName.replace(/\//g,"\\/");
	substr=substr.replace(/\//g,"\\/");
	$("input[name="+simName+"]").each(function() { 
		//console.log($(this).attr('type'));
		 if($(this).attr('type')=='checkbox' && $(this).is(':checked')){
			//console.log('checked');
			arr.push("1");
		}
	 });
	//console.log(arr.length);
	if(arr.length < 1){
		var parentElement = $("input[id="+substr+"_category]");
		parentElement.attr('checked', false);
		removeBreadcrumb(parentElement.attr('name'),"All",true);
	}else{
		$("input[id="+substr+"_category]").attr('checked', true);
		addToBreadcrumb($(element).attr("name"),value,true);
		$('#sfSubmit').click();
		//$("#sf :input").attr("disabled", true);
	}
}

function cleanUp(){
	//console.log('clean up');
	$(" :input").attr("disabled", false);
	displayFilterTable();
	var targetElem = $("input[name="+targetField+"]");
	targetElem.attr("checked","checked");
	targetElem.attr("disabled", true);
	//console.log("split category in clean up");
	var substr = targetElem.attr('id').split('_category')[0];
	$("input[name*="+substr+"]").each(function() { 
		//console.log($(this).attr('name'));
		 $(this).attr('checked', false);
	 });
	//console.log("target field ="+targetField);
	//console.log("split attribute currently set to "+$("input[name=splitAttribute]").val());
	$("input[name=splitAttribute]").val(substr);
	//console.log("split attribute is set to "+substr+", and actual value is ="+$("input[name=splitAttribute]").val());
}

function verifyURLParams(pageUrl){
	console.log("verify url params");
	var hashes = pageUrl.slice(pageUrl.indexOf('?') + 1).split('&');
	for(var i=0;i<hashes.length;i++){
		var elementArray = hashes[i].split("=");
		var name = elementArray[0];
		var value = elementArray[1];
		name=name.replace(/%2F/g,"/");
		name=name.replace(/\//g,"\\/");
		value=value.replace(/%2F/g,"/");
		value=value.replace(/\//g,"\\/");
		//console.log("setting "+name+" to "+value);
		$("input[name="+name+"]").each(function() { 
			if(name.indexOf("range_")!=-1){
				value = value.replace(/\+/g," ");
			}
			if($(this).val()==value){
				$(this).attr("checked","checked");
			}
		 });
	}
}


</g:javascript>

<g:if test="${session.study}">
<div style="font-size:1.1em;color:#444444;padding-bottom:7px">Filter&nbsp;&nbsp;&nbsp;
	<span style="align:right"><g:link controller="clinical" action="advanced" style="color:#999999;font-size:.7em">[advanced search]</g:link></span>
</div>

<g:formRemote id="sf" name="searchForm" url="[controller: 'clinical', action:'filter']" before="check(this)" update="filterResults" onComplete="cleanUp()">
	<g:if test="${session.subjectTypes.timepoints}">
	<div class="clinicalFilter" id="timepoint_div">
		<div>
		<g:checkBox name="tp_category_timepoint" value="timepoint" checked="${params['timepoint']}" id="timepoint_category" class="category"/>
		<label for="category_timepoint" value="timepoint">Timepoint</label>
		<img class="info" title="timepoint info" src="${createLinkTo(dir:'images',file:'help.png')}" width="13" height="13" border="0" />
		<a href="#" class="clueLink" rel="timepoint_details" ><img src="${createLinkTo(dir:'images',file:'application_form_magnify.png')}" alt="view timepoint values" width="15" height="15" border="0" /></a>
		</div>
		<div class="timepoint_details" style="border:0px solid blue;display:none;padding:4px;color:#999999;font-size:.9em">
			<div align="left">
					<g:each in="${session.subjectTypes.timepoints}" var="t" status="i">
						    <span style="display:block">
							<g:checkBox name="timepoint" value="${t}" checked="${params['timepoint'] == t || params['timepoint']?.contains(t)}" class="cb" />
						    <label for="timepoint">${t}</label>
							</span>
					</g:each>
			</div>
		</div>
	</div>
	</g:if>
	<g:each in="${session.groups}" var="types">
		<span class="group" >${types.key}</span><br/>
		<g:set var="divId" value="${types.key.replaceAll(' ','_').replaceAll('\\(','_').replaceAll('\\)','_')}"/>
		<g:each in="${types.value}" status="i" var="it">
			<g:set var="use" value="false"/>
			
			<g:if test="${it.target == session.subjectTypes.parent.value()}">
				<g:set var="type" value="parent"/>
			</g:if>
			<g:else>
				<g:set var="type" value="child" />
			</g:else>
			<g:if test="${i == 3}">
				<span class="more" rel="${divId+'_div'}">view all (${types.value.size()-3} more ...)<br /></span>
				<span class="${divId+'_div'}" style="display:none" >
			</g:if>
			<g:if test="${(session.splitAttribute && session.splitAttribute!=it.shortName)}">
					<g:set var="use" value="true"/>
			</g:if>
			<g:else>
					<g:set var="use" value="false"/>
					<g:javascript>
						targetField = "${type.replace('_','') + '_category_' + it.shortName}";
					</g:javascript>
			</g:else>
			<div class="clinicalFilter" style="display:block" id="${it.shortName+'_div'}" disabled="true">
				<div>
				<g:checkBox name="${type.replace('_','') + '_category_' + it.shortName}" value="${it.shortName}" checked="${params[type + '_vocab_' + it.shortName] || params[type + '_range_' + it.shortName]}" id="${it.shortName}_category" class="category"/>
				<label for="${type.replace('_','') + '_category_' + it.shortName}">${it.longName}</label>
				<%--img class="info" title="${it.definition}" src="${createLinkTo(dir:'images',file:'help.png')}" width="13" height="13" border="0" /--%>
				<a href="#" class="clueLink" rel="${it.shortName.replace('/','_')+'_details'}" ><img src="${createLinkTo(dir:'images',file:'help.png')}" alt="view ${it.shortName} values" width="15" height="15" border="0" /></a>
				</div>
				<div class="${it.shortName.replace('/','_')+'_details'}" style="border:0px solid blue;display:none;padding:4px;color:#999999;font-size:.9em">
				<g:if test="${it.vocabulary}">
					<div align="left">
						<g:if test="${it.definition}">
					    <span style="font-size:.9em;padding:5px;font-style:italic">${it.definition}</span>
						</g:if>
						<g:each in="${it.vocabs.findAll{item -> session.usedVocabs[it.id]?.contains(item.term)}.sort{it.term}}" var="v" status="j">
							    <span style="display:block">
								<g:checkBox name="${type.replace('_','') + '_vocab_' + it.shortName}" value="${v.term}" checked="${params.list(type + '_vocab_' + it.shortName)?.contains(v.term)}" class="cb" />
							    <label for="${type.replace('_','') + '_vocab_' + it.shortName}">${v.termMeaning}</label>
								</span>
							</g:each>
									
					</div>
					
				</g:if>
				
				
				<g:else>
					<g:set var="upperRange" value='${session.attributeRanges[it.shortName]["upperRange"]}' />
					<g:set var="lowerRange" value='${session.attributeRanges[it.shortName]["lowerRange"]}' />
					<g:set var="median" value='${new Double((lowerRange+upperRange)/2).round(2)}' />
					<g:if test="${median.toString().contains('.')}">
						<g:set var="upperMed" value='${(median.toDouble()) + 0.1}' />
					</g:if>
					<g:else>
						<g:set var="upperMed" value='${(median.toDouble()) + 1}' />
					</g:else>
					<g:set var="upper" value='${0})' />
						<span style="display:block">
							<g:if test="${it.definition}">
						    <span style="font-size:.9em;padding:5px;font-style:italic">${it.definition}</span><br />
							</g:if>
						<span>Low Range</span>
						<g:checkBox name="${type.replace('_','') + '_range_' + it.shortName}" class="cb" value="${lowerRange + ' - ' +median}" checked="${params.list(type + '_range_' + it.shortName)?.contains(lowerRange.intValue() + ' - ' +median)}"/>
						<label for="${type.replace('_','') + '_' + it.shortName}">${lowerRange + ' to ' +median}</label>
						<br />
						<span>High Range</span>
						<g:checkBox name="${type.replace('_','') + '_range_' + it.shortName}" class="cb" value="${upperMed + ' - ' +upperRange}" checked="${params.list(type + '_range_' + it.shortName)?.contains((median +1) + ' - ' +upperRange.intValue()) || params.list(type + '_range_' + it.shortName)?.contains(upperMed + ' - ' +upperRange.intValue())}"/>
						<label for="${type.replace('_','') + '_' + it.shortName}">${upperMed + ' to ' +upperRange}</label>
						</span>
							
				</g:else>
				
				</div>
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


