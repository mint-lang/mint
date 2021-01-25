module LSP
  struct WillSaveTextDocumentParams
    include JSON::Serializable

    # The document to format.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentIdentifier

    def initialize(@text_document)
    end
  end
end
