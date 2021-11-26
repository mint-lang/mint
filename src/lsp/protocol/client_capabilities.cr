module LSP
  struct ClientCapabilities
    struct WorkspaceEditClientCapabilities
      include JSON::Serializable

      # The client supports versioned document changes in `WorkspaceEdit`s
      @[JSON::Field(key: "documentChanges")]
      property? document_changes : Bool = false
    end

    struct WorkspaceClientCapabilities
      include JSON::Serializable

      # The client supports applying batch edits
      # to the workspace by supporting the request
      # 'workspace/applyEdit'
      @[JSON::Field(key: "applyEdit")]
      property? apply_edit : Bool = false

      # Capabilities specific to `WorkspaceEdit`s
      @[JSON::Field(key: "workspaceEdit")]
      property workspace_edit : WorkspaceEditClientCapabilities?
    end

    include JSON::Serializable

    # Workspace specific client capabilities.
    property workspace : WorkspaceClientCapabilities?

    # Text document specific client capabilities.
    @[JSON::Field(key: "textDocument")]
    property text_document : TextDocumentClientCapabilities?
  end
end
