module Mint
  module LS
    class Server < LSP::Server
      @methods = {
        # Lifecycle methods.
        "initialize" => Initialize,
        "shutdown"   => Shutdown,
        "exit"       => Exit,

        # Text document related methods.
        "textDocument/completion"          => CompletionRequest,
        "textDocument/willSaveWaitUntil"   => WillSaveWaitUntil,
        "textDocument/semanticTokens/full" => SemanticTokens,
        "textDocument/foldingRange"        => FoldingRange,
        "textDocument/formatting"          => Formatting,
        "textDocument/codeAction"          => CodeAction,
        "textDocument/definition"          => Definition,
        "textDocument/didChange"           => DidChange,
        "textDocument/didOpen"             => DidOpen,
        "textDocument/hover"               => Hover,

        # Sandbox related methods (non-standard).
        "sandbox/update" => SandboxUpdate,
        "sandbox/reset"  => SandboxReset,
      }

      property params : LSP::InitializeParams? = nil
      property sandbox : Sandbox?

      @@workspaces = {} of String => Workspace

      def initialize(@in : IO, @out : IO)
        @diagnostics_provider = DiagnosticsProvider.new(self)
      end

      def workspace(path : String) : Workspace
        base =
          File.find_in_ancestors(path, "mint.json").to_s

        @@workspaces[base] ||=
          Workspace.new(
            check: Check::Unreachable,
            include_tests: true,
            dot_env: ".env",
            format: false,
            path: base,
            listener: ->(item : TypeChecker | Error) {
              @diagnostics_provider.try(&.process(item))
            })
      end
    end
  end
end
