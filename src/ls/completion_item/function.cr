module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Function, parent_name : Ast::Id? = nil) : LSP::CompletionItem
        name =
          if parent_name
            "#{parent_name.value}.#{node.name.value}"
          else
            node.name.value
          end

        arguments =
          node
            .arguments
            .map_with_index do |argument, index|
              %(${#{index + 1}:#{argument.name.value}})
            end

        LSP::CompletionItem.new(
          documentation: node.comment.try(&.content).to_s,
          insert_text: "#{name}(#{arguments.join(", ")})",
          kind: LSP::CompletionItemKind::Function,
          detail: "Function",
          filter_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
