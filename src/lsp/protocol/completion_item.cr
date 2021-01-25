module LSP
  struct CompletionItem
    include JSON::Serializable

    # The label of this completion item. By default
    # also the text that is inserted when selecting
    # this completion.
    property label : String

    # The kind of this completion item. Based of the kind
    # an icon is chosen by the editor.
    property kind : CompletionItemKind

    # A human-readable string with additional information
    # about this item, like type or symbol information.
    property detail : String

    # A human-readable string that represents a doc-comment.
    property documentation : String

    # Indicates if this item is deprecated.
    property deprecated : Bool

    # Select this item when showing.
    #
    # *Note* that only one completion item can be selected and that the
    # tool / client decides which item that is. The rule is that the *first*
    # item of those that match best is selected.
    property preselect : Bool

    # A string that should be used when comparing this item
    # with other items. When `falsy` the label is used.
    @[JSON::Field(key: "sortText")]
    property sort_text : String

    # A string that should be used when filtering a set of
    # completion items. When `falsy` the label is used.
    @[JSON::Field(key: "filterText")]
    property filter_text : String

    # A string that should be inserted into a document when selecting
    # this completion. When `falsy` the label is used.
    #
    # The `insertText` is subject to interpretation by the client side.
    # Some tools might not take the string literally. For example
    # VS Code when code complete is requested in this example `con<cursor position>`
    # and a completion item with an `insertText` of `console` is provided it
    # will only insert `sole`. Therefore it is recommended to use `textEdit` instead
    # since it avoids additional client side interpretation.
    #
    # @deprecated Use textEdit instead.
    @[JSON::Field(key: "insertText")]
    property insert_text : String

    # The format of the insert text. The format applies to both the
    # `insertText` property and the `newText` property of a provided
    # `textEdit`. If omitted defaults to `InsertTextFormat.PlainText`.
    @[JSON::Field(key: "insertTextFormat")]
    property insert_text_format : Int32?

    def initialize(@insert_text_format = 2,
                   @documentation = "",
                   @deprecated = false,
                   @preselect = false,
                   @sort_text = false,
                   @filter_text = "",
                   @insert_text = "",
                   @detail = "",
                   @label = "",
                   @kind = 1)
    end
  end
end
