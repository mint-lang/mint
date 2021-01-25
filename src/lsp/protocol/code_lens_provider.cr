module LSP
  #  Code Lens options.
  struct CodeLensOptions
    include JSON::Serializable

    # Code lens has a resolve provider as well.
    @[JSON::Field(key: "resolveProvider")]
    property resolve_provider : Bool

    def initialize(@resolve_provider)
    end
  end
end
