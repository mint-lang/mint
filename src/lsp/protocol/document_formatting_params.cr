module LSP
  struct DocumentFormattingParams
    include JSON::Serializable

    # The document to format.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentIdentifier

    # The format options.
    property options : FormattingOptions

    def initialize(@text_document, @options)
    end
  end
end
