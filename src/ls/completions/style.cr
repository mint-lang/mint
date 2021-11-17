module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Style) : Array(LSP::CompletionItem)
        TypeChecker::CSS_PROPERTY_NAMES.map do |name|
          LSP::CompletionItem.new(
            kind: LSP::CompletionItemKind::Snippet,
            insert_text: "#{name}: ${0};",
            detail: "CSS Property",
            filter_text: name,
            sort_text: name,
            label: name)
        end
      end
    end
  end
end
