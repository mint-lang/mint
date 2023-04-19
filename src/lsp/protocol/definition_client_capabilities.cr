module LSP
  struct DefinitionClientCapabilities
    include JSON::Serializable

    # Whether definition supports dynamic registration.
    @[JSON::Field(key: "dynamicRegistration")]
    property dynamic_registration : Bool?

    # The client supports additional metadata in the form of definition links.
    #
    # @since 3.14.0
    @[JSON::Field(key: "linkSupport")]
    property link_support : Bool?

    def initialize(@dynamic_registration = nil, @link_support = nil)
    end
  end
end
