module LSP
  # Parameters for a `DocumentSymbolRequest`.
  class DocumentSymbolParams
    include JSON::Serializable

    # The text document.
    @[JSON::Field(key: "textDocument")]
    getter text_document : TextDocumentIdentifier

    def initialize(@text_document : TextDocumentIdentifier?)
    end
  end
end
