module LSP
  struct Location
    include JSON::Serializable

    property range : Range
    property uri : String
  end
end
