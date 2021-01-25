module LSP
  # A notification message. A processed notification message must not send a
  # response back. They work like events.
  abstract class NotificationMessage
    include JSON::Serializable

    # The method to be invoked.
    property method : String

    abstract def execute(server : Server)
  end
end
