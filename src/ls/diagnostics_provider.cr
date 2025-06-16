module Mint
  module LS
    class DiagnosticsProvider
      @current : String?

      def initialize(@server : LSP::Server)
        @current = nil
      end

      def process(item : TypeChecker | Error)
        @current.try do |path|
          @server.send_notification("textDocument/publishDiagnostics", {
            uri:         "file://#{path}",
            diagnostics: [] of String,
          })
        end

        case item
        when Error
          if location = item.location
            @current = location.path

            @server.send_notification("textDocument/publishDiagnostics", {
              uri:         "file://#{location.path}",
              diagnostics: [
                {
                  message:  item.to_terminal.to_s,
                  code:     item.name.to_s.upcase,
                  severity: 1,
                  range:    {
                    start: {
                      character: location.location[0].column,
                      line:      location.location[0].line - 1,
                    },
                    end: {
                      character: location.location[1].column,
                      line:      location.location[1].line - 1,
                    },
                  },
                },
              ],
            })
          end
        end
      end
    end
  end
end
