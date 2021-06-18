suite "Http.empty" {
  test "it returns an empty request" {
    Http.empty() == {
      withCredentials = false,
      method = "GET",
      body = `null`,
      headers = [],
      url = ""
    }
  }
}

suite "Http.delete" {
  test "it returns an empty DELETE request" {
    Http.delete("url") == {
      withCredentials = false,
      method = "DELETE",
      body = `null`,
      headers = [],
      url = "url"
    }
  }
}

suite "Http.get" {
  test "it returns an empty DELETE request" {
    Http.get("url") == {
      withCredentials = false,
      method = "GET",
      body = `null`,
      headers = [],
      url = "url"
    }
  }
}

suite "Http.put" {
  test "it returns an empty DELETE request" {
    Http.put("url") == {
      withCredentials = false,
      method = "PUT",
      body = `null`,
      headers = [],
      url = "url"
    }
  }
}

suite "Http.post" {
  test "it returns an empty DELETE request" {
    Http.post("url") == {
      withCredentials = false,
      method = "POST",
      body = `null`,
      headers = [],
      url = "url"
    }
  }
}

suite "Http.stringBody" {
  test "it sets the body of a request to a string" {
    (Http.empty()
    |> Http.stringBody("Hello")) == {
      withCredentials = false,
      body = `"Hello"`,
      method = "GET",
      headers = [],
      url = ""
    }
  }
}

suite "Http.formDataBody" {
  test "it sets the body of a request to a FormData" {
    (Http.empty()
    |> Http.formDataBody(FormData.empty())) == {
      withCredentials = false,
      body = `new FormData()`,
      method = "GET",
      headers = [],
      url = ""
    }
  }
}

suite "Http.jsonBody" {
  test "it sets the body of a request to a Json" {
    (Http.empty()
    |> Http.header("existing header", "value")
    |> Http.jsonBody(encode { user = "spaceman" })) == {
      withCredentials = false,
      body = `"{\"user\":\"spaceman\"}"`,
      method = "GET",
      headers =
        [
          {
            key = "existing header",
            value = "value"
          },
          {
            key = "Content-Type",
            value = "application/json"
          }
        ],
      url = ""
    }
  }

  test "it does not override value of Content-Type header if already set" {
    (Http.empty()
    |> Http.header("Content-Type", "text/plain")
    |> Http.jsonBody(encode { user = "spaceman" })) == {
      withCredentials = false,
      body = `"{\"user\":\"spaceman\"}"`,
      method = "GET",
      headers =
        [
          {
            key = "Content-Type",
            value = "text/plain"
          }
        ],
      url = ""
    }
  }
}

suite "Http.method" {
  test "it sets the method of a request" {
    (Http.empty()
    |> Http.method("BLAH")) == {
      withCredentials = false,
      method = "BLAH",
      body = `null`,
      headers = [],
      url = ""
    }
  }
}

suite "Http.withCredentials" {
  test "it sets the withCredentials of a request" {
    (Http.empty()
    |> Http.withCredentials(true)) == {
      withCredentials = true,
      method = "GET",
      body = `null`,
      headers = [],
      url = ""
    }
  }
}

suite "Http.url" {
  test "it sets the url of a request" {
    (Http.empty()
    |> Http.url("WTF")) == {
      withCredentials = false,
      method = "GET",
      body = `null`,
      headers = [],
      url = "WTF"
    }
  }
}

suite "Http.header" {
  test "adds a header to a request" {
    (Http.empty()
    |> Http.header("A", "B")
    |> Http.header("X", "Y")) == {
      headers =
        [
          {
            key = "A",
            value = "B"
          },
          {
            key = "X",
            value = "Y"
          }
        ],
      withCredentials = false,
      method = "GET",
      body = `null`,
      url = ""
    }
  }

  test "it overwrites header value if key already exists" {
    (Http.empty()
    |> Http.header("A", "B")
    |> Http.header("X", "Y")
    |> Http.header("A", "C")) == {
      headers =
        [
          {
            key = "X",
            value = "Y"
          },
          {
            key = "A",
            value = "C"
          }
        ],
      withCredentials = false,
      method = "GET",
      body = `null`,
      url = ""
    }
  }
}

suite "Http.hasHeader" {
  test "finds header in the request" {
    (Http.empty()
    |> Http.header("A", "B")
    |> Http.hasHeader("A")) == true
  }

  test "fails to find header in the request" {
    (Http.empty()
    |> Http.header("A", "B")
    |> Http.hasHeader("C")) == false
  }

  test "finds header in the request case-insensitively" {
    (Http.empty()
    |> Http.header("A", "B")
    |> Http.hasHeader("a")) == true
  }
}

suite "Http.sendWithId" {
  test "sends the request with the given ID" {
    try {
      response =
        Http.get("/blah")
        |> Http.sendWithId("A")

      `#{Http.requests()}["A"] != undefined`
    }
  }
}

component Test.Http {
  property shouldError : Bool = false
  property method : String = "GET"
  property timeout : Bool = false
  property url : String = "/blah"
  property abort : Bool = false

  state errorMessage : String = ""
  state status : Number = 0
  state body : String = ""

  fun wrap (
    method : Function(Promise(a, b), Void),
    input : Promise(a, b)
  ) : Promise(a, b) {
    `#{method}(#{input})`
  }

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      response =
        Http.empty()
        |> Http.url(url)
        |> Http.method(method)
        |> Http.sendWithId("test")
        |> wrap(
          `
          (async (promise) => {
            let _requests = #{Http.requests()}

            if (#{shouldError}) {
              _requests["test"].dispatchEvent(new CustomEvent("error"))
            } else if (#{timeout}) {
              _requests["test"].dispatchEvent(new CustomEvent("timeout"))
            } else if (#{abort}) {
              _requests["test"].abort()
            }

            const result = await promise
            return result
          })
          `)

      next { status = response.status }
    } catch Http.ErrorResponse => error {
      case (error.type) {
        Http.Error::NetworkError =>
          next
            {
              errorMessage = "network-error",
              status = error.status
            }

        Http.Error::BadUrl =>
          next
            {
              errorMessage = "bad-url",
              status = error.status
            }

        Http.Error::Timeout =>
          next
            {
              errorMessage = "timeout",
              status = error.status
            }

        Http.Error::Aborted =>
          next
            {
              errorMessage = "aborted",
              status = error.status
            }
      }
    }
  }

  fun render : Html {
    <div>
      <error>
        <{ errorMessage }>
      </error>

      <content>
        <{ body }>
      </content>

      <status>
        <{ Number.toString(status) }>
      </status>
    </div>
  }
}

suite "Successful request" {
  test "it loads" {
    with Test.Context {
      with Test.Html {
        <Test.Http/>
        |> start()
        |> timeout(50)
        |> assertTextOf("error", "")
        |> assertTextOf("status", "200")
      }
    }
  }
}

suite "Http.Error" {
  test "BadUrl" {
    with Test.Context {
      with Test.Html {
        <Test.Http url="http://::?/"/>
        |> start()
        |> timeout(50)
        |> assertTextOf("error", "bad-url")
        |> assertTextOf("status", "0")
      }
    }
  }

  test "NetWorkError" {
    with Test.Context {
      with Test.Html {
        <Test.Http shouldError={true}/>
        |> start()
        |> assertTextOf("error", "network-error")
        |> assertTextOf("status", "0")
      }
    }
  }

  test "Timeout" {
    with Test.Context {
      with Test.Html {
        <Test.Http timeout={true}/>
        |> start()
        |> timeout(50)
        |> assertTextOf("error", "timeout")
        |> assertTextOf("status", "0")
      }
    }
  }

  test "Aborted" {
    with Test.Context {
      with Test.Html {
        <Test.Http abort={true}/>
        |> start()
        |> timeout(50)
        |> assertTextOf("error", "aborted")
        |> assertTextOf("status", "0")
      }
    }
  }
}
