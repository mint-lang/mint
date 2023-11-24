suite "Console.Counter" {
  test "it works once on 'Default' label using tuple" {
    // "Default" label
    let {a, b} =
      Console.count()

    // reset "Default" label
    Console.countReset()

    b == 1
  }

  test "it works once on 'Default' label using get" {
    // "Default" label
    Console.count()

    let a =
      Console.Counter.get("Default")

    // reset "Default" label
    Console.countReset()

    a == 1
  }

  test "it works multiple times on 'Default' label using tuple" {
    // "Default" label
    for item of [1, 2, 3, 4] {
      Console.count()
    }

    let {a, b} =
      Console.count()

    // reset "Default" label
    Console.countReset()
    b == 5
  }

  test "it works multiple times on 'Default' label" {
    // "Default" label
    for item of [1, 2, 3, 4, 5] {
      Console.count()
    }

    let a =
      Console.Counter.get("Default")

    // reset "Default" label
    Console.countReset()
    a == 5
  }

  test "it works multiple times on different values using tuple" {
    // "Default" label
    for item of [1, 2, 3] {
      Console.count()
    }

    // "Test" label
    for item of [1, 2] {
      Console.count("Test")
    }

    let {a, b} =
      Console.count()

    let {c, d} =
      Console.count("Test")

    // reset "Default" label
    Console.countReset()

    // reset "Test" label
    Console.countReset("Test")

    b == 4 && d == 3
  }

  test "it works multiple times on different values using get" {
    // "Default" label
    for item of [1, 2, 3, 4] {
      Console.count()
    }

    // "Test" label
    for item of [1, 2, 3] {
      Console.count("Test")
    }

    let a =
      Console.Counter.get("Default")

    let b =
      Console.Counter.get("Test")

    // reset "Default" label
    Console.countReset()

    // reset "Test" label
    Console.countReset("Test")

    a == 4 && b == 3
  }
}
