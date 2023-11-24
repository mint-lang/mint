/* A module for parsing and stringifying JSON format. */
module Json {
  /*
  Parses a string into an `Object`, returns `Maybe.nothing()`
  if the parsing failed.

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
  Pretty stringyfies the given object.

     Json.prettyStringify(`{ a: "Hello" }`, 2) == "{\n  \"a\": \"Hello\"\n}"
  */
  fun prettyStringify (value : Object, spaces : Number) {
    `JSON.stringify(#{value}, null, #{spaces})` as String
  }

  /*
  Stringifies an `Object` into JSON string.

    Json.stringify(`{ a: "Hello" }`) == "{ \"a\": \"Hello\" }"
  */
  fun stringify (input : Object) : String {
    `JSON.stringify(#{input})`
  }
}
