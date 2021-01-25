module LSP
  struct SaveOptions
    include JSON::Serializable

    # The client is supposed to include the content on save.
    @[JSON::Field(key: "includeText")]
    property include_text : Bool

    def initialize(@include_text)
    end
  end
end
