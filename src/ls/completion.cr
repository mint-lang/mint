module Mint
  module LS
    class Completion
      HTML_TAG_COMPLETIONS =
        {{ read_file("#{__DIR__}/../assets/html_tags").strip }}
          .lines
          .map do |name|
            LSP::CompletionItem.new(
              kind: LSP::CompletionItemKind::Snippet,
              insert_text: "<#{name}>${0}</#{name}>",
              detail: "HTML Tag",
              filter_text: name,
              sort_text: name,
              label: name)
          end

      def initialize(
        *,
        @type_checker : TypeChecker,
        @workspace : FileWorkspace,
        @snippet_support : Bool
      )
      end

      def process(params : LSP::CompletionParams)
        ast =
          @type_checker.artifacts.ast

        global_completions =
          (
            ast.stores +
              ast.unified_modules +
              ast.components.select(&.global?)
          ).flat_map { |node| completions(node, global: true) }

        scope_completions =
          ast.nodes_at_cursor(
            column: params.position.character,
            path: params.text_document.path,
            line: params.position.line + 1
          ).flat_map { |node| completions(node) }

        component_completions =
          ast.components.map { |node| completion_item(node) }

        type_completions =
          ast.type_definitions.flat_map { |node| completions(node) }

        (global_completions +
          component_completions +
          scope_completions +
          type_completions +
          HTML_TAG_COMPLETIONS)
          .compact
          .sort_by!(&.label)
          .map! do |item|
            item.insert_text =
              item.insert_text
                .gsub(/\$\d/, "")
                .gsub(/\$\{.*\}/, "") unless @snippet_support
            item
          end
      end

      def completions(node : Ast::Node, global : Bool = false)
        [] of LSP::CompletionItem
      end
    end
  end
end
