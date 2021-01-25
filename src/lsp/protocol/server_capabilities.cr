module LSP
  struct ServerCapabilities
    include JSON::Serializable

    # Defines how text documents are synced. Is either a detailed structure
    # defining each notification or for backwards compatibility the TextDocumentSyncKind
    # number. If omitted it defaults to `TextDocumentSyncKind.None`
    @[JSON::Field(key: "textDocumentSync")]
    property text_document_sync : TextDocumentSyncOptions | Int32

    # The server provides hover support.
    @[JSON::Field(key: "hoverProvider")]
    property hover_provider : Bool

    # The server provides completion support.
    @[JSON::Field(key: "completionProvider")]
    property completion_provider : CompletionOptions

    # The server provides signature help support.
    @[JSON::Field(key: "signatureHelpProvider")]
    property signature_help_provider : SignatureHelpOptions

    # The server provides goto definition support.
    @[JSON::Field(key: "definitionProvider")]
    property definition_provider : Bool

    # The server provides Goto Type Definition support.
    @[JSON::Field(key: "typeDefinitionProvider")]
    property type_definition_provider : Bool

    # The server provides Goto Implementation support.
    @[JSON::Field(key: "implementationProvider")]
    property implementation_provider : Bool

    # The server provides find references support.
    @[JSON::Field(key: "referencesProvider")]
    property references_provider : Bool

    # The server provides document highlight support.
    @[JSON::Field(key: "documentHighlightProvider")]
    property document_highlight_provider : Bool

    # The server provides document symbol support.
    @[JSON::Field(key: "documentSymbolProvider")]
    property document_symbol_provider : Bool

    # The server provides workspace symbol support.
    @[JSON::Field(key: "workspaceSymbolProvider")]
    property workspace_symbol_provider : Bool

    # The server provides code actions. The `CodeActionOptions` return type is only
    # valid if the client signals code action literal support via the property
    # `textDocument.codeAction.codeActionLiteralSupport`.
    @[JSON::Field(key: "codeActionProvider")]
    property code_action_provider : Bool | CodeActionOptions

    # The server provides code lens.
    @[JSON::Field(key: "codeLensProvider")]
    property code_lens_provider : CodeLensOptions

    # The server provides document formatting.
    @[JSON::Field(key: "documentFormattingProvider")]
    property document_formatting_provider : Bool

    # The server provides document range formatting.
    @[JSON::Field(key: "documentRangeFormattingProvider")]
    property document_range_formatting_provider : Bool

    # The server provides document formatting on typing.
    @[JSON::Field(key: "documentOnTypeFormattingProvider")]
    property document_on_type_formatting_provider : DocumentOnTypeFormattingOptions

    #  The server provides rename support. RenameOptions may only be
    #  specified if the client states that it supports
    #  `prepareSupport` in its initial `initialize` request.
    @[JSON::Field(key: "renameProvider")]
    property rename_provider : Bool | RenameOptions

    # The server provides document link support.
    @[JSON::Field(key: "documentLinkProvider")]
    property document_link_provider : DocumentLinkOptions

    # The server provides color provider support.
    @[JSON::Field(key: "colorProvider")]
    property color_provider : Bool | ColorProviderOptions

    # The server provides folding provider support.
    @[JSON::Field(key: "foldingRangeProvider")]
    property folding_range_provider : Bool | FoldingRangeProviderOptions

    # The server provides go to declaration support.
    @[JSON::Field(key: "declarationProvider")]
    property declaration_provider : Bool

    # The server provides execute command support.
    @[JSON::Field(key: "executeCommandProvider")]
    property execute_command_provider : ExecuteCommandOptions

    # Workspace specific server capabilities
    property workspace : Workspace

    def initialize(
      @document_on_type_formatting_provider,
      @document_range_formatting_provider,
      @document_formatting_provider,
      @document_highlight_provider,
      @workspace_symbol_provider,
      @document_symbol_provider,
      @type_definition_provider,
      @execute_command_provider,
      @signature_help_provider,
      @implementation_provider,
      @folding_range_provider,
      @document_link_provider,
      @code_action_provider,
      @declaration_provider,
      @completion_provider,
      @definition_provider,
      @references_provider,
      @code_lens_provider,
      @text_document_sync,
      @rename_provider,
      @color_provider,
      @hover_provider,
      @workspace
    )
    end
  end
end
