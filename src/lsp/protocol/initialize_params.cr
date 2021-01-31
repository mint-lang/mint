module LSP
  struct InitializeParams
    include JSON::Serializable

    # The process Id of the parent process that started the server. Is null if
    # the process has not been started by another process. If the parent
    # process is not alive then the server should exit (see exit notification)
    # its process.
    @[JSON::Field(key: "processId")]
    property process_id : Int32?

    # The rootUri of the workspace. Is null if no
    # folder is open. If both `rootPath` and `rootUri` are set
    # `rootUri` wins.
    #
    # @deprecated in favour of `workspaceFolders`
    @[JSON::Field(key: "rootUri")]
    property root_uri : String?

    # The capabilities provided by the client (editor or tool)
    property capabilities : ClientCapabilities

    # The initial trace setting. If omitted trace is disabled ('off').
    property trace : String?

    # The workspace folders configured in the client when the server starts.
    # This property is only available if the client supports workspace folders.
    # It can be `null` if the client supports workspace folders but none are
    # configured.
    #
    # @since 3.6.0
    @[JSON::Field(key: "workspaceFolders")]
    property workspace_folders : Array(WorkspaceFolder)?
  end
end
