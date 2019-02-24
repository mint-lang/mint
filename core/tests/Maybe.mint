suite "Comparing maybes" {
  test "same maybes equals" {
    Maybe.just("a") == Maybe.just("a")
  }

  test "different maybes not equals" {
    Maybe.just("a") != Maybe.just("b")
  }
}

suite "Maybe.nothing" {
  test "returns nothing" {
    Maybe.nothing()
    |> Maybe.isNothing()
  }
}

suite "Maybe.just" {
  test "returns a just" {
    Maybe.just("")
    |> Maybe.isJust()
  }
}

suite "Maybe.isJust" {
  test "returns true for a just" {
    Maybe.just("")
    |> Maybe.isJust()
  }

  test "returns false for nothing" {
    (Maybe.nothing()
    |> Maybe.isJust()) == false
  }
}

suite "Maybe.isNothing" {
  test "returns true for a nothing" {
    Maybe.nothing()
    |> Maybe.isNothing()
  }

  test "returns false for nothing" {
    (Maybe.just("a")
    |> Maybe.isNothing()) == false
  }
}

suite "Maybe.map" {
  test "maps the value of a just" {
    (Maybe.just("TEST")
    |> Maybe.map(String.toLowerCase)
    |> Maybe.withDefault("")) == "test"
  }
}

suite "Maybe.withDefault" {
  test "returns the value of a just" {
    (Maybe.just("TEST")
    |> Maybe.withDefault("")) == "TEST"
  }

  test "returns the given value for nothing" {
    (Maybe.nothing()
    |> Maybe.withDefault("TEST")) == "TEST"
  }
}

suite "Maybe.toResult" {
  test "returns the error for nothing" {
    Maybe.nothing()
    |> Maybe.toResult("Error")
    |> Result.isError()
  }

  test "returns the ok for just" {
    Maybe.just("A")
    |> Maybe.toResult("")
    |> Result.isOk()
  }

  test "sets the correct value for an ok" {
    (Maybe.just("A")
    |> Maybe.toResult("")
    |> Result.withDefault("")) == "A"
  }
}

suite "Maybe.flatten" {
  test "returns a nested just" {
    (Maybe.just("A")
    |> Maybe.just()
    |> Maybe.flatten()) == Maybe.just("A")
  }

  test "returns nested nothing" {
    (Maybe.nothing()
    |> Maybe.just()
    |> Maybe.flatten()) == Maybe.nothing()
  }
}

suite "Maybe.oneOf" {
  test "returns the first just" {
    ([
      Maybe.nothing(),
      Maybe.just("A")
    ]
    |> Maybe.oneOf()) == Maybe.just("A")
  }

  test "returns nested nothing" {
    ([
      Maybe.nothing(),
      Maybe.nothing()
    ]
    |> Maybe.oneOf()) == Maybe.nothing()
  }
}
