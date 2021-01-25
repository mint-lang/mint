module LSP
  struct WorkspaceFolders
    include JSON::Serializable

    # The server has support for workspace folders
    property supported : Bool

    # Whether the server wants to receive workspace folder
    # change notifications.
    #
    # If a strings is provided the string is treated as a ID
    # under which the notification is registered on the client
    # side. The ID can be used to unregister for these events
    # using the `client/unregisterCapability` request.
    @[JSON::Field(key: "changeNotifications")]
    property change_notifications : String | Bool

    def initialize(@supported, @change_notifications)
    end
  end
end
