/* Represents an HTTP request. */
record Http.Request {
  headers : Array(Http.Header),
  withCredentials : Bool,
  body : Http.Body,
  method : String,
  url : String
}

/* Represents an HTTP response. */
record Http.Response {
  status : Number,
  body : String
}

/* Represents an HTTP request which failed to load. */
record Http.ErrorResponse {
  type : Http.Error,
  status : Number,
  url : String
}

/* Represents the possible failures of an HTTP request. */
enum Http.Error {
  /* The request cannot be loaded because of a network faliure */
  NetworkError

  /* The client (browser) aborted the request */
  Aborted

  /* The request timed out */
  Timeout

  /* The url is malformed and cannot be loaded */
  BadUrl
}

/*
Module for sending HTTP requests.

```
sequence {
  response =
    "https://httpbin.org/get"
    |> Http.get()
    |> Http.send()

  Debug.log(response)
} catch Http.ErrorResponse => error {
  Debug.log(error)
}
```
*/
module Http {
  /*
  Creates an empty request record. It is useful if you want to use a non
  standard HTTP method.

    Http.empty() ==
      {
        withCredentials = false,
        method = "GET",
        body = `null`,
        headers = [],
        url = ""
      }
  */
  empty : Http.Request {
    {
      withCredentials = false,
      method = "GET",
      body = `null`,
      headers = [],
      url = ""
    }
  }

  /*
  Creates a request record where the method is DELETE

    request =
      Http.delete("https://httpbin.org/delete")

    request.method == "DELETE"
  */
  delete (urlValue : String) : Http.Request {
    empty()
    |> method("DELETE")
    |> url(urlValue)
  }

  /*
  Creates a request record where the method is GET

    request =
      Http.get("https://httpbin.org/get")

    request.method == "GET"
  */
  get (urlValue : String) : Http.Request {
    empty()
    |> method("GET")
    |> url(urlValue)
  }

  /*
  Creates a request record where the method is PUT

    request =
      Http.put("https://httpbin.org/put")

    request.method == "PUT"
  */
  put (urlValue : String) : Http.Request {
    empty()
    |> method("PUT")
    |> url(urlValue)
  }

  /*
  Creates a request record where the method is POST

    request =
      Http.post("https://httpbin.org/post")

    request.method == "POST"
  */
  post (urlValue : String) : Http.Request {
    empty()
    |> method("POST")
    |> url(urlValue)
  }

  /*
  Sets the body of the request to the given string

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.stringBody("Some string that will come back.")
    |> Http.send()
  */
  stringBody (body : String, request : Http.Request) : Http.Request {
    { request | body = `#{body}` }
  }

  /*
  Sets the body of the request to the given object encoded to JSON

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.jsonBody(encode { name = "John" })
    |> Http.send()
  */
  jsonBody (body : Object, request : Http.Request) : Http.Request {
    { request | body = `JSON.stringify(#{body})` }
  }

  /*
  Sets the body of the request to the given string

    formData =
      FormData.empty()
      |> FormData.addString("key", "value")

    "https://httpbin.org/anything"
    |> Http.post()
    |> Http.formDataBody(formData)
    |> Http.send()
  */
  formDataBody (body : FormData, request : Http.Request) : Http.Request {
    { request | body = `#{body}` }
  }

  /*
  Sets the method of the request to the given one.

    Http.empty()
    |> Http.method("PATCH")
  */
  method (method : String, request : Http.Request) : Http.Request {
    { request | method = method }
  }

  /*
  Sets the withCredentials of the request to the given one.

    Http.empty()
    |> Http.withCredentials(true)
  */
  withCredentials (value : Bool, request : Http.Request) : Http.Request {
    { request | withCredentials = value }
  }

  /*
  Sets the URL of the request to the given one.

    Http.empty()
    |> Http.url("https://httpbin.org/anything")
  */
  url (url : String, request : Http.Request) : Http.Request {
    { request | url = url }
  }

  /*
  Adds a header to the request with the given key and value.

    Http.empty()
    |> Http.header("Content-Type", "application/json")
  */
  header (key : String, value : String, request : Http.Request) : Http.Request {
    { request |
      headers =
        Array.push(
          `new Record({ value: #{value}, key: #{key} })`,
          request.headers)
    }
  }

  /*
  Aborts all running requests.

    Http.abortAll()
  */
  abortAll : Void {
    `
    this._requests && Object.keys(this._requests).forEach((uid) => {
      this._requests[uid].abort()
      delete this._requests[uid]
    })
    `
  }

  /* Returns all running requuests. */
  requests : Map(String, Http.NativeRequest) {
    `this._requests`
  }

  /*
  Sends the request with a generated unique id.

    "https://httpbin.org/get"
    |> Http.get()
    |> Http.send()
  */
  send (request : Http.Request) : Promise(Http.ErrorResponse, Http.Response) {
    sendWithID(Uid.generate(), request)
  }

  /*
  Sends the request with the given ID so it could be aborted later.

    "https://httpbin.org/get"
    |> Http.get()
    |> Http.sendWithID("my-request")
  */
  sendWithID (uid : String, request : Http.Request) : Promise(Http.ErrorResponse, Http.Response) {
    `
    new Promise((resolve, reject) => {
      if (!this._requests) { this._requests = {} }

      let xhr = new XMLHttpRequest()

      this._requests[#{uid}] = xhr

      xhr.withCredentials = #{request.withCredentials}

      try {
        xhr.open(#{request.method}.toUpperCase(), #{request.url}, true)
      } catch (error) {
        delete this._requests[#{uid}]

        reject(#{{
          type = Http.Error::BadUrl,
          status = `xhr.status`,
          url = request.url
        }})
      }

      #{request.headers}.forEach((item) => {
        xhr.setRequestHeader(item.key, item.value)
      })

      xhr.addEventListener('error', (event) => {
        delete this._requests[#{uid}]

        reject(#{{
          type = Http.Error::NetworkError,
          status = `xhr.status`,
          url = request.url
        }})
      })

      xhr.addEventListener('timeout', (event) => {
        delete this._requests[#{uid}]

        reject(#{{
          type = Http.Error::Timeout,
          status = `xhr.status`,
          url = request.url
        }})
      })

      xhr.addEventListener('load', (event) => {
        delete this._requests[#{uid}]

        resolve(#{{
          body = `xhr.responseText`,
          status = `xhr.status`
        }})
      })

      xhr.addEventListener('abort', (event) => {
        delete this._requests[#{uid}]

        reject(#{{
          type = Http.Error::Aborted,
          status = `xhr.status`,
          url = request.url
        }})
      })

      xhr.send(#{request.body})
    })
    `
  }
}
