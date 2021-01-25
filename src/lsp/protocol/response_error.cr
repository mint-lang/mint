module LSP
  class ResponseError
    include JSON::Serializable

    # A number indicating the error type that occurred.
    property code : Int32

    # A string providing a short description of the error.
    property message : String
  end
end
