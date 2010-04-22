
<jq:plugin name="autocomplete"/>
<g:javascript>



  $(document).ready(function(){
   	$("#q").autocomplete("/gdoc/search/relevantTerms",{
			max: 130,
			scroll: true,
			multiple:false,
			matchContains: true,
			dataType:'json',
			parse: function(data){
				var array = jQuery.makeArray(data);
				for(var i=0;i<data.length;i++) {
 					var tempValue = data[i];
					var tempResult = data[i];
					array[i] = { data:data[i], value: tempValue, result: tempResult};
			    }
				return array;
			},
            formatItem: function(data, i, max) {
						return data;
					},
			
			formatResult: function(data) {
						return data;
					}
	});
	
	
  });


</g:javascript>


<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
<a href="/gdoc"><img src="${createLinkTo(dir:'images',file:'gdocLogo.png')}" border="0" /></a>
</td><td valign="bottom" style="text-align:right;padding:7px">


<g:if test="${!session.userId}">
<g:if test="${flash.cmd instanceof LoginCommand && flash.message}">
<div align="right" id="success" style="color:white">${flash.message}</div>
</g:if>
<g:form name="loginForm" url="[controller:'login',action:'login']" update="[success:'message',failure:'error']">
       <input name="loginName" type="text" size="10"></input>
       <input name="password" type="password" size="10"></input>
       <input type="submit" value="login" />
</g:form >
</g:if>
<g:else>

<div style="float:right;">
	<div>welcome,${session.userId}</div>
	<div><g:link action="logout" controller="login" update="success">logout</g:link></div>
</div>
</g:else>



</td>
</tr></table>