module LSP
  # A Response Message sent as a result of a request. If a request doesn’t
  # provide a result value the receiver of a request still needs to return a
  # response message to conform to the JSON RPC specification. The result
  # property of the ResponseMessage should be set to null in this case to
  # signal a successful request.
  class ResponseMessage
    include JSON::Serializable

    # The request id.
    property id : Int32 | String?
  end
end
