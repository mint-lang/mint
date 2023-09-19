module Mint
  module LS
    class Completion < LSP::RequestMessage
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

      property params : LSP::CompletionParams
      property snippet_support : Bool?

      def completions(node : Ast::Node, global : Bool = false)
        [] of LSP::CompletionItem
      end

      def workspace
        Mint::Workspace[params.path]
      end

      def execute(server)
        @snippet_support =
          server
            .params
            .try(&.capabilities.text_document)
            .try(&.completion)
            .try(&.completion_item)
            .try(&.snippet_support)

        global_completions =
          (workspace.ast.stores +
            workspace.ast.unified_modules +
            workspace.ast.components.select(&.global?))
            .flat_map { |node| completions(node, global: true) }

        scope_completions =
          server
            .nodes_at_cursor(params)
            .flat_map { |node| completions(node) }

        component_completions =
          workspace
            .ast
            .components
            .map { |node| completion_item(node) }

        type_completions =
          workspace
            .ast
            .type_definitions
            .flat_map { |node| completions(node) }

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
                .gsub(/\$\{.*\}/, "") unless snippet_support
            item
          end
      end
    end
  end
end
