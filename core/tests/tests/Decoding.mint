suite "Decode" {
  test "it decodes tuples" {
    try {
      decoded =
        decode (encode {"A", 0, true}) as Tuple(String, Number, Bool)

      {"A", 0, true} == decoded
    } catch {
      false
    }
  }
}
