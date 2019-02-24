suite "Object.Encode.string" {
  test "encodes a string to object" {
    Object.Encode.string("Test") == `"Test"`
  }
}

suite "Object.Encode.boolean" {
  test "encodes a boolean to object" {
    Object.Encode.boolean(true) == `true`
  }
}

suite "Object.Encode.number" {
  test "encodes a boolean to object" {
    Object.Encode.number(10) == `10`
  }
}

suite "Object.Encode.time" {
  test "encodes a date to object" {
    Object.Encode.time(Time.from(2018, 1, 1)) == `"2018-01-01T00:00:00.000Z"`
  }
}

suite "Object.Encode.field" {
  test "encodes a key and vlaue to a field" {
    try {
      object =
        Object.Encode.field("test", `"a"`)

      `object.name == "test" && object.value == "a"`
    }
  }
}

suite "Object.Encode.object" {
  test "encodes an array of fields to an object" {
    with Object.Encode {
      try {
        encodedField =
          field("test", `"a"`)

        encodedObject =
          object([encodedField])

        `encodedObject.test == "a"`
      }
    }
  }
}

suite "Object.Encode.array" {
  test "encodes an array of object into an object" {
    Object.Encode.array([`"a"`]) == `["a"]`
  }
}
