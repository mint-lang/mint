module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_style(server : LS::Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless variable = stack.find { |x| x.is_a?(Ast::Variable) }.as(Ast::Variable | Nil)
        return unless html_style = stack.find { |x| x.is_a?(Ast::HtmlStyle) }.as(Ast::HtmlStyle | Nil)
        return unless component = stack.find { |x| x.is_a?(Ast::Component) }.as(Ast::Component | Nil)

        return unless component_style = component.styles.find { |x| x.name.value == variable.value }

        location_link variable, component_style
      end
    end
  end
end
