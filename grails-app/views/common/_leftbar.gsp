<g:javascript library="jquery"/>
<g:javascript>
jQuery(document).ready(function()
{
	jQuery("ul.sf-menu").superfish({ 
		animation: {height:'show'},   // slide-down effect without fade-in 
		delay:     1200               // 1.2 second delay on mouseout 
	});
	jQuery('.genePatternLink').click(function() {
		jQuery('#gpForm').submit();
		return false;
	})
});
</g:javascript>
<jq:plugin name="hoverIntent"/>
<jq:plugin name="superfish"/>
<div id="navigation-block">
	<ul id="gdocNavigation" class="sf-menu sf-vertical sf-js-enabled sf-shadow">
		<li>
			<g:navigationLink name="Home" controller="home"/>
		</li>
		<li>
			<a class="sf-with-ul" href="#">Search for Data<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<a class="sf-with-ul" href="#">Studies<span class="sf-sub-indicator"> »</span></a>
					<ul style="display: none; visibility: hidden;">
						<g:each in="${session.myStudies}">
							<li>
								<g:navigationLink name="${it.shortName}" id="${it.id}" controller="clinical" />
							</li>
						</g:each>
					</ul>
				</li>
				<li>
					<a href="#">Patients</a>
				</li>	
				<li>
					<a href="#">Samples</a>
				</li>
				<li>
					<a href="#">Targets</a>
				</li>					
				<li>
					<g:navigationLink name="Genes" controller="geneExpression" />
				</li>						
			</ul>
		</li>
		<li>
			<a class="sf-with-ul" href="#">Perform Analysis<span class="sf-sub-indicator"> »</span></a>
			<ul style="display: none; visibility: hidden;">
				<li>
					<a class="sf-with-ul" href="#">Class Comparison<span class="sf-sub-indicator"> »</span></a>
					<ul style="display: none; visibility: hidden;">
						<g:each in="${session.myStudies}">
							<g:if test="${it.genomicData}">
								<li>
									<g:navigationLink name="${it.shortName}" id="${it.id}" controller="analysis" />
								</li>
							</g:if>
						</g:each>
					</ul>
				</li>
				<li>
					<a class="sf-with-ul" href="#">KM Plot<span class="sf-sub-indicator"> »</span></a>
					<ul style="display: none; visibility: hidden;">
						<g:each in="${session.myStudies}">
							<li>
								<g:navigationLink name="${it.shortName}" id="${it.id}" controller="km" />
							</li>
						</g:each>
					</ul>
				</li>	
				<li>
					<a class="sf-with-ul" href="#">Gene Pattern<span class="sf-sub-indicator"> »</span></a>
					<ul style="display: none; visibility: hidden;">
						<g:each in="${session.myStudies}">
							<g:if test="${it.genomicData}">
								<li>
									<g:navigationLink name="${it.shortName}" id="${it.id}" controller="genePattern" />
								</li>
							</g:if>
						</g:each>
						<li>
							<a href="#" class="genePatternLink">GenePattern Home</a>
						</li>
					</ul>
				</li>							
			</ul>			
			
		</li>	
		<li>
			<a href="#">Help</a>
		</li>		
	</ul>
	<form id="gpForm" action="http://141.161.54.201:8080/gp/pages/index.jsf" method="POST" target="genepattern">
		<input type="hidden" name="workspaceId" value="${genePatternId()}" />
	</form>
</div>







