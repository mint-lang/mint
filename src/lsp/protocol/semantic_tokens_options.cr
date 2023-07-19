module LSP
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
