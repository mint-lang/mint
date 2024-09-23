module LSP
  struct TextDocumentEdit
    include JSON::Serializable

    # The text document to change.
    @[JSON::Field(key: "textDocument")]
    property text_document : OptionalVersionedTextDocumentIdentifier

    # The edits to be applied.
    property edits : Array(TextEdit)
  end
end
