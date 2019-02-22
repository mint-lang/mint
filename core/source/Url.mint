/* Represents a URL */
record Url {
  hostname : String,
  protocol : String,
  origin : String,
  search : String,
  path : String,
  hash : String,
  host : String,
  port : String
}

/* Utility functions for working with `Url` */
module Url {
  /* Parses the given string as an `Url`. */
  fun parse (url : String) : Url {
    `
    (() => {
      if (!this._a) {
        this._a = document.createElement('a')
      }

      this._a.href = url

      return {
        hostname: this._a.hostname || "",
        protocol: this._a.protocol || "",
        origin: this._a.origin || "",
        path: this._a.pathname || "",
        search: this._a.search || "",
        hash: this._a.hash || "",
        host: this._a.host || "",
        port: this._a.port || ""
      }
    })()
    `
  }

  /*
  Creates an url from the given content and type, which is available until the
  current window is closed.

    Url.createObjectUrlFromString("Content", "text/html")
  */
  fun createObjectUrlFromString (string : String, type : String) : String {
    `
    (() => {
      let blob = new Blob([string], {type : type})
      return URL.createObjectURL(blob)
    })()
    `
  }

  /*
  Creates an url from the given file, which is available until the current
  window is closed.

    File.fromString("Content", "test.html", "text/html")
    |> Url.createObjectUrlFromFile()
  */
  fun createObjectUrlFromFile (file : File) : String {
    `URL.createObjectURL(file)`
  }

  /*
  Releases an existing object URL which was previously created.

    Url.createObjectUrlFromString("Content", "text/html")
    |> Url.revokeObjectUrl()
  */
  fun revokeObjectUrl (url : String) : Void {
    `URL.revokeObjectURL(url)`
  }
}
