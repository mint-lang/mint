module LSP
  # Completion options.
  struct CompletionOptions
    include JSON::Serializable

    # The server provides support to resolve additional
    # information for a completion item.
    @[JSON::Field(key: "resolveProvider")]
    property resolve_provider : Bool

    # The characters that trigger completion automatically.
    @[JSON::Field(key: "triggerCharacters")]
    property trigger_characters : Array(String)

    def initialize(@resolve_provider, @trigger_characters)
    end
  end
end
