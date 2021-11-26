module LSP
  struct TextDocumentClientCapabilities
    include JSON::Serializable

    # Capabilities specific to the `textDocument/completion` request.
    property completion : CompletionClientCapabilities?
  end
end
