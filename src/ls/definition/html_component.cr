module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_component(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        with_stack(stack) do |reader|
          return unless variable =
                          reader.find_next Ast::Variable

          return unless html_component =
                          reader.find_next Ast::HtmlComponent

          return unless component =
                          workspace.ast.components.find { |x| x.name == html_component.component.value }

          location_link variable, component
        end
      end
    end
  end
end
