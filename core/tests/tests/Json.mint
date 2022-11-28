suite "Json.parse" {
  test "returns Nothing if there is an error" {
    Json.parse("a")
    |> Result.isError()
  }

  test "returns an object if if succeeds" {
    (Json.parse("\"asd\"")
    |> Result.withDefault(`"Hello"`)
    |> Object.Decode.string()
    |> Result.withDefault("Hello")) == "asd"
  }
}

suite "Json.stringify" {
  test "stringifies an object" {
    Json.stringify(Object.Encode.string("asd")) == "\"asd\""
  }
}

suite "Json.prettyStringify" {
  test "stringifies an object" {
    Json.prettyStringify(`{ a: "Hello" }`, 2) == "{\n  \"a\": \"Hello\"\n}"
  }
}
