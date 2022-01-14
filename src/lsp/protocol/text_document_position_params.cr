module LSP
  class TextDocumentPositionParams
    include JSON::Serializable

    # The text document.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentIdentifier

    # The position inside the text document.
    property position : Position

    # Non part of the specification.
    @[JSON::Field(ignore: true)]

    # Returns the path of the URI
    def path
      text_document.path
    end
  end
end
