module LSP
  struct InitializeResult
    include JSON::Serializable

    # The capabilities the language server provides.
    property capabilities : ServerCapabilities

    def initialize(@capabilities)
    end
  end
end
