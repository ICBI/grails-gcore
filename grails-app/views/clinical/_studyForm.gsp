

<script type="text/javascript">
	var count = 0;

	function bindBehaviour(){
		
		
		$("[class*='info']").each(function(index){
			$(this).tooltip({showURL: false});
		});
		$("[class*='close']").each(function(index){
			$(this).click(function() {
				$(this).parents('.clinicalSearch').hide('slow');
			});
		});
		$("[class*='slider-range']").each(function(index){
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
	}
</script>

<g:if test="${session.study}">

<g:form name="searchForm" action="search">
	<g:if test="${session.subjectTypes.timepoints}">
	<div class="clinicalSearch">
		<div style="float: left">
			Timepoint
			<img class="info" title="Timepoint" src="${createLinkTo(dir:'images',file:'information.png')}" border="0" />
		</div>
	<div style="float: right; vertical-align: middle">
		<img class="close"src="${createLinkTo(dir:'images',file:'cross.png')}" border="0" />
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
						from="${session.subjectTypes.timepoints}" >
				</g:select>
			</g:else>
		</div>
		<br/>
	</div>
	</g:if>
	<g:each in="${session.dataTypes}">
		<g:if test="${it.target == session.subjectTypes.parent.value()}">
			<g:set var="type" value="parent"/>
		</g:if>
		<g:else>
			<g:set var="type" value="child" />
		</g:else>
		<div class="clinicalSearch">
			<div style="float: left">
				${it.longName} 	
				<img class="info" title="${it.definition}" src="${createLinkTo(dir:'images',file:'information.png')}" border="0" />
			</div>
		<div style="float: right; vertical-align: middle">
			<img class="close"src="${createLinkTo(dir:'images',file:'cross.png')}" border="0" />
		</div>
		<br/>
		<br/>
			<g:if test="${it.vocabulary}">
				<div align="left">
					<g:if test="${flash.params}">
						<g:select name="${type + '_' + it.shortName}" 
								noSelection="${['':'Select One...']}" value="${flash.params[type + '_' + it.shortName]}"
								from="${it.vocabs.findAll{item -> session.usedVocabs[it.id]?.contains(item.term)}.sort{it.term}}" optionKey="term" optionValue="termMeaning">
						</g:select>
					</g:if>
					<g:else>
						
						<g:select name="${type + '_' + it.shortName}" 
								noSelection="${['':'Select One...']}"
								from="${it.vocabs.findAll{item -> session.usedVocabs[it.id]?.contains(item.term)}.sort{it.term}}" optionKey="term" optionValue="termMeaning">
						</g:select>
					</g:else>
				</div>
				<br/>
			</g:if>
			<g:elseif test="${it.qualitative}">
				<g:if test="${flash.params}">
					<g:textField name="${type + '_' + it.shortName}"  value="${flash.params[type + '_' + it.shortName]}"/>
				</g:if>
				<g:else>
					<g:textField name="${type + '_' + it.shortName}"  />
				</g:else>
				<br/>
			</g:elseif>
			<g:elseif test="${it.lowerRange != null && it.upperRange != null}">
				<g:set var="upperRange" value='${session.attributeRanges[it.shortName]["upperRange"]}' />
				<g:set var="lowerRange" value='${session.attributeRanges[it.shortName]["lowerRange"]}' />
				<div align="center">
					<label for="rangeValue" style="padding-left: 130px">Range:</label>
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
							<td style="padding-right: 10px">${lowerRange}</td>
							<td>
								<div class="slider-range" style="width: 250px"></div>
							</td>
							<td style="padding-left: 10px">${upperRange}</td>
						</tr>
					</table>
				</div>
				<script type="text/javascript">
					count = count + 1;
					//console.log(count);
					var item = jQuery('.slider-range').get(count - 1); 
					//console.log(jQuery('.slider-range').size() - 1);
					jQuery(item).data("minval", "${lowerRange}");
					jQuery(item).data("maxval", "${upperRange}");
				</script>
				<br/>
			</g:elseif>
			<g:else>
				Between 
					<g:if test="${flash.errors}">
						<g:textField name="${type + '_' + it.shortName}" class="${flash.errors[type + '_' + it.shortName] ? 'errors' : ''}" value="${flash.params[type + '_' + it.shortName][0]}" /> 
					</g:if>
					<g:else>
						<g:textField name="${type + '_' + it.shortName}" /> 
					</g:else>
				and 
					<g:if test="${flash.errors}">
						<g:textField name="${type + '_' + it.shortName}" class="${flash.errors[type + '_' + it.shortName] ? 'errors' : ''}" value="${flash.params[type + '_' + it.shortName][1]}"/> 
					</g:if>
					<g:else>
						<g:textField name="${type + '_' + it.shortName}" /> 
					</g:else>
				</g:else>
		</div>
	</g:each>
	<br/>
	<br/>
	<g:submitButton  class="btn btn-primary" name="submit" value="${message(code: 'gcore.submit')}"/>
</g:form>
</g:if>

<g:else>
<p><g:message code="gcore.noStudy" /></p>
</g:else>

