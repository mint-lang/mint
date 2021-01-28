module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::ModuleAccess, workspace) : Array(String)
        item =
          workspace.type_checker.lookups[node.variable]?

        hover(item, workspace)
      end
    end
  end
end
