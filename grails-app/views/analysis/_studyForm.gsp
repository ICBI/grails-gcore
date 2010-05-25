<g:if test="${session.study}">
<jq:plugin name="flydisk" />
<g:javascript>
$(document).ready(function() {

	jQuery().flydisk({ selectedColor:"#eee",                       //BgColor of selected items(Default: white) 
	left_disk:'left',                 //Id of left drop down list (Mandatory)
	right_disk:'right',               //Id of right drop down list(Mandatory)
	add_button: 'Add',                //Id of Add button            ,, 
	remove_button: 'Remove'

});  
$('#analysisForm').submit(function() {
	$('#right :option').attr("selected", "selected");
});
$('#right :option').each(function() {
	$("#left option[value='"+ this.value +  "']").remove();
});
$.sortOptions('#left');
});

</g:javascript>

<p>Select a baseline group and a comparison group(s)</p>
<g:if test="${flash.message}">
<div class="message" style="width:75%">
	${flash?.message}
</div>
</g:if>

<g:form name="analysisForm" action="submit">
<div class="clinicalSearch">
	<br />
	<div class="errorDetail">
		<g:renderErrors bean="${flash.cmd?.errors}" field="baselineGroup" />
	</div>
	Select baseline group:
	<g:select name="baselineGroup"
		noSelection="${['':'Select base-line group...']}"
		value="${flash.cmd?.baselineGroup}"
		from="${session.patientLists}" optionKey="name" optionValue="name"	/>
	<br/><br />
	Select Groups:
	<br/>
	<table width="400px;">
		<tr>
			<td>
				<g:multiselect id="left" from="${session.patientLists}" optionKey="name" optionValue="name" 
						multiple="true" size="10" style="width: 150px"/>
			</td>
			<td>
				<table>
					<tr>
						<td>
							<a href="#" id="Add"> Add   </a> 
						</td>
					</tr>
					<tr>
						<td>
							<a href="#" id="Remove"> Remove   </a> 
						</td>
					</tr>
				</table>
			</td>
			<td>
				<g:multiselect id="right" name="groups" multiple="true" size="10" style="width: 150px"
					from="${flash.cmd?.groups}" class="${hasErrors(bean:flash.cmd,field:'groups','errors')}"/> 
			</td>
		</tr>
		<tr>
			<td colspan="3">
				&nbsp;
			</td>
		</tr>		
		<tr>
			<td colspan="3">
				<div class="errorDetail">
					<g:renderErrors bean="${flash.cmd?.errors}" field="groups" />
				</div>
			</td>
		</tr>
	</table>
	<br/>
	p-value:
	<br/>
	<g:validationInput name="pvalue"/>
	<br/>
	Fold Change:
	<br/>
	<g:validationInput name="foldChange"/>
	<br/>
	Statistical Method:
	<br/>
	<g:select name="statisticalMethod" 
			from="${['T-Test: Two Sample Test']}"
			value="'T-Test: Two Sample Test'" />
	<br/>
	<br/>
	<%--Multiple Comparison Adjustment:
	<br/>
	<g:select name="adjustment" 
			noSelection="${['':'Select One...']}"
			from="${['Family-Wise Error Rate(FWER): Bonferroni', 'False Discovery Rate(FDR): Benjamini-Hochberg']}"/>
	<br/>
	<br/--%>
	Data-Type<br />
	<g:select name="dataSetType" 
			from="${session.dataSetType}"/>
	<br/><br />
	Dataset:
	<br/>
	<g:select name="dataFile" 
			from="${session.files}"
			optionKey="name" optionValue="${{it.description}}"/>
	<br/>
	<g:hiddenField name="study" value="${session.study.schemaName}" />
</div>
<br/>
<g:submitButton name="submit" value="Submit Analysis"/>
</g:form>
</g:if>

<g:else>
<p>No study currently selected.</p>
</g:else>
