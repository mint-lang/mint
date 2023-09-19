module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Constant, parent_name : Ast::Id? = nil) : LSP::CompletionItem
        name =
          if parent_name
            "#{parent_name.value}:#{node.name.value}"
          else
            node.name.value
          end

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Variable,
          detail: "Constant",
          filter_text: name,
          insert_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
