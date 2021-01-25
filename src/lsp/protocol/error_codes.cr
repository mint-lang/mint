module LSP
  enum ErrorCodes
    ParseError           = -32700
    InvalidRequest       = -32600
    MethodNotFound       = -32601
    InvalidParams        = -32602
    InternalError        = -32603
    ServerNotInitialized = -32002
    ServerErrorStart     = -32099
    ServerErrorEnd       = -32000
    UnknownErrorCode     = -32001
    RequestCancelled     = -32800
  end
end
