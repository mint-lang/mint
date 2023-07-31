module LSP
  # A request message to describe a request between the client and the server.
  # Every processed request must send a response back to the sender of the
  # request.
  abstract class RequestMessage
    include JSON::Serializable

    # WHY IS THIS NEEDED FOR 1.9.1 and not for 1.8??????
    property snippet_support : Bool?

    # The request id.
    property id : Int32 | String

    # The method to be invoked.
    property method : String

    abstract def execute(server : Server)
  end
end
