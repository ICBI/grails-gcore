<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>G-DOC HeatMap Viewer</title>  
       <g:javascript library="jquery" />
			<jq:plugin name="curvycorners"/>
			<g:javascript>
				$(document).ready(function(){$('#hm').corner();	});
			</g:javascript>
    </head>
    <body>
	
		<p style="font-size:14pt">Heatmap Viewer</p>
		<div style="padding:10px;border:1px solid black;margin:5px;background-color:#FFF9EB;width:350px" id="hm">
			To open the heatmap viewer, please click the button below. The viewer will open in a new window,
			but all data interaction will still occur within your current session. <br /><br />
			<APPLET CODE="edu/stanford/genetics/treeview/applet/ButtonApplet.class"
			  archive="/gdoc/applets/treeview/TreeViewApplet.jar,/gdoc/applets/treeview/nanoxml-2.2.2.jar,/gdoc/applets/treeview/Dendrogram.jar" width=150 height=40
			    alt="Your browser understands the &lt;APPLET&gt; tag but isn't running the applet, for some reason.">
			    Your browser is completely ignoring the &lt;APPLET&gt; tag!
			    <param name="cdtFile" value="${grailsApplication.config.grails.serverURL}/gdoc/heatMap/file?name=cluster.cdt">
			    <param name="cdtName" value="${grailsApplication.config.grails.serverURL}/gdoc/heatMap/file?name=cluster">
				<param name="plugins" value="edu.stanford.genetics.treeview.plugin.dendroview.DendrogramFactory">
			  </applet>
		</div>
	  
	</body>
	
</hmtl>