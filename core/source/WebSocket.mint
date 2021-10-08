record WebSocket.Config {
  onOpen : Function(WebSocket, Promise(Void)),
  onMessage : Function(String, Promise(Void)),
  onError : Function(Promise(Void)),
  onClose : Function(Promise(Void)),
  reconnectOnClose : Bool,
  url : String
}

/* This module provides a wrapper over the WebSocket Web API. */
module WebSocket {
  /*
  Creates a websocket connection from the given configuration:

    websocket =
      WebSocket.open({
        url = "wss://echo.websocket.org",
        reconnectOnClose = true,
        onMessage = handleMessage,
        onError = handleError,
        onClose = handleClose,
        onOpen = handleOpen
      })

  If `reconnectOnClose` is set then when a connection is closed it tries to
  reconnect, using the same configuration (basically calls open again).
  */
  fun open (config : WebSocket.Config) : WebSocket {
    `
    (() => {
      /* Initialize a new WebSocket object. */
      const socket = new WebSocket(#{config.url});

      /* Event handlers. */
      const onMessage = (event) => #{config.onMessage(`event.data`)}
      const onOpen = () => #{config.onOpen(`socket`)}
      const onError = () => #{config.onError()}

      /*
      *  The close event handler is different:
      *  - removes event listeners
      *  - reconnects as a new websocket connection if specified
      *  - calls close event handler
      */
      const onClose = () => {
        socket.removeEventListener("message", onMessage);
        socket.removeEventListener("error", onError);
        socket.removeEventListener("close", onClose);
        socket.removeEventListener("open", onOpen);

        #{config.onClose()};

        if (#{config.reconnectOnClose} && !socket.shouldNotReconnect) {
          #{open(config)};
        }

        delete socket.shouldNotReconnect;
      }

      /* Add event listeners. */
      socket.addEventListener("message", onMessage)
      socket.addEventListener("error", onError)
      socket.addEventListener("close", onClose)
      socket.addEventListener("open", onOpen)

      return socket
    })()
    `
  }

  /*
  Sends the given data to the given websocket connection.

    WebSocket.send("some data", websocket)
  */
  fun send (data : String, socket : WebSocket) : Promise(Void) {
    `#{socket}.send(#{data})`
  }

  /*
  Closes the given websocket connection.

    WebSocket.close(websocket)

  If the `reconnectOnClose` flag was specified then the connection will
  reconnect using this function.
  */
  fun close (socket : WebSocket) : Promise(Void) {
    `#{socket}.close()`
  }

  /*
  Closes the given websocket connection without reconnecting, even if the
  `reconnectOnClose` flag was set.

    WebSocket.closeWithoutReconnecting(websocket)
  */
  fun closeWithoutReconnecting (socket : WebSocket) : Promise(Void) {
    `
    (() => {
      #{socket}.shouldNotReconnect = true;
      #{socket}.close();
    })()
    `
  }
}
