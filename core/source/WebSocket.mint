/* Data structure for WebSocket configurations. */
type WebSocket.Config {
  onOpen : Function(WebSocket, Promise(Void)),
  onMessage : Function(String, Promise(Void)),
  onError : Function(Promise(Void)),
  onClose : Function(Promise(Void)),
  reconnectOnClose : Bool,
  url : String
}

/*
This module provides functions for working with the [WebSocket Web API].

[WebSocket Web API]: https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
*/
module WebSocket {
  /*
  Closes the connection. If the `reconnectOnClose` flag was specified then the
  connection will reconnect using this function.

    WebSocket.close(websocket)
  */
  fun close (socket : WebSocket) : Promise(Void) {
    `#{socket}.close()`
  }

  /*
  Closes the connection without reconnecting, even if the `reconnectOnClose`
  flag was set.

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

  /*
  Creates a `WebSocket` connection using the provided configuration. If
  `reconnectOnClose` is set then when a connection is closed it tries to
  reconnect, using the same configuration (basically calls open again).

    WebSocket.open({
      url: "wss://echo.websocket.org",
      reconnectOnClose: true,
      onMessage: handleMessage,
      onError: handleError,
      onClose: handleClose,
      onOpen: handleOpen
    })
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
  Sends the data to the connection.

    WebSocket.send(websocket, "some data")
  */
  fun send (socket : WebSocket, data : String) : Promise(Void) {
    `#{socket}.send(#{data})`
  }
}
