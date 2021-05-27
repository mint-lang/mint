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
    @uri : URI?

    # Parses the URI
    def uri
      @uri ||= URI.parse(text_document.uri)
    end

    # Returns the path of the URI
    def path
      uri.try(&.path).to_s
    end
  end
end
