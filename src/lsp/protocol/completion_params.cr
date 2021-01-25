require "./text_document_position_params"

module LSP
  class CompletionParams < TextDocumentPositionParams
    include JSON::Serializable

    # The completion context. This is only available if the client specifies
    # to send this using `ClientCapabilities.textDocument.completion.contextSupport === true`
    property context : CompletionContext?
  end
end
