suite "Array destructuring" {
  test "spread" {
    case ["a", "b"] {
      [...b] => true
    }
  }

  test "one item" {
    case ["a"] {
      [a] => true
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
