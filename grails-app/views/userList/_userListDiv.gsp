<g:javascript library="jquery" plugin="jquery"/>
<link rel="stylesheet" href="${createLinkTo(dir: 'css',  file: 'jquery.contextmenu.css')}"/>
<jq:plugin name="contextmenu"/>
<g:javascript src="geneLink.js"/>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'jquery.editableText.js')}"></script>
	<g:javascript>
	/**$(document).ready(function() {
		$("[class*='_name']").each(function(index){
			$(this).editableText({
			          // default value
			          newlinesEnabled: false

			});
		});

		$("[class*='_name']").change(function(){
		         var newValue = $(this).html();
				 var id = $(this).attr("id").split("_name")[0];
		         // do something
		         // For example, you could place an AJAX call here:
		        $.ajax({
		          type: "POST",
		          url: "/${appName()}/userList/renameList",
		          data: "newNameValue=" + newValue + "&id=" + id,
		          success: function(msg){
		            $('.message').html(msg);
					$('.message').css("display","block");
					if(msg=="saved"){
						$("#userListIds option[value='"+ id +  "']").text(newValue);
						$('.editableToolbar').children().css("width","0px");
					}else{
						makeEditable(id);
					}
					window.setTimeout(function() {
					  $('.message').remove();
					}, 1500);
		          }
		       });
		   });
	});**/
	</g:javascript>

    <div style="width:450px; padding:5px 5px 5px 10px;">
    <g:each in="${listItems}" status="j" var="list_item">
            <div style="float:left;width:25%;">
                <g:if test="${userListInstance.tags.contains(Constants.GENE_LIST)}">
                    <a href="#" class="geneLink">${list_item.value}</a>
                    &nbsp;&nbsp;&nbsp;
                    <g:if test="${metadata}">
                        <g:each in="${metadata}" var="k,v">
                            <g:if test="${v[list_item.id]}">
                                <span style="color:red;font-size:1.1em">*</span>
                                ${k}
                                <g:each in="${v[list_item.id]}" var="itemMetaData">
                                    ${itemMetaData.value}
                                </g:each>
                            </g:if>
                        </g:each>
                    </g:if>
                </g:if>
                <g:elseif test="${userListInstance.tags.contains(DataType.MICRORNA.tag())}">
                    <a href="#" class="micrornaLink">${list_item.value}</a>
                    &nbsp;&nbsp;&nbsp;
                    <g:if test="${metadata}">
                        <g:each in="${metadata}" var="k,v">
                            <g:if test="${v[list_item.id]}">
                                <span style="color:red;font-size:1.1em">*</span>
                                ${k}
                                <g:each in="${v[list_item.id]}" var="itemMetaData">
                                    ${itemMetaData.value}
                                </g:each>
                            </g:if>
                        </g:each>
                    </g:if>
                </g:elseif>
                <g:elseif test="${userListInstance.tags.contains(DataType.COPY_NUMBER.tag())}">
                    <a href="#" class="copynumberLink">${list_item.value}</a>
                    &nbsp;&nbsp;&nbsp;
                    <g:if test="${metadata}">
                        <g:each in="${metadata}" var="k,v">
                            <g:if test="${v[list_item.id]}">
                                <span style="color:red;font-size:1.1em">*</span>
                                ${k}
                                <g:each in="${v[list_item.id]}" var="itemMetaData">
                                    ${itemMetaData.value}
                                </g:each>
                            </g:if>
                        </g:each>
                    </g:if>
                </g:elseif>
                <g:else>
                    ${list_item.value}
                </g:else>
                <g:if test="${session.userId.equals(userListInstance.author.username)}">
                    <div style="margin-left: 5px; margin-right: 5px;float:left;"><a href="javascript:void(0)" 	onclick="if(confirm('${message(code: 'userList.confirm')}')){var classn ='${userListInstance.id}_toggle';${remoteFunction(action:'deleteListItem',id:list_item.id,update:userListInstance.id+'_content',onLoading:'showPageSpinner(true,classn)',onComplete:'showPageSpinner(false,classn)')}return false;}"><g:message code="userList.delete"/></a></div>
                </g:if>
            </div>

    </g:each>
    </div>

	<g:javascript>
	
				/**$("[class*='_name']").each(function(index){
					$(this).editableText({
					          // default value
					          newlinesEnabled: false

					});
				});

				$("[class*='_name']").change(function(){
				         var newValue = $(this).html();
						 var id = $(this).attr("id").split("_name")[0];
				         // do something
				         // For example, you could place an AJAX call here:
				        $.ajax({
				          type: "POST",
				          url: "/${appName()}/userList/renameList",
				          data: "newNameValue=" + newValue + "&id=" + id,
				          success: function(msg){
				            $('.message').html(msg);
							$('.message').css("display","block");
							if(msg=="saved"){
								$("#userListIds option[value='"+ id +  "']").text(newValue);
								$('.editableToolbar').children().css("width","0px");
							}else{
								makeEditable(id);
							}
							window.setTimeout(function() {
							  $('.message').remove();
							}, 1500);
				          }
				       });
				   });**/
</g:javascript>