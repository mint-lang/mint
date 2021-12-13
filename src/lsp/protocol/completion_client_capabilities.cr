module LSP
  struct CompletionClientCapabilities
    struct CompletionItem
      include JSON::Serializable

      # Client supports snippets as insert text.
      #
      # A snippet can define tab stops and placeholders with `$1`, `$2`
      # and `${3:foo}`. `$0` defines the final tab stop, it defaults to
      # the end of the snippet. Placeholders with equal identifiers are
      # linked, that is typing in one will update others too.
      @[JSON::Field(key: "snippetSupport")]
      property snippet_support : Bool?
    end

    include JSON::Serializable

    # The client supports the following `CompletionItem` specific
    # capabilities.
    @[JSON::Field(key: "completionItem")]
    property completion_item : CompletionItem?

    def initialize(@completion_item = nil)
    end
  end
end
