module LSP
  struct CodeDescription
    include JSON::Serializable

    # An URI to open with more information about the diagnostic error.
    property uri : String
  end
end
