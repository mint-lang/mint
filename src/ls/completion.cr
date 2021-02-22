module Mint
  module LS
    class Completion < LSP::RequestMessage
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

        (global_completions + component_completions + scope_completions)
          .compact
          .sort_by!(&.label)
      end
    end
  end
end
