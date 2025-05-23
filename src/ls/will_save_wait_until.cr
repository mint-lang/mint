module Mint
  module LS
    class WillSaveWaitUntil < LSP::RequestMessage
      property params : LSP::WillSaveTextDocumentParams

      def execute(server)
        workspace =
          server.workspace(params.text_document.path)

        case formatted = workspace.format(params.text_document.path)
        in String
          [
            LSP::TextEdit.new(new_text: formatted, range: LSP::Range.new(
              start: LSP::Position.new(line: 0, character: 0),
              end: LSP::Position.new(line: 9999, character: 999)
            )),
          ]
        in Error
          # If there is an error show that
          server.show_message_request("Could not format the file because it contains errors!", 1)

          # Respond with the formatted document or an empty response message
          # because SublimeText LSP client freezes if there is no response.
          %w[]
        in Nil
          %[]
        end
      end
    end
  end
end
