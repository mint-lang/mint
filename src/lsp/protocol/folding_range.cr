module LSP
  # Represents a folding range. To be valid, start and end line must be bigger
  # than zero and smaller than the number of lines in the document. Clients
  # are free to ignore invalid ranges.
  class FoldingRange
    include JSON::Serializable

    # The zero-based start line of the range to fold. The folded area starts
    # after the line's last character. To be valid, the end must be zero or
    # larger and smaller than the number of lines in the document.
    @[JSON::Field(key: "startLine")]
    property start_line : Int64

    # The zero-based character offset from where the folded range starts. If
    # not defined, defaults to the length of the start line.
    @[JSON::Field(key: "startCharacter")]
    property start_character : Int64?

    # The zero-based end line of the range to fold. The folded area ends with
    # the line's last character. To be valid, the end must be zero or larger
    # and smaller than the number of lines in the document.
    @[JSON::Field(key: "endLine")]
    property end_line : Int64

    # The zero-based character offset before the folded range ends. If not
    # defined, defaults to the length of the end line.
    @[JSON::Field(key: "endCharacter")]
    property end_character : Int64?

    # Describes the kind of the folding range such as `comment` or `region`.
    # The kind is used to categorize folding ranges and used by commands like
    # 'Fold all comments'. See [FoldingRangeKind](#FoldingRangeKind) for an
    # enumeration of standardized kinds.
    property kind : FoldingRangeKind?

    def initialize(@start_line, @end_line)
    end
  end
end
