module Mint
  module LS
    class Completion < LSP::RequestMessage
      CSS_PROPERTY_COMPLETIONS =
        TypeChecker::CSS_PROPERTY_NAMES.map do |name|
          LSP::CompletionItem.new(
            kind: LSP::CompletionItemKind::Snippet,
            insert_text: "#{name}: ${0};",
            detail: "CSS Property",
            filter_text: name,
            sort_text: name,
            label: name)
        end

      def completions(node : Ast::Style) : Array(LSP::CompletionItem)
        CSS_PROPERTY_COMPLETIONS
      end
    end
  end
end
