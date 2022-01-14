module LSP
  class CodeActionContext
    include JSON::Serializable

    # An array of diagnostics known on the client side overlapping the range
    # provided to the `textDocument/codeAction` request. They are provided so
    # that the server knows which errors are currently presented to the user
    # for the given range. There is no guarantee that these accurately reflect
    # the error state of the resource. The primary parameter
    # to compute code actions is the provided range.
    property diagnostics : Array(Diagnostic)

    # Requested kind of actions to return.
    #
    # Actions not of this kind are filtered out by the client before being
    # shown. So servers can omit computing them.
    property only : Array(String)?

    # The reason why code actions were requested.
    @[JSON::Field(key: "triggerKind", converter: Enum::ValueConverter(LSP::CodeActionTriggerKind))]
    property trigger_kind : CodeActionTriggerKind?
  end
end
