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

/* This module provides functions functions for working with the `Url` type. */
module Url {
  /*
  Creates an URL from the file, which is available until the current window is
  closed.

    let file =
      File.fromString("Content", "test.html", "text/html")

    Url.createObjectUrlFromFile(file)
  */
  fun createObjectUrlFromFile (file : File) : String {
    `URL.createObjectURL(#{file})`
  }

  /*
  Creates an URL from the content and type, which is available until the
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

  /*
  Parses the string as an `Url`.

    Url.parse("https://www.example.com").host == "www.example.com"
  */
  fun parse (url : String) : Url {
    let anchor =
      Dom.createElement("a")

    `
    (() => {
      #{anchor}.href = #{url}

      return #{{
        hostname: `#{anchor}.hostname || ""`,
        protocol: `#{anchor}.protocol || ""`,
        origin: `#{anchor}.origin || ""`,
        path: `#{anchor}.pathname || ""`,
        search: `#{anchor}.search || ""`,
        hash: `#{anchor}.hash || ""`,
        host: `#{anchor}.host || ""`,
        port: `#{anchor}.port || ""`
      }}
    })()
    `
  }

  /*
  Converts the url to a `String`.

    let url =
      Url.parse("https://www.example.com/path/?search=foo#hash")

    Url.toString(url) == "https://www.example.com/path/?search=foo#hash"
  */
  fun toString (url : Url) : String {
    `#{url}.origin + #{url}.path + #{url}.search + #{url}.hash`
  }

  /*
  Releases an existing object URL which was previously created.

    let url =
      Url.createObjectUrlFromString("Content", "text/html")

    Url.revokeObjectUrl(url)
  */
  fun revokeObjectUrl (url : String) : Void {
    `URL.revokeObjectURL(#{url})`
  }
}
