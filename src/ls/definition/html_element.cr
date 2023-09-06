module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::HtmlElement, workspace : Workspace, stack : Array(Ast::Node))
        node.styles.each do |style|
          next unless cursor_intersects?(style)

          return definition(style, workspace, stack)
        end
      end
    end
  end
end
