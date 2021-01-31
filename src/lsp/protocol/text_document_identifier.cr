module LSP
  class TextDocumentIdentifier
    include JSON::Serializable

    # The text document's URI.
    property uri : String
  end
end
