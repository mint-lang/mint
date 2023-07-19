module LSP
  class SemanticTokensParams
    include JSON::Serializable

    # The document in which the command was invoked.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentIdentifier
  end
end
