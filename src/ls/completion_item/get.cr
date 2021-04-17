module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Get, parent_name : String? = nil) : LSP::CompletionItem
        name =
          if parent_name
            "#{parent_name}.#{node.name.value}"
          else
            node.name.value
          end

        LSP::CompletionItem.new(
          kind: LSP::CompletionItemKind::Variable,
          detail: "Computed Property",
          filter_text: name,
          insert_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
