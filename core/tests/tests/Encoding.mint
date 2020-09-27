module EncodeTest {
  fun nothing : Maybe(String) {
    Maybe::Nothing
  }
}

record EncodeNestedTest {
  field : String
}

record EncodeTest {
  field : String using "mapped_field",
  nested : EncodeNestedTest
}

suite "Encode" {
  test "it encodes String as itself" {
    `#{encode "Hello"} === "Hello"`
  }

  test "it encodes Number as itself" {
    `#{encode 0} === 0`
  }

  test "it encodes Bool as itself" {
    `#{encode true} === true`
  }

  test "it encodes JavaScript object as itself" {
    `#{encode (`null` as Object)} === null`
  }

  test "it encodes Time as integer" {
    `typeof #{encode Time.now()} === "number"`
  }

  test "it encodes Maybe::Just as it's value" {
    `#{encode Maybe::Just("Hello")} === "Hello"`
  }

  test "it encodes Maybe::Nothing as null" {
    `#{encode EncodeTest.nothing()} === null`
  }

  test "it encodes Map(String, a) as object" {
    try {
      map =
        Map.empty()
        |> Map.set("key", "value")
        |> Map.set("key2", "value2")

      encoded =
        encode map

      `
      typeof #{encoded} == "object" &&
        #{encoded}.key === "value" &&
        #{encoded}.key2 === "value2"
      `
    }
  }

  test "it encodes Array(a) as array" {
    try {
      encoded =
        encode ["Hello"]

      `Array.isArray(#{encoded}) && #{encoded}[0] === "Hello"`
    }
  }

  test "it encodes a record (with nested fields)" {
    try {
      encoded =
        encode {
          field = "Mapped Field",
          nested = { field = "Field" }
        }

      `
      typeof #{encoded} == "object" &&
        #{encoded}.mapped_field === "Mapped Field" &&
        typeof #{encoded}.nested === "object" &&
        #{encoded}.nested.field === "Field"
      `
    }
  }
}
