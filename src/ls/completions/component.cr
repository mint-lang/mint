module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Component, global : Bool = false) : Array(LSP::CompletionItem)
        name =
          node.name if global

        non_global =
          if global
            [] of LSP::CompletionItem
          else
            node.properties.map { |item| completion_item(item) } +
              node.styles.map { |item| completion_item(item) }
          end

        node.functions.map { |item| completion_item(item, name) } +
          node.constants.map { |item| completion_item(item, name) } +
          node.gets.map { |item| completion_item(item, name) } +
          non_global
      end
    end
  end
end
