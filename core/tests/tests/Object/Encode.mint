suite "Object.Encode.string" {
  test "using keyword" {
    (encode "Test") == `"Test"`
  }

  test "encodes a string to object" {
    Object.Encode.string("Test") == `"Test"`
  }
}

suite "Object.Encode.boolean" {
  test "using keyword" {
    (encode true) == `true`
  }

  test "encodes a boolean to object" {
    Object.Encode.boolean(true) == `true`
  }
}

suite "Object.Encode.number" {
  test "using keyword" {
    (encode 10) == `10`
  }

  test "encodes a number to object" {
    Object.Encode.number(10) == `10`
  }
}

suite "Object.Encode.time" {
  test "using keyword" {
    (encode Time.utcDate(2018, 1, 1)) == `"2018-01-01T00:00:00.000Z"`
  }

  test "encodes a date to object" {
    Object.Encode.time(Time.utcDate(2018, 1, 1)) == `"2018-01-01T00:00:00.000Z"`
  }
}

suite "Object.Encode.field" {
  test "encodes a key and value to a field" {
    let object =
      Object.Encode.field("test", `"a"`)

    `#{object}.name == "test" && #{object}.value == "a"`
  }
}

suite "Object.Encode.object" {
  test "encodes an array of fields to an object" {
    let encodedField =
      Object.Encode.field("test", `"a"`)

    let encodedObject =
      Object.Encode.object([encodedField])

    `#{encodedObject}.test == "a"`
  }
}

suite "Object.Encode.array" {
  test "using keyword" {
    (encode [10]) == `[10]`
  }

  test "encodes an array of object into an object" {
    Object.Encode.array([`"a"`]) == `["a"]`
  }
}
