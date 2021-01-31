module LSP
  struct ExecuteCommandOptions
    include JSON::Serializable

    # The commands to be executed on the server
    property commands : Array(String)

    def initialize(@commands)
    end
  end
end
