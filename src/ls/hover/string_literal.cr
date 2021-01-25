module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::StringLiteral, workspace) : Array(String?)
        ["String"] of String?
      end
    end
  end
end
