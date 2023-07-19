module LSP
  struct SemanticTokensLegend
    include JSON::Serializable

    # The token types a server uses.
    @[JSON::Field(key: "tokenTypes")]
    property token_types : Array(String)

    # The token modifiers a server uses.
    @[JSON::Field(key: "tokenModifiers")]
    property token_modifiers : Array(String)

    def initialize(@token_types, @token_modifiers)
    end
  end
end
