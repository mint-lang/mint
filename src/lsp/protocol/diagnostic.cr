module LSP
  struct Diagnostic
    include JSON::Serializable

    # The range at which the message applies.
    property range : Range

    # The diagnostic's severity. Can be omitted. If omitted it is up to the
    # client to interpret diagnostics as error, warning, info or hint.
    @[JSON::Field(converter: Enum::ValueConverter(LSP::DiagnosticSeverity))]
    property severity : DiagnosticSeverity?

    # The diagnostic's code, which might appear in the user interface.
    property code : Int32 | String

    # An optional property to describe the error code.
    #
    # @since 3.16.0
    @[JSON::Field(key: "codeDescription")]
    property code_description : CodeDescription?

    # A human-readable string describing the source of this
    # diagnostic, e.g. 'typescript' or 'super lint'.
    property source : String?

    # The diagnostic's message.
    property message : String?

    # Additional metadata about the diagnostic.
    #
    # @since 3.15.0
    property tags : Array(DiagnosticTag)?

    # An array of related diagnostic information, e.g. when symbol-names within
    # a scope collide all definitions can be marked via this property.
    @[JSON::Field(key: "relatedInformation")]
    property related_information : Array(DiagnosticRelatedInformation)?

    # A data entry field that is preserved between a
    # `textDocument/publishDiagnostics` notification and
    # `textDocument/codeAction` request.
    #
    # @since 3.16.0
    property data : String?

    def initialize(
      *,
      @severity,
      @message,
      @range,
      @code,
    )
    end
  end
end
