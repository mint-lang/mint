suite "Result.withDefault" {
  test "returns default value if the result in an error" {
    Result.withDefault("Test", Result.error("")) == "Test"
  }

  test "returns the value of the result if it's ok" {
    Result.withDefault("Test", Result.ok("OK")) == "OK"
  }
}

suite "Result.withError" {
  test "returns given value if the result ok" {
    Result.withError("Test", Result.ok("")) == "Test"
  }

  test "returns the value of the result if it's an error" {
    Result.withError("Test", Result.error("OK")) == "OK"
  }
}

suite "Result.ok" {
  test "returns an ok result" {
    Result.ok("A")
    |> Result.isOk()
  }
}

suite "Result.error" {
  test "returns an error result" {
    Result.error("blah")
    |> Result.isError()
  }
}

suite "Result.map" {
  test "maps over the ok value of the result" {
    (Result.ok("TEST")
    |> Result.map(String.toLowerCase)
    |> Result.withDefault("")) == "test"
  }
}

suite "Result.flatMap" {
  test "flat maps over the Ok Result" {
    (Result.ok("TEST")
    |> Result.flatMap(
      (r : String) : Result(error, String) { Result.ok(r) })
    |> Result.map(String.toLowerCase)
    |> Result.withDefault("")) == "test"
  }

  test "flat maps over the Err Result" {
    Result.ok("TEST")
    |> Result.flatMap(
      (r : String) : Result(error, String) { Result.error(r) })
    |> Result.isError()
  }
}

suite "Result.join" {
  test "flattens nested Results" {
    (Result.ok(Result.ok("TEST"))
    |> Result.join()
    |> Result.map(String.toLowerCase)
    |> Result.withDefault("")) == "test"
  }

  test "flattens nested Results when Err" {
    Result.ok(Result.error("Error"))
    |> Result.join()
    |> Result.isError()
  }
}

suite "Result.mapError" {
  test "maps over the ok value of the result" {
    (Result.error("TEST")
    |> Result.mapError(String.toLowerCase)
    |> Result.withError("")) == "test"
  }
}

suite "Result.isOk" {
  test "returns true for an ok" {
    Result.ok("")
    |> Result.isOk()
  }

  test "returns false for an error" {
    (Result.error("blah")
    |> Result.isOk()) == false
  }
}

suite "Result.isError" {
  test "returns true for an error" {
    Result.error("")
    |> Result.isError()
  }

  test "returns false for an ok" {
    (Result.ok("blah")
    |> Result.isError()) == false
  }
}

suite "Result.toMaybe" {
  test "returns just for an ok" {
    (Result.ok("blah")
    |> Result.toMaybe()) == Maybe.just("blah")
  }

  test "returns nothing for an error" {
    (Result.error("blah")
    |> Result.toMaybe()) == Maybe.nothing()
  }
}
