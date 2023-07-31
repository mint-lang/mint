module LSP
  struct SemanticTokensClientCapabilities
    include JSON::Serializable

    # Whether definition supports dynamic registration.
    @[JSON::Field(key: "dynamicRegistration")]
    property dynamic_registration : Bool?

    # The token types that the client supports.
    @[JSON::Field(key: "tokenTypes")]
    property token_types : Array(String)?

    def initialize(@dynamic_registration = nil, @token_types = nil)
    end
  end
end
