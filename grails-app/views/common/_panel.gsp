<div class="panel ${it.attrs.styleClass}">
   <g:if test="${it.attrs.panelColor}">
		<div class="${it.attrs.panelColor}">
   </g:if>
	<g:else>
	<div class="panelTitle">
	</g:else>
   
				<g:if test="${it.attrs.collapse}">
				     <div id="${it.attrs.id}_title" style="height: 20px; cursor: pointer;">
				</g:if>
				<g:else>
				    <div id="${it.attrs.id}_title" style="height: 20px;">
				</g:else>
				<div style="float: left">${it.attrs.title}</div>
				<div style="float: right; vertical-align: middle">
					<g:if test="${it.attrs.collapse}">
							<img class="${it.attrs.id}_toggle"src="${createLinkTo(dir: 'images', file: 'expand.gif')}" width="13"
					         height="14" border="0" alt="Show/Hide" title="Show/Hide" />
							<img class="${it.attrs.id}_toggle" src="${createLinkTo(dir: 'images', file: 'collapse.gif')}" width="13"
							         height="14" border="0" alt="${message(code: 'panel.showHide')}" title="${message(code: 'panel.showHide')}" style="display:none"/>
					</g:if>
				</div>
			</div>			
    </div>
    <div id="${it.attrs.id}_content" class="${it.attrs.contentClass}" style="background-color:#f5f5f5;border-collapse:separate">
         ${it.body()}
    </div>
</div>

<g:if test="${it.attrs.collapse}">
	<script type="text/javascript">
		$(document).ready(function() {
			$('#${it.attrs.id}_title').click(function() {
				$('#${it.attrs.id}_content').slideToggle();
				$('.${it.attrs.id}_toggle').toggle();
			});
	  });
	</script>
</g:if>