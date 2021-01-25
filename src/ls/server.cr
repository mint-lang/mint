module Mint
  module LS
    class Server < LSP::Server
      # Lifecycle methods
      method "initialize", Initialize
      method "shutdown", Shutdown
      method "exit", Exit

      # Text document related methods
      method "textDocument/willSaveWaitUntil", WillSaveWaitUntil
      method "textDocument/formatting", Formatting
      method "textDocument/completion", Completion
      method "textDocument/didChange", DidChange
      method "textDocument/hover", Hover

      # Logs the given stack.
      def debug_stack(stack : Array(Ast::Node))
        stack.each_with_index do |item, index|
          class_name = item.class

          if index == 0
            log(class_name.to_s)
          else
            log("#{" " * (index - 1)} ↳ #{class_name}")
          end
        end
      end

      # Returns the nodes at the given cursor (position)
      def nodes_at_cursor(params : LSP::TextDocumentPositionParams) : Array(Ast::Node)
        workspace =
          Mint::Workspace[params.path]

        workspace.ast.nodes.select do |item|
          next unless item.input.file == params.path
          item.from <= params.offset(item.input.input) <= item.to
        end
      end
    end
  end
end
