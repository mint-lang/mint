module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completion_item(node : Ast::Function, parent_name : String? = nil) : LSP::CompletionItem
        name =
          if parent_name
            "#{parent_name}.#{node.name.value}"
          else
            node.name.value
          end

        arguments =
          node
            .arguments
            .map_with_index do |argument, index|
              %(${#{index + 1}:#{argument.name.value}})
            end

        snippet =
          <<-MINT
          #{name}(#{arguments.join(", ")})
          MINT

        LSP::CompletionItem.new(
          documentation: node.comment.try(&.value).to_s,
          kind: LSP::CompletionItemKind::Function,
          insert_text: snippet,
          detail: "Function",
          filter_text: name,
          sort_text: name,
          label: name)
      end
    end
  end
end
