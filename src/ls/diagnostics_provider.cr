module Mint
  module LS
    class DiagnosticsProvider
      @current : Array(String)

      def initialize(@server : LSP::Server)
        @current = [] of String
      end

      def process(result : Workspace::Result)
        @current.each do |path|
          @server.send_notification("textDocument/publishDiagnostics", {
            uri:         "file://#{path}",
            diagnostics: [] of String,
          })
        end

        diagnostics = {} of String => Array(LSP::Diagnostic)

        case value = result.value
        when Error
          diagnostic(value, diagnostics)
        end

        result.warnings.each { |warning| diagnostic(warning, diagnostics) }

        diagnostics.each do |path, items|
          @server.send_notification("textDocument/publishDiagnostics", {
            uri:         "file://#{path}",
            diagnostics: items,
          })
        end

        @current = diagnostics.keys
      end

      def diagnostic(item : Error | Warning, diagnostics : Hash(String, Array(LSP::Diagnostic)))
        severity =
          case item
          in Warning
            LSP::DiagnosticSeverity::Warning
          in Error
            LSP::DiagnosticSeverity::Error
          end

        item.locations.each do |location|
          diagnostics[location.path] ||= [] of LSP::Diagnostic
          diagnostics[location.path] <<
            LSP::Diagnostic.new(
              message: item.to_terminal.to_s,
              code: item.name.to_s.upcase,
              severity: severity,
              range: LSP::Range.new(
                start: LSP::Position.new(
                  character: location.location[0].column,
                  line: location.location[0].line - 1),
                end: LSP::Position.new(
                  character: location.location[1].column,
                  line: location.location[1].line - 1)))
        end
      end
    end
  end
end
