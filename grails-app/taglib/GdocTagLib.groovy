import org.apache.commons.lang.StringUtils

class GdocTagLib {
	
	static returnObjectForTags = ['workflows']
	
	def extensionService
	
	def navigationLink = { attrs, body ->
		if (attrs.controller == params.controller && !attrs.id){
			out << "<h3>${attrs.name}</h3>"
		} else {
			if(attrs.id) {
				out << link([controller: attrs.controller, id: attrs.id]){attrs.name}
			} else {
				out << link([controller: attrs.controller]){attrs.name}
			}
		}
	}
	
	def panel = { attrs, body ->
		out << render(template: '/common/panel', bean: [body: body, attrs: attrs], plugin: 'gcore')
	}
	
	def validationInput = { attrs, body ->
		out << render(template: '/common/validation_input', bean: [body: body, attrs: attrs], plugin: 'gcore')
	}
	
	def flex = { attrs, body ->
		out << render(template: '/common/flex_content', bean: [body: body, attrs: attrs], plugin: 'gcore')
	}
	
	def managedCheckBox = { attrs ->
	          def value = attrs.remove('value')
	          def name = attrs.remove('name')
	          def disabled = attrs.remove('disabled')
	          if(!value) value = false
	          out << '<input type="hidden" '
	          out << "name=\"_${name}\" />"
	          out << '<input type="checkbox" '
	          out << "name=\"${name}\" "
	          if(value != 'false') {
	                out << "checked=\"$value\" "
	          }
	          if(disabled)
	          {
	          	out << 'disabled="disabled" '
	          }
	        // process remaining attributes
	        //outputAttributes(attrs)

	// close the tag, with no body 
			out << ' />' 
	}
	
	def analysisLinks = { attrs ->
		def links = extensionService.getAnalysisLinks()
		if(!links)
			out << "No analysis extensions installed"
		links.each { key, value ->
			out << link([controller: key]){value}
			if(!attrs.menu)
				out << '<br/><br/>'
		}
		
	}
	
	def searchLinks = { attrs ->
		def links = extensionService.getSearchLinks()
		if(!links)
			out << "No search extensions installed"
		links.each { key, value ->
			out << link([controller: key]){value}
			if(!attrs.menu)
				out << '<br/><br/>'
		}
		
	}
	
	def appName = {
		out << grailsApplication.metadata['app.name']
	}
	
	def analysisView = { attrs ->
		out << extensionService.getAnalysisView(attrs.type)
	}
	
	def jqgrid = {
		out << javascript(src: "jquery/jqGrid/grid.locale-en.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.base.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.common.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.formedit.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.inlinedit.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.celledit.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.subgrid.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.treegrid.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.custom.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.postext.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.tbltogrid.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.setcolumns.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/grid.import.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/jquery.fmatter.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/json2.js", plugin: "gcore")
		out << javascript(src: "jquery/jqGrid/JsonXml.js", plugin: "gcore")
		
	}
	
	def workflows = { attrs ->
		def items = extensionService.getWorkflowsForType(attrs.type)
		println items
		return items
	}
	
}
