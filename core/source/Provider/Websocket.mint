/* Provider to handle websocket connections. */
provider Provider.WebSocket : WebSocket.Config {
  /* A state to store current connections. */
  state connections : Map(String, WebSocket) = Map.empty()

  /* Handles the close event. */
  fun handleClose (url : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onClose()
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  /* Handles the error event. */
  fun handleError (url : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onError()
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  /* Handles the message event. */
  fun handleMessage (url : String, data : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onMessage(data)
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  /* Handles the open event. */
  fun handleOpen (url : String, socket : WebSocket) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onOpen(socket)
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  /* Handles updates to the provider. */
  fun update : Promise(Never, Void) {
    try {
      updatedConnections =
        subscriptions
        |> Array.reduce(
          connections,
          (
            memo : Map(String, WebSocket),
            config : WebSocket.Config
          ) {
            case (Map.get(config.url, connections)) {
              Maybe::Just => memo

              Maybe::Nothing =>
                Map.set(
                  config.url,
                  WebSocket.open(
                    {
                      onMessage = (message : String) { handleMessage(config.url, message) },
                      onOpen = (socket : WebSocket) { handleOpen(config.url, socket) },
                      reconnectOnClose = config.reconnectOnClose,
                      onClose = () { handleClose(config.url) },
                      onError = () { handleError(config.url) },
                      url = config.url
                    }),
                  memo)
            }
          })

      finalConnections =
        updatedConnections
        |> Map.reduce(
          updatedConnections,
          (
            memo : Map(String, WebSocket),
            url : String,
            socket : WebSocket
          ) {
            try {
              subscription =
                subscriptions
                |> Array.find(
                  (config : WebSocket.Config) { config.url == url })

              case (subscription) {
                Maybe::Just => memo

                Maybe::Nothing =>
                  try {
                    WebSocket.closeWithoutReconnecting(socket)
                    Map.delete(url, memo)
                  }
              }
            }
          })

      next { connections = finalConnections }
    }
  }
}
