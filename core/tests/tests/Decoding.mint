suite "Decode" {
  test "it decodes tuples" {
    case decode (encode {"A", 0, true}) as Tuple(String, Number, Bool) {
      Result.Ok(decoded) => {"A", 0, true} == decoded
      Result.Err => false
    }
  }
}
