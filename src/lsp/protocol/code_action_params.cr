module LSP
  class CodeActionParams
    include JSON::Serializable

    # The document in which the command was invoked.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentIdentifier

    # Context carrying additional information.
    property context : CodeActionContext

    # The range for which the command was invoked.
    property range : Range
  end
end
