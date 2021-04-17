module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::HtmlAttribute, workspace) : Array(String)
        type =
          type_of(node, workspace)

        [
          "**#{node.name.value}**",
          type,
        ].compact
      end
    end
  end
end
