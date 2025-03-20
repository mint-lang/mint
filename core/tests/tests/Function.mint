suite "captures" {
  fun add (a : Number, b : Number) : Number {
    a + b
  }

  test "normal" {
    add(1, _)(2) == 3
  }

  test "labelled" {
    add(b: 1, a: _)(2) == 3
  }
}
