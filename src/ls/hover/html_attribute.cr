module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::HtmlAttribute,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        type =
          type_of(node, type_checker)

        [
          "**#{node.name.value}**",
          type,
        ].compact
      end
    end
  end
end
