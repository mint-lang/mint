suite "Array destructuring" {
  test "spread" {
    case ["a", "b"] {
      [..._] => true
    }
  }

  test "one item" {
    case ["a"] {
      [_] => true
      => false
    }
  }

  test "empty" {
    case [] {
      [] => true
      => false
    }
  }
}
