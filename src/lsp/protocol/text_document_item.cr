module LSP
  struct TextDocumentItem
    include JSON::Serializable

    # The text document's URI.
    property uri : String

    # The text document's language identifier.
    @[JSON::Field(key: "languageId")]
    property language_id : String

    # The version number of this document (it will increase after each
    # change, including undo/redo).
    property version : Int64

    # The content of the opened text document.
    property text : String

    def initialize(@uri, @version, @language_id, @text)
    end

    # Returns the path of the URI
    def path
      URI.parse(uri).try(&.file_path).to_s
    end
  end
end
