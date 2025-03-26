suite "Decode" {
  test "it decodes tuples" {
    let decoded =
      decode (encode {"A", 0, true}) as Tuple(String, Number, Bool)

    decoded == Result.Ok({"A", 0, true})
  }

  test "it decode simple variant" {
    let object =
      `{ type: "EncodeTestVariants.Variant2" }`

    decode object as EncodeTestVariants == Result.Ok(
      EncodeTestVariants.Variant2)
  }

  test "it decodes complex variant" {
    let object =
      `{ type: "EncodeTestVariants.Variant3", value: ["Joe", 42] }`

    decode object as EncodeTestVariants == Result.Ok(
      EncodeTestVariants.Variant3("Joe", 42))
  }

  test "it decodes record variant" {
    let object =
      `{ type: "EncodeTestVariants.Variant1", value: ["Joe", 42] }`

    decode object as EncodeTestVariants == Result.Ok(
      EncodeTestVariants.Variant1("Joe", 42))
  }

  test "roundtrip" {
    let variants =
      [
        EncodeTestVariants.Variant1(name: "Joe", age: 42),
        EncodeTestVariants.Variant3("Jane", 24),
        EncodeTestVariants.Variant2
      ]

    let roundtrip =
      decode (encode variants) as Array(EncodeTestVariants)

    Result.Ok(variants) == roundtrip
  }
}
