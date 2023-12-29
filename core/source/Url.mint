/* Represents a URL */
type Url {
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
  /*
  Creates an url from the given file, which is available until the current
  window is closed.

    File.fromString("Content", "test.html", "text/html")
    |> Url.createObjectUrlFromFile()
  */
  fun createObjectUrlFromFile (file : File) : String {
    `URL.createObjectURL(#{file})`
  }

  /*
  Creates an url from the given content and type, which is available until the
  current window is closed.

    Url.createObjectUrlFromString("Content", "text/html")
  */
  fun createObjectUrlFromString (string : String, type : String) : String {
    `
    (() => {
      let blob = new Blob([#{string}], {type : #{type}})
      return URL.createObjectURL(blob)
    })()
    `
  }

  const ANCHOR = `document.createElement("a")`

  /*
  Parses the given string as an `Url`.

    Url.parse("https://www.example.com").host == "www.example.com"
  */
  fun parse (url : String) : Url {
    `
    (() => {
      #{ANCHOR}.href = #{url}

      return #{{
        hostname: `#{ANCHOR}.hostname || ""`,
        protocol: `#{ANCHOR}.protocol || ""`,
        origin: `#{ANCHOR}.origin || ""`,
        path: `#{ANCHOR}.pathname || ""`,
        search: `#{ANCHOR}.search || ""`,
        hash: `#{ANCHOR}.hash || ""`,
        host: `#{ANCHOR}.host || ""`,
        port: `#{ANCHOR}.port || ""`
      }}
    })()
    `
  }

  /*
  Converts the given `Url` to a `String`.

    (Url.parse("https://www.example.com/path/?search=foo#hash")
    |> Url.toString()) == "https://www.example.com/path/?search=foo#hash"
  */
  fun toString (url : Url) : String {
    `#{url}.origin + #{url}.path + #{url}.search + #{url}.hash`
  }

  /*
  Releases an existing object URL which was previously created.

    Url.createObjectUrlFromString("Content", "text/html")
    |> Url.revokeObjectUrl()
  */
  fun revokeObjectUrl (url : String) : Void {
    `URL.revokeObjectURL(#{url})`
  }
}
