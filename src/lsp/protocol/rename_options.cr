module LSP
  struct RenameOptions
    include JSON::Serializable

    # Renames should be checked and tested before being executed.
    @[JSON::Field(key: "prepareProvider")]
    property prepare_provider : Bool

    def initialize(@prepare_provider)
    end
  end
end
