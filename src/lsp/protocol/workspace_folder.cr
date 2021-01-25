module LSP
  struct WorkspaceFolder
    include JSON::Serializable

    # The associated URI for this workspace folder.
    property uri : String

    # The name of the workspace folder. Used to refer to this
    # workspace folder in the user interface.
    property name : String
  end
end
