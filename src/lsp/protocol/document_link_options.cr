module LSP
  struct DocumentLinkOptions
    include JSON::Serializable

    # Document links have a resolve provider as well.
    @[JSON::Field(key: "resolveProvider")]
    property resolve_provider : Bool

    def initialize(@resolve_provider)
    end
  end
end
