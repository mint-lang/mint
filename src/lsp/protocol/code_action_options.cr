module LSP
  #  Code Action options.
  struct CodeActionOptions
    include JSON::Serializable

    # CodeActionKinds that this server may return.
    #
    # The list of kinds may be generic, such as `CodeActionKind.Refactor`, or the server
    # may list out every specific kind they provide.
    @[JSON::Field(key: "codeActionKinds")]
    property code_action_kinds : Array(String)

    def initialize(@code_action_kinds)
    end
  end
end
