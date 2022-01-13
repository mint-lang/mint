module LSP
  #  Code Action options.
  struct CodeAction
    include JSON::Serializable

    # A struct for the disabled field to keep the comments from the
    # specification.
    struct Disabled
      include JSON::Serializable

      # Human readable description of why the code action is currently
      # disabled.
      #
      # This is displayed in the code actions UI.
      property reason : String
    end

    # A short, human-readable, title for this code action.
    property title : String

    # The kind of the code action.
    #
    # Used to filter code actions.
    property kind : String?

    # The diagnostics that this code action resolves.
    property diagnostics : Array(Diagnostic)?

    # Marks this as a preferred action. Preferred actions are used by the
    # `auto fix` command and can be targeted by keybindings.
    #
    # A quick fix should be marked preferred if it properly addresses the
    # underlying error. A refactoring should be marked preferred if it is the
    # most reasonable choice of actions to take.
    #
    # @since 3.15.0
    @[JSON::Field(key: "isPreferred")]
    property is_preferred : Bool?

    # Marks that the code action cannot currently be applied.
    #
    # Clients should follow the following guidelines regarding disabled code
    # actions:
    #
    # - Disabled code actions are not shown in automatic lightbulbs code
    #   action menus.
    #
    # - Disabled actions are shown as faded out in the code action menu when
    #   the user request a more specific type of code action, such as
    #   refactorings.
    #
    # - If the user has a keybinding that auto applies a code action and only
    #   a disabled code actions are returned, the client should show the user
    #   an error message with `reason` in the editor.
    #
    # @since 3.16.0
    property disabled : Disabled?

    # The workspace edit this code action performs.
    property edit : WorkspaceEdit?

    # A command this code action executes. If a code action
    # provides an edit and a command, first the edit is
    # executed and then the command.
    property command : Command?

    # A data entry field that is preserved on a code action between
    # a `textDocument/codeAction` and a `codeAction/resolve` request.
    #
    # @since 3.16.0
    property data : String?

    def initialize(
      @title,
      @kind,
      @edit,
      @diagnostics = [] of Diagnostic,
      @is_preferred = false,
      @disabled = nil,
      @command = nil,
      @data = nil
    )
    end
  end
end
