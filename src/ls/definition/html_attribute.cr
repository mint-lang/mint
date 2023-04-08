module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_attribute(server : LS::Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless variable = stack.find { |x| x.is_a?(Ast::Variable) }.as(Ast::Variable | Nil)
        return unless html_attribute = stack.find { |x| x.is_a?(Ast::HtmlAttribute) }.as(Ast::HtmlAttribute | Nil)
        return unless html_component = stack.find { |x| x.is_a?(Ast::HtmlComponent) }.as(Ast::HtmlComponent | Nil)

        return unless component = workspace.ast.components.find { |x| x.name == html_component.component.value }
        return unless component_property = component.properties.find { |x| x.name.value == variable.value }

        location_link variable, component_property
      end
    end
  end
end
