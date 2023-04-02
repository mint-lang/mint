module Mint
  module LS
    class Definition < LSP::RequestMessage
      def selection(node : Ast::HtmlComponent) : LSP::Range
        # Select only the name part of the component
        # <Component attribute={value}>
        #  ^^^^^^^^^
        selection(node.component)
      end
    end
  end
end
