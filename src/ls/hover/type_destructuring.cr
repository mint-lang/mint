module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::TypeDestructuring,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        item =
          type_checker.lookups[node].try(&.first?)

        hover(item, workspace, type_checker)
      end
    end
  end
end
