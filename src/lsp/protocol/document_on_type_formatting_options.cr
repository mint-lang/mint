module LSP
  struct DocumentOnTypeFormattingOptions
    include JSON::Serializable

    # A character on which formatting should be triggered, like `}`.
    @[JSON::Field(key: "firstTriggerCharacter")]
    property first_trigger_character : String

    # More trigger characters.
    @[JSON::Field(key: "moreTriggerCharacter")]
    property more_trigger_character : Array(String)?

    def initialize(@first_trigger_character, @more_trigger_character)
    end
  end
end
