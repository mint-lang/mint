module Mint
  module LS
    class Definition < LSP::RequestMessage
      def html_component(server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless variable =
                        next_variable stack

        return unless html_component =
                        next_html_component stack

        return unless component =
                        workspace.ast.components.find { |x| x.name == html_component.component.value }

        location_link variable, component
      end
    end
  end
end
