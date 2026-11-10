module LSP
  class TextDocumentIdentifier
    include JSON::Serializable

    # The text document's URI.
    property uri : String

    # Returns the path of the URI
    def path
      URI.parse(uri).try(&.file_path).to_s
    end
  end
end
