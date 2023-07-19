module LSP
  struct TextDocumentClientCapabilities
    include JSON::Serializable

    # Capabilities specific to the `textDocument/completion` request.
    property completion : CompletionClientCapabilities?

    # Capabilities specific to the `textDocument/definition` request.
    property definition : DefinitionClientCapabilities?

    # Capabilities specific to the `textDocument/semanticTokens` request.
    @[JSON::Field(key: "semanticTokens")]
    property semantic_tokens : SemanticTokensClientCapabilities?
  end
end
