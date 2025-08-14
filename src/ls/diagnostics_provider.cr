module Mint
  module LS
    class DiagnosticsProvider
      @current : Array(String)

      def initialize(@server : LSP::Server)
        @current = [] of String
      end

      def process(item : TypeChecker | Error)
        @current.each do |path|
          @server.send_notification("textDocument/publishDiagnostics", {
            uri:         "file://#{path}",
            diagnostics: [] of String,
          })
        end

        case item
        when Error
          diagnostics =
            item
              .locations
              .each_with_object({} of String => Array(LSP::Diagnostic)) do |location, memo|
                memo[location.path] ||= [] of LSP::Diagnostic
                memo[location.path] <<
                  LSP::Diagnostic.new(
                    severity: LSP::DiagnosticSeverity::Error,
                    message: item.to_terminal.to_s,
                    code: item.name.to_s.upcase,
                    range: LSP::Range.new(
                      start: LSP::Position.new(
                        character: location.location[0].column,
                        line: location.location[0].line - 1),
                      end: LSP::Position.new(
                        character: location.location[1].column,
                        line: location.location[1].line - 1)))
              end

          diagnostics.each do |path, items|
            @server.send_notification("textDocument/publishDiagnostics", {
              uri:         "file://#{path}",
              diagnostics: items,
            })
          end

          @current = diagnostics.keys
        end
      end
    end
  end
end
