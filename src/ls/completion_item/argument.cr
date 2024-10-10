module Mint
  module LS
    class Completion
      def completion_item(node : Ast::Argument) : LSP::CompletionItem
        name =
          node.name.value

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Variable,
          detail: "Argument",
          insert_text: name,
          filter_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
