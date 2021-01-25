module LSP
  struct TextDocumentSyncOptions
    include JSON::Serializable

    # Open and close notifications are sent to the server.
    @[JSON::Field(key: "openClose")]
    property open_close : Bool

    # Change notifications are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full
    # and TextDocumentSyncKind.Incremental. If omitted it defaults to TextDocumentSyncKind.None.
    property change : TextDocumentSyncKind

    # Will save notifications are sent to the server.
    @[JSON::Field(key: "willSave")]
    property will_save : Bool

    # Will save wait until requests are sent to the server.
    @[JSON::Field(key: "willSaveWaitUntil")]
    property will_save_wait_until : Bool

    # Save notifications are sent to the server.
    property save : SaveOptions

    def initialize(
      @will_save_wait_until,
      @open_close,
      @will_save,
      @change,
      @save
    )
    end
  end
end
