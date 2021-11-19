module Mint
  module LS
    class Completion < LSP::RequestMessage
      HTML_TAGS =
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

      def completions(node : Ast::Node, global : Bool = false)
        [] of LSP::CompletionItem
      end

      def workspace
        Mint::Workspace[params.path]
      end

      def execute(server)
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

        (global_completions +
          component_completions +
          scope_completions +
          HTML_TAGS)
          .compact
          .sort_by!(&.label)
      end
    end
  end
end
