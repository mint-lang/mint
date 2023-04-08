module Mint
    module LS
      class Definition < LSP::RequestMessage
        def html_component(server : LS::Server, workspace : Workspace, stack : Array(Ast::Node))
          return unless variable = stack.find { |x| x.is_a?(Ast::Variable) }.as(Ast::Variable | Nil)
          return unless html_component = stack.find { |x| x.is_a?(Ast::HtmlComponent) }.as(Ast::HtmlComponent | Nil)
  
          return unless component = workspace.ast.components.find { |x| x.name == html_component.component.value }

          location_link variable, component
        end
      end
    end
  end
  