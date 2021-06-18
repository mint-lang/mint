/* Provider to handle websocket connections. */
provider Provider.WebSocket : WebSocket.Config {
  state connections : Map(String, WebSocket) = Map.empty()

  fun onOpen (url : String, socket : WebSocket) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onOpen(socket)
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  fun onMessage (url : String, data : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onMessage(data)
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  fun onError (url : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onError()
      } when {
        subscription.url == url
      }

      next { }
    }
  }

  fun onClose (url : String) : Promise(Never, Void) {
    sequence {
      for (subscription of subscriptions) {
        subscription.onClose()
      } when {
        subscription.url == url
      }

      next { }
    }
  }

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
              Maybe::Nothing =>
                Map.set(
                  config.url,
                  WebSocket.open(
                    {
                      onMessage = (message : String) { onMessage(config.url, message) },
                      onOpen = (socket : WebSocket) { onOpen(config.url, socket) },
                      onClose = () { onClose(config.url) },
                      onError = () { onError(config.url) },
                      reconnectOnClose = config.reconnectOnClose,
                      url = config.url
                    }),
                  memo)

              Maybe::Just => memo
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
