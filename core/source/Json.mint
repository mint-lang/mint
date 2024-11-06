/*
This module provides functions for parsing and generating [JSON] documents.

[JSON]: https://en.wikipedia.org/w/index.php?title=JSON
*/
module Json {
  /*
  Parses a string into an `Object`, returns `Result.Err` if the parsing
  failed.

    Result.isOk(Json.parse("{}"))
    Result.isError(Json.parse("{"))
  */
  fun parse (input : String) : Result(String, Object) {
    `
    (() => {
      try {
        return #{Result.Ok(`JSON.parse(#{input})`)}
      } catch (error) {
        return #{Result.Err(`error.message`)}
      }
    })()
    `
  }

  /*
  Generates a JSON string from an `Object`, in a human readable format (with
  line breaks and indentation).

    Json.prettyStringify(encode { a: "Hello" }, 2) == <<~JSON
      {
        "a": "Hello"
      }"
    JSON
  */
  fun prettyStringify (value : Object, spaces : Number) {
    `JSON.stringify(#{value}, null, #{spaces})` as String
  }

  /*
  Generates a JSON string from an `Object`.

    Json.stringify(encode { a: "Hello" }) == "{ \"a\": \"Hello\" }"
  */
  fun stringify (input : Object) : String {
    `JSON.stringify(#{input})`
  }
}
