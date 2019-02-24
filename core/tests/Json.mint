suite "Json.parse" {
  test "returns Nothing if there is an error" {
    Json.parse("a")
    |> Maybe.isNothing()
  }

  test "returns an object if if succeeds" {
    (Json.parse("\"asd\"")
    |> Maybe.withDefault(`"Hello"`)
    |> Object.Decode.string()
    |> Result.withDefault("Hello")) == "asd"
  }
}

suite "Json.stringify" {
  test "stringifies an object" {
    Json.stringify(Object.Encode.string("asd")) == "\"asd\""
  }
}
