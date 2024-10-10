module Mint
  module LS
    class Completion
      def completions(node : Ast::Function) : Array(LSP::CompletionItem)
        node.arguments.map { |item| completion_item(item) }
      end
    end
  end
end
