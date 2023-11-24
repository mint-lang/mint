/* Provider to handle websocket connections. */
provider Provider.WebSocket : WebSocket.Config {
  /* A state to store current connections. */
  state connections : Map(String, WebSocket) = Map.empty()

  /* Handles the open event. */
  fun onOpen (url : String, socket : WebSocket) : Promise(Void) {
    for subscription of subscriptions {
      subscription.onOpen(socket)
    } when {
      subscription.url == url
    }

    next { }
  }

  /* Handles the message event. */
  fun onMessage (url : String, data : String) : Promise(Void) {
    for subscription of subscriptions {
      subscription.onMessage(data)
    } when {
      subscription.url == url
    }

    next { }
  }

  /* Handles the error event. */
  fun onError (url : String) : Promise(Void) {
    for subscription of subscriptions {
      subscription.onError()
    } when {
      subscription.url == url
    }

    next { }
  }

  /* Handles the close event. */
  fun onClose (url : String) : Promise(Void) {
    for subscription of subscriptions {
      subscription.onClose()
    } when {
      subscription.url == url
    }

    next { }
  }

  /* Handles updates to the provider. */
  fun update : Promise(Void) {
    let updatedConnections =
      subscriptions
      |> Array.reduce(
        connections,
        (
          memo : Map(String, WebSocket),
          config : WebSocket.Config
        ) {
          if Map.get(connections, config.url) == Maybe.Nothing {
            Map.set(
              memo,
              config.url,
              WebSocket.open(
                {
                  onMessage: (message : String) { onMessage(config.url, message) },
                  onOpen: (socket : WebSocket) { onOpen(config.url, socket) },
                  onClose: () { onClose(config.url) },
                  onError: () { onError(config.url) },
                  reconnectOnClose: config.reconnectOnClose,
                  url: config.url
                }))
          } else {
            memo
          }
        })

    let finalConnections =
      updatedConnections
      |> Map.reduce(
        updatedConnections,
        (
          memo : Map(String, WebSocket),
          url : String,
          socket : WebSocket
        ) {
          let subscription =
            Array.find(subscriptions, (config : WebSocket.Config) { config.url == url })

          if subscription == Maybe.Nothing {
            WebSocket.closeWithoutReconnecting(socket)
            Map.delete(memo, url)
          } else {
            memo
          }
        })

    next { connections: finalConnections }
  }
}
