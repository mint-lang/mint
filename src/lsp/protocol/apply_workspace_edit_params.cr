module LSP
  struct ApplyWorkspaceEditParams
    include JSON::Serializable

    # An optional label of the workspace edit. This label is
    # presented in the user interface for example on an undo
    # stack to undo the workspace edit.
    property label : String?

    # The edits to apply.
    property edit : WorkspaceEdit

    def initialize(@edit)
    end
  end
end
