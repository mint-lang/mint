suite "Uid.generate" {
  test "it generates a unique id" {
    Uid.generate() != Uid.generate()
  }
}
