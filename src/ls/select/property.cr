module Mint
  module LS
    class Definition < LSP::RequestMessage
      def selection(node : Ast::Property) : LSP::Range
        selection(node.name)
      end
    end
  end
end
