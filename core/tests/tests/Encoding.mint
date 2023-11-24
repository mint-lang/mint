module EncodeTest {
  fun nothing : Maybe(String) {
    Maybe.Nothing
  }
}

type EncodeNestedTest {
  field : String
}

type EncodeTest {
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

  test "it encodes Time as string" {
    `typeof #{encode Time.now()} === "string"`
  }

  test "it encodes Maybe.Just as its value" {
    `#{encode Maybe.Just("Hello")} === "Hello"`
  }

  test "it encodes Maybe.Nothing as null" {
    `#{encode EncodeTest.nothing()} === null`
  }

  test "it encodes Map(String, a) as object" {
    let map =
      Map.empty()
      |> Map.set("key", "value")
      |> Map.set("key2", "value2")

    let encoded =
      encode map

    `
    typeof #{encoded} == "object" &&
      #{encoded}.key === "value" &&
      #{encoded}.key2 === "value2"
    `
  }

  test "it encodes Array(a) as array" {
    let encoded =
      encode ["Hello"]

    `Array.isArray(#{encoded}) && #{encoded}[0] === "Hello"`
  }

  test "it encodes Tuple as array" {
    let encoded =
      encode {"Hello", 0, true}

    `Array.isArray(#{encoded}) && #{encoded}[0] === "Hello"` && `Array.isArray(#{encoded}) && #{encoded}[1] === 0` && `Array.isArray(#{encoded}) && #{encoded}[2] === true`
  }

  test "it encodes a record (with nested fields)" {
    let encoded =
      encode {
        field: "Mapped Field",
        nested: { field: "Field" }
      }

    `
    typeof #{encoded} == "object" &&
      #{encoded}.mapped_field === "Mapped Field" &&
      typeof #{encoded}.nested === "object" &&
      #{encoded}.nested.field === "Field"
    `
  }
}
