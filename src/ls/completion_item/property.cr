module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Property) : LSP::CompletionItem
        name =
          node.name.value

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Variable,
          detail: "Property",
          filter_text: name,
          insert_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
