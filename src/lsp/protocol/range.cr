module LSP
  struct Range
    include JSON::Serializable

    # The range's start position.
    property start : Position

    # The range's end position.
    property end : Position

    def initialize(@start, @end)
    end
  end
end
