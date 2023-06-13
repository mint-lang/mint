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

  struct SemanticTokensOptions
    include JSON::Serializable

    # The legend used by the server
    property legend : SemanticTokensLegend

    # Server supports providing semantic tokens for a specific range
    # of a document.
    property? range : Bool

    # Server supports providing semantic tokens for a full document.
    property? full : Bool

    def initialize(@legend, @range, @full)
    end
  end
end
