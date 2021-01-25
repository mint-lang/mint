module LSP
  struct Workspace
    include JSON::Serializable

    # The server supports workspace folder.
    @[JSON::Field(key: "workspaceFolders")]
    property workspace_folders : WorkspaceFolders

    def initialize(@workspace_folders)
    end
  end
end
