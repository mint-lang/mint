(function connect(reload = false) {
  // Connect to websocket on the same url
  var ws = new WebSocket("ws://" + location.host);

  // On open reload if necessary
  ws.onopen = () => {
    if (reload) {
      window.location.reload();
    }
  };

  // On try close reconnect, it will happen during the development
  // of Mint.
  ws.onclose = () => {
    // Debounce so we don't end up in an infinite restart loop
    setTimeout(() => connect(true), 200);
  };

  // Reload on message
  ws.onmessage = msg => {
    if (msg.data == "reload") {
      window.location.reload();
    }
  };
})();
