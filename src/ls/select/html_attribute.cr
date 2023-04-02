module Mint
  module LS
    class Definition < LSP::RequestMessage
      def selection(node : Ast::HtmlAttribute) : LSP::Range
        selection(node.name)
      end
    end
  end
end
