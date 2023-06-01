suite "Number.isOdd" {
  test "returns false for 0" {
    Number.isOdd(0) == false
  }

  test "returns false for odd numbers" {
    Number.isOdd(2) == false
  }

  test "returns true for even numbers" {
    Number.isOdd(1)
  }
}

suite "Number.isEven" {
  test "returns true for 0" {
    Number.isEven(0)
  }

  test "returns true for odd numbers" {
    Number.isEven(2)
  }

  test "returns false for even numbers" {
    Number.isEven(1) == false
  }
}

suite "Number.isNaN" {
  test "returns true for NaN" {
    Number.isNaN(`NaN`)
  }

  test "returns false for a number" {
    Number.isNaN(0) == false
  }
}

suite "Number.toString" {
  test "returns string representation of a number" {
    Number.toString(100) == "100"
  }
}

suite "Number.toFixed" {
  test "returns string truncated to decimal places" {
    Number.toFixed(100.12345, 2) == "100.12"
  }
}

suite "Number.fromString" {
  test "returns nothing if it cannot convert" {
    Number.fromString("asd")
    |> Maybe.isNothing()
  }

  test "returns nothing if the string ends with characters" {
    Number.fromString("1a")
    |> Maybe.isNothing()
  }

  test "returns nothing if the string is empty" {
    Number.fromString("")
    |> Maybe.isNothing()
  }

  test "returns nothing if the string is blank" {
    Number.fromString("   ")
    |> Maybe.isNothing()
  }

  test "returns just(Number) if it converted successfully" {
    Number.fromString("100")
    |> Maybe.isJust()
  }

  test "returns correct number if it converted successfully" {
    (Number.fromString("100")
    |> Maybe.withDefault(0)) == 100
  }

  test "parses binary numbers" {
    (Number.fromString("0b10")
    |> Maybe.withDefault(0)) == 2
  }

  test "parses octal numbers" {
    (Number.fromString("0o10")
    |> Maybe.withDefault(0)) == 8
  }

  test "parses hexadecimal numbers" {
    (Number.fromString("0x10")
    |> Maybe.withDefault(0)) == 16
  }

  test "parses Infinity" {
    (Number.fromString("Infinity")
    |> Maybe.withDefault(0)
    |> Number.toString()) == "Infinity"
  }

  test "parses -Infinity" {
    (Number.fromString("-Infinity")
    |> Maybe.withDefault(0)
    |> Number.toString()) == "-Infinity"
  }
}

suite "Number.format" {
  test "formats the number" {
    Number.format(1034150, "$ ") == "$ 1,034,150"
  }
}
