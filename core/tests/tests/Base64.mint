suite "Base64.decode" {
  test "it decodes" {
    Base64.decode("dGVzdA==") == Result.Ok("test")
  }

  test "it doesn't decode" {
    Result.isError(Base64.decode("dGVzdA="))
  }
}

suite "Base64.encode" {
  test "it encodes" {
    Base64.encode("test") == "dGVzdA=="
  }
}
