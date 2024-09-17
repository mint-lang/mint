require "./text_document_identifier"

module LSP
  class OptionalVersionedTextDocumentIdentifier < TextDocumentIdentifier
    # The version number of this document. If an optional versioned text document
    # identifier is sent from the server to the client and the file is not
    # open in the editor (the server has not received an open notification
    # before) the server can send `null` to indicate that the version is
    # known and the content on disk is the master (as specified with document
    # content ownership).
    #
    # The version number of a document will increase after each change,
    # including undo/redo. The number doesn't need to be consecutive.
    property version : Int64?
  end
end
