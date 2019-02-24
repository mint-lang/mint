suite "Bool.toString" {
  test "returns 'true' for true" {
    (Bool.toString(true)) == "true"
  }

  test "returns 'false' for false" {
    (Bool.toString(false)) == "false"
  }
}
