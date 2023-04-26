module LSP
  struct Location
    include JSON::Serializable

    property range : Range
    property uri : String

    def initialize(@range, @uri)
    end
  end
end
