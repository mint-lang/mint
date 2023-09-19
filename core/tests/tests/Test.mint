suite "Test (Async)" {
  test "await Bool" {
    await true
  }

  test "await Test.Context(Bool)" {
    await Test.Context.of(true)
  }
}

suite "Test (Function)" {
  fun test : String {
    ""
  }

  test "function" {
    test() == ""
  }
}
