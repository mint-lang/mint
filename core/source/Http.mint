/* Represents a HTTP header */
type Http.Header {
  value : String,
  key : String
}

/* Represents an HTTP request. */
type Http.Request {
  headers : Array(Http.Header),
  withCredentials : Bool,
  body : Http.Body,
  method : String,
  url : String
}

/* Represents an HTTP response. */
type Http.Response {
  headers : Map(String, String),
  body : Http.ResponseBody,
  bodyString : String,
  status : Number
}

/* Represents the progress of an upload or download. */
type Http.Progress {
  Progress(Number)
  Uncalculable
}

/* Represents the body of a HTTP response. */
type Http.ResponseBody {
  FormData(FormData)
  JSON(Object)
  HTML(Object)
  Text(String)
  XML(Object)
  File(File)
}

/* Represents an HTTP request which failed to load. */
type Http.ErrorResponse {
  headers : Map(String, String),
  type : Http.Error,
  status : Number,
  url : String
}

/* Represents the possible failures of an HTTP request. */
type Http.Error {
  /* The request cannot be loaded because of a network failure */
  NetworkError

  /* The client (browser) aborted the request */
  Aborted

  /* The request timed out */
  Timeout

  /* The url is malformed and cannot be loaded */
  BadUrl
}

/*
This store provides functions for sending and tracking HTTP requests.

```mint
let request =
  await "https://httpbin.org/get"
  |> Http.get()
  |> Http.send()

case (request) {
  Ok(response) =>
    Debug.log(response)

  Err(error) =>
    Debug.log(error)
}
```
*/
store Http {
  /* The state for tracking requests. */
  state requests = { } of String => Object

  /*
  Aborts the running request with the id.

    Http.abort("my-request")
  */
  fun abort (id : String) : Promise(Void) {
    if let Just(request) = requests[id] {
      `#{request}.abort()`
    }

    next { requests: Map.delete(requests, id) }
  }

  /*
  Aborts all running requests.

    Http.abortAll()
  */
  fun abortAll : Promise(Void) {
    for key, object of requests {
      `#{object}.abort()`
    }

    next { requests: { } of String => Object }
  }

  /*
  Creates a request record where the method is `DELETE`.

    Http.delete("https://httpbin.org/delete").method == "DELETE"
  */
  fun delete (value : String) : Http.Request {
    empty()
    |> method("DELETE")
    |> url(value)
  }

  /*
  Creates an empty request record. It is useful if you want to use a
  non-standard HTTP method.

    Http.empty() ==
      {
        withCredentials: false,
        method: "GET",
        body: `null`,
        headers: [],
        url: ""
      }
  */
  fun empty : Http.Request {
    { withCredentials: false, method: "GET", body: `null`, headers: [], url: "" }
  }

  /*
  Sets the body of the request to the provided `FormData` object.

    let formData =
      FormData.empty()
      |> FormData.addString("key", "value")

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.formDataBody(formData)
    |> Http.send()
  */
  fun formDataBody (request : Http.Request, body : FormData) : Http.Request {
    { request | body: `#{body}` }
  }

  /*
  Creates a request record where the method is `GET`.

    Http.get("https://httpbin.org/get").method == "GET"
  */
  fun get (urlValue : String) : Http.Request {
    empty()
    |> method("GET")
    |> url(urlValue)
  }

  /*
  Checks the presence of a header with the key.

    Http.empty()
    |> Http.header("Content-Type", "application/json")
    |> Http.hasHeader("Content-Type") == true
  */
  fun hasHeader (request : Http.Request, key : String) : Bool {
    request.headers
    |> Array.any(
      (header : Http.Header) : Bool {
        String.toLowerCase(header.key) == String.toLowerCase(key)
      })
  }

  /*
  Adds a header to the request with the key and value. Overwrites the value
  if key already exists.

    Http.empty()
    |> Http.header("Content-Type", "application/json")
  */
  fun header (
    request : Http.Request,
    key : String,
    value : String
  ) : Http.Request {
    { request |
      headers:
        request.headers
        |> Array.reject(
          (header : Http.Header) : Bool {
            String.toLowerCase(header.key) == String.toLowerCase(key)
          })
        |> Array.push({ key: key, value: value })
    }
  }

  /*
  Sets the body of the request to the object encoded to JSON.

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.jsonBody(encode { name: "John" })
    |> Http.send()
  */
  fun jsonBody (request : Http.Request, body : Object) : Http.Request {
    if hasHeader(request, "Content-Type") {
      { request | body: `JSON.stringify(#{body})` }
    } else {
      { request | body: `JSON.stringify(#{body})` }
      |> Http.header("Content-Type", "application/json")
    }
  }

  /*
  Sets the method of the request.

    Http.empty()
    |> Http.method("PATCH")
  */
  fun method (request : Http.Request, method : String) : Http.Request {
    { request | method: method }
  }

  /*
  Creates a request record where the method is `POST`.

    Http.post("https://httpbin.org/post").method == "POST"
  */
  fun post (urlValue : String) : Http.Request {
    empty()
    |> method("POST")
    |> url(urlValue)
  }

  /*
  Creates a request record where the method is `PUT`.

    Http.put("https://httpbin.org/put").method == "PUT"
  */
  fun put (urlValue : String) : Http.Request {
    empty()
    |> method("PUT")
    |> url(urlValue)
  }

  /*
  Sends the request with the ID (generated if not provided) so it could be
  aborted later. The running request with the same id is aborted before the new
  request is sent.

    "https://httpbin.org/get"
    |> Http.get()
    |> Http.send("my-request")
  */
  fun send (
    request : Http.Request,
    id : String = Uid.generate(),
    instrument : Function(Object, a) = (value : Object) { void },
    uploadProgress : Function(Http.Progress, a) = (progress : Http.Progress) {
      void
    },
    downloadProgress : Function(Http.Progress, a) = (progress : Http.Progress) {
      void
    }
  ) : Promise(Result(Http.ErrorResponse, Http.Response)) {
    await abort(id)

    `
    new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();
      #{next { requests: Map.set(requests, id, `xhr`)}};

      xhr.withCredentials = #{request.withCredentials}
      xhr.responseType = "blob"

      const getResponseHeaders = () => {
        return xhr.getAllResponseHeaders().trim().split(/[\r\n]+/).map((line) => {
          const parts = line.split(': ');
          return [parts.shift(), parts.join(': ')];
        })
      }

      try {
        xhr.open(#{request.method}.toUpperCase(), #{request.url}, true)
      } catch (error) {
        #{next { requests: Map.delete(requests, id)}}

        resolve(#{Result.Err({
          headers: `getResponseHeaders()`,
          type: Http.Error.BadUrl,
          status: `xhr.status`,
          url: request.url
        })})
      }

      #{request.headers}.forEach((item) => {
        xhr.setRequestHeader(item.key, item.value)
      })

      xhr.addEventListener('error', (event) => {
        #{next { requests: Map.delete(requests, id)}}

        resolve(#{Result.Err({
          headers: `getResponseHeaders()`,
          type: Http.Error.NetworkError,
          status: `xhr.status`,
          url: request.url
        })})
      })

      xhr.addEventListener('abort', (event) => {
        #{next { requests: Map.delete(requests, id)}}

        resolve(#{Result.Err({
          headers: `getResponseHeaders()`,
          type: Http.Error.Aborted,
          status: `xhr.status`,
          url: request.url
        })})
      })

      xhr.addEventListener('timeout', (event) => {
        #{next { requests: Map.delete(requests, id)}}

        resolve(#{Result.Err({
          headers: `getResponseHeaders()`,
          type: Http.Error.Timeout,
          status: `xhr.status`,
          url: request.url
        })})
      })

      xhr.addEventListener('load', async (event) => {
        #{next { requests: Map.delete(requests, id)}}

        const contentType = xhr.getResponseHeader("Content-Type") || "";
        const responseText = await xhr.response.text();
        let body;

        if (contentType.startsWith("text/html")) {
          const object =
            (new DOMParser()).parseFromString(responseText, "text/html");

          const errorNode =
            object.querySelector("parsererror");

          if (errorNode) {
            body = #{Http.ResponseBody.Text(`responseText`)};
          } else {
            body = #{Http.ResponseBody.HTML(`object`)};
          }
        } else if (contentType.startsWith("application/xml")) {
          const object =
            (new DOMParser()).parseFromString(responseText, "application/xml");

          const errorNode =
            object.querySelector("parsererror");

          if (errorNode) {
            body = #{Http.ResponseBody.Text(`responseText`)};
          } else {
            body = #{Http.ResponseBody.XML(`object`)};
          }
        } else if (contentType.startsWith("application/json")) {
          try {
            body = #{Http.ResponseBody.JSON(`JSON.parse(responseText)`)};
          } catch (e) {
            body = #{Http.ResponseBody.Text(`responseText`)};
          }
        } else if (contentType.startsWith("text/")) {
          body = #{Http.ResponseBody.Text(`responseText`)};
        } else if (contentType.startsWith('multipart/form-data')) {
          const response =
            new Response(await xhr.response.arrayBuffer(), {
              headers: getResponseHeaders(),
              statusText: xhr.statusText,
              status: xhr.status,
            });

          const formData =
            await response.formData();

          body = #{Http.ResponseBody.FormData(`formData`)};
        }

        if (!body) {
          const parts = #{Url.parse(request.url).path}.split('/');
          const file = new File([xhr.response], parts[parts.length - 1], {
            type: contentType
          });

          body = #{Http.ResponseBody.File(`file`)};
        }

        resolve(#{Result.Ok({
          headers: `getResponseHeaders()`,
          bodyString: `responseText`,
          status: `xhr.status`,
          body: `body`,
        })})
      })

      #{instrument(`xhr`)};

      xhr.upload.addEventListener('progress', (event) => {
        if (event.lengthComputable) {
          #{uploadProgress(Http.Progress.Progress(Math.clamp(`event.loaded / event.total`, 0, 1)))}
        } else {
          #{uploadProgress(Http.Progress.Uncalculable)}
        }
      });

      xhr.addEventListener('progress', (event) => {
        if (event.lengthComputable) {
          #{downloadProgress(Http.Progress.Progress(Math.clamp(`event.loaded / event.total`, 0, 1)))}
        } else {
          #{downloadProgress(Http.Progress.Uncalculable)}
        }
      })

      xhr.send(#{request.body})
    })
    `
  }

  /*
  Sets the body of the request as `String`.

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.stringBody("Some string that will come back.")
    |> Http.send()
  */
  fun stringBody (request : Http.Request, body : String) : Http.Request {
    { request | body: `#{body}` }
  }

  /*
  Sets the URL of the request.

    Http.empty()
    |> Http.url("https://httpbin.org/anything")
  */
  fun url (request : Http.Request, url : String) : Http.Request {
    { request | url: url }
  }

  /*
  Sets the `withCredentials` of the request.

    Http.empty()
    |> Http.withCredentials(true)
  */
  fun withCredentials (request : Http.Request, value : Bool) : Http.Request {
    { request | withCredentials: value }
  }
}
