module LSP
  struct SignatureHelpOptions
    include JSON::Serializable

    # The characters that trigger completion automatically.
    @[JSON::Field(key: "triggerCharacters")]
    property trigger_characters : Array(String)

    def initialize(@trigger_characters)
    end
  end
end
