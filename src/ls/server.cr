module Mint
  module LS
    class Server < LSP::Server
      # Lifecycle methods
      method "initialize", Initialize
      method "shutdown", Shutdown
      method "exit", Exit

      # Text document related methods
      method "textDocument/willSaveWaitUntil", WillSaveWaitUntil
      method "textDocument/semanticTokens/full", SemanticTokens
      method "textDocument/foldingRange", FoldingRange
      method "textDocument/formatting", Formatting
      method "textDocument/completion", Completion
      method "textDocument/codeAction", CodeAction
      method "textDocument/definition", Definition
      method "textDocument/didChange", DidChange
      method "textDocument/hover", Hover

      property params : LSP::InitializeParams? = nil

      # Logs the given stack.
      def debug_stack(stack : Array(Ast::Node))
        stack.each_with_index do |item, index|
          class_name = item.class

          if index.zero?
            log(class_name.to_s)
          else
            log("#{" " * (index - 1)} ↳ #{class_name}")
          end
        end
      end

      # Returns the nodes at the given cursor (position)
      def nodes_at_cursor(path : String, position : LSP::Position) : Array(Ast::Node)
        nodes_at_path(path)
          .select!(&.location.contains?(position.line + 1, position.character))
      end

      def nodes_at_cursor(params : LSP::TextDocumentPositionParams) : Array(Ast::Node)
        nodes_at_cursor(params.path, params.position)
      end

      def nodes_at_cursor(params : LSP::CodeActionParams) : Array(Ast::Node)
        nodes_at_cursor(params.text_document.path, params.range.start)
      end

      def nodes_at_path(path : String)
        Mint::Workspace[path]
          .ast
          .nodes
          .select(&.file.path.==(path))
      end
    end
  end
end
