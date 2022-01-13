module LSP
  enum CodeActionTriggerKind
    # Code actions were explicitly requested by the user or by an extension.
    Invoked = 1

    # Code actions were requested automatically.
    #
    # This typically happens when current selection in a file changes, but can
    # also be triggered when file content changes.
    Automatic = 2
  end
end
