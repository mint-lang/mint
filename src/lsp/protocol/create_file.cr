module LSP
  struct CreateFile
    include JSON::Serializable

    # The resource to create.
    property uri : String

    # Additional options
    property options : CreateFileOptions?

    # An optional annotation identifier describing the operation.
    #
    # @since 3.16.0
    #
    # TODO:
    # @[JSON::Field(key: "annotationId")]
    # property annotation_id : ChangeAnnotationIdentifier?

    def initialize(@uri)
    end
  end
end
