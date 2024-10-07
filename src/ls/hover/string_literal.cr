module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(
        node : Ast::StringLiteral,
        workspace : FileWorkspace,
        type_checker : TypeChecker
      ) : Array(String)
        ["String"]
      end
    end
  end
end
