module LSP
  enum CompletionTriggerKind
    # Completion was triggered by typing an identifier (24x7 code
    # complete), manual invocation (e.g Ctrl+Space) or via API.
    Invoked = 1

    # Completion was triggered by a trigger character specified by
    # the `triggerCharacters` properties of the `CompletionRegistrationOptions`.
    TriggerCharacter = 2

    # Completion was re-triggered as the current completion list is incomplete.
    TriggerForIncompleteCompletions = 3
  end
end
