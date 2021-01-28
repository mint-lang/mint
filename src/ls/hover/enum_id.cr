module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::EnumId, workspace) : Array(String)
        item =
          workspace.ast.enums.find(&.name.==(node.name))

        hover(item, workspace)
      end
    end
  end
end
