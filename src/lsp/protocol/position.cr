module LSP
  struct Position
    include JSON::Serializable

    # Line position in a document (zero-based).
    property line : Int64

    # Character offset on a line in a document (zero-based). Assuming that
    # the line is represented as a string, the `character` value represents
    # the gap between the `character` and `character + 1`.
    #
    # If the character value is greater than the line length it defaults back
    # to the line length.
    property character : Int64

    def initialize(@line, @character)
    end
  end
end
