(function connect(reload = false) {
  let closing = false;

  window.addEventListener("beforeunload", () => {
    closing = true;
  });

  // Connect to websocket on the same url.
  var ws = new WebSocket("ws://" + location.host);

  // On open reload if necessary.
  ws.onopen = () => {
    if (reload) {
      window.location.reload();
    }
  };

  // On close try to reconnect, it will happen during the development of Mint.
  ws.onclose = () => {
    if (!closing) {
      // Debounce so we don't end up in an infinite restart loop.
      setTimeout(() => connect(true), 200);
    }
  };

  // Reload on message.
  ws.onmessage = msg => {
    if (msg.data == "reload") {
      window.location.reload();
    }
  };
})();
