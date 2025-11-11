suite "Object.Decode.field" {
  test "it returns an error if the input is null" {
    Object.Decode.field(`null`, "a", Object.Decode.string)
    |> Result.isError()
  }

  test "it returns an error if the input is undefined" {
    Object.Decode.field(`undefined`, "a", Object.Decode.string)
    |> Result.isError()
  }

  test "it returns an error if the input is an array" {
    Object.Decode.field(`[]`, "a", Object.Decode.string)
    |> Result.isError()
  }

  test "it returns an error if the input does not have the key" {
    Object.Decode.field(`{}`, "a", Object.Decode.string)
    |> Result.isError()
  }

  test "it returns an error if the it could not decode the value" {
    Object.Decode.field(`{a: 0}`, "a", Object.Decode.string)
    |> Result.isError()
  }
}

suite "Object.Decode.string" {
  test "using decode keyword" {
    decode (`""`) as String
    |> Result.isOk()
  }

  test "it returns an error if it's not a string" {
    Object.Decode.string(`0`)
    |> Result.isError()
  }

  test "it returns the value" {
    (Object.Decode.string(`"asd"`)
    |> Result.withDefault("")) == "asd"
  }
}

suite "Object.Decode.time" {
  test "using decode keyword" {
    decode (`""`) as Time
    |> Result.isError()
  }

  test "it returns an error if it's not a valid date" {
    Object.Decode.time(`"asd"`)
    |> Result.isError()
  }

  test "it returns the value" {
    (Object.Decode.time(`"2018-01-01"`)
    |> Result.withDefault(Time.now())) == Time.utcDate(2018, 1, 1)
  }
}

suite "Object.Decode.number" {
  test "using decode keyword" {
    decode (`""`) as Number
    |> Result.isError()
  }

  test "it returns an error if it's not a valid number" {
    Object.Decode.number(`"asd"`)
    |> Result.isError()
  }

  test "it returns the value" {
    (Object.Decode.number(`300`)
    |> Result.withDefault(0)) == 300
  }
}

suite "Object.Decode.boolean" {
  test "using decode keyword" {
    decode (`""`) as Bool
    |> Result.isError()
  }

  test "it returns an error if it's not a valid boolean" {
    Object.Decode.boolean(`"asd"`)
    |> Result.isError()
  }

  test "it returns the value" {
    Object.Decode.boolean(`true`)
    |> Result.withDefault(false)
  }
}

suite "Object.Decode.array" {
  test "using decode keyword" {
    decode (`""`) as Array(String)
    |> Result.isError()
  }

  test "it returns an error if it's not a valid array" {
    Object.Decode.array(`"asd"`, Object.Decode.string)
    |> Result.isError()
  }

  test "it propagates the error if there is any" {
    Object.Decode.array(`[0]`, Object.Decode.string)
    |> Result.isError()
  }

  test "it returns the value" {
    (Object.Decode.array(`["asd"]`, Object.Decode.string)
    |> Result.withDefault([])) == ["asd"]
  }
}

suite "Object.Decode.maybe" {
  test "using decode keyword" {
    decode (`""`) as Maybe(String)
    |> Result.isOk()
  }

  test "it returns an error if it's not a valid string" {
    Object.Decode.maybe(`0`, Object.Decode.string)
    |> Result.isError()
  }

  test "it returns nothing for null" {
    (Object.Decode.maybe(`null`, Object.Decode.string)
    |> Result.withDefault(Maybe.just("A"))) == Maybe.nothing()
  }

  test "it returns nothing for undefined" {
    (Object.Decode.maybe(`undefined`, Object.Decode.string)
    |> Result.withDefault(Maybe.just("A"))) == Maybe.nothing()
  }

  test "it returns value if ok" {
    (Object.Decode.maybe(`"A"`, Object.Decode.string)
    |> Result.withDefault(Maybe.nothing())) == Maybe.just("A")
  }
}
