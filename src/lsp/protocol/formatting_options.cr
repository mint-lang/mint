module LSP
  struct FormattingOptions
    include JSON::Serializable

    # Size of a tab in spaces.
    @[JSON::Field(key: "tabSize")]
    property tab_size : Int32

    # Prefer spaces over tabs.
    @[JSON::Field(key: "insertSpaces")]
    property insert_spaces : Bool

    # Trim trailing whitespace on a line.
    #
    # @since 3.15.0
    @[JSON::Field(key: "trimTrailingWhitespace")]
    property trim_trailing_whitespace : Bool?

    # Insert a newline character at the end of the file if one does not exist.
    #
    # @since 3.15.0
    @[JSON::Field(key: "insertFinalNewline")]
    property insert_final_new_line : Bool?

    # Trim all newlines after the final newline at the end of the file.
    #
    # @since 3.15.0
    @[JSON::Field(key: "trimFinalNewlines")]
    property trim_final_new_lines : Bool?

    def initialize(@trim_trailing_whitespace,
                   @insert_final_new_line,
                   @trim_final_new_lines,
                   @insert_spaces,
                   @tab_size)
    end
  end
end
