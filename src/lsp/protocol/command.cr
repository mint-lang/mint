module LSP
  struct Command
    include JSON::Serializable

    # Title of the command, like `save`.
    property title : String

    # The identifier of the actual command handler.
    property command : String

    # Arguments that the command handler should be
    # invoked with.
    property arguments : Array(String)?
  end
end
