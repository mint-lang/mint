module LSP
  struct DidOpenTextDocumentParams
    include JSON::Serializable

    # The document that was opened.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentItem
  end
end
