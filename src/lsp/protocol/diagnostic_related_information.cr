module LSP
  struct DiagnosticRelatedInformation
    include JSON::Serializable

    # The location of this related diagnostic information.
    property location : Location

    # The message of this related diagnostic information.
    property message : String
  end
end
