module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Style) : LSP::CompletionItem
        name =
          node.name.value

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Variable,
          filter_text: name,
          insert_text: name,
          sort_text: name,
          detail: "Style",
          label: name)
      end
    end
  end
end
