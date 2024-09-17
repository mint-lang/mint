module LSP
  struct TextDocumentEdit
    include JSON::Serializable

    # The text document to change.
    property textDocument : OptionalVersionedTextDocumentIdentifier

    # The edits to be applied.
    property edits : Array(TextEdit)
  end
end
