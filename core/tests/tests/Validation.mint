suite "Validation.isNotBlank" {
  test "it returns nothing if the string is not blank" {
    Validation.isNotBlank("a", {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string is blank" {
    Validation.isNotBlank("", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.isNumber" {
  test "it returns nothing if the string can be converted to number" {
    Validation.isNumber("0", {"key", "ERROR"}) == Maybe.Nothing &&
      Validation.isNumber("0.1", {"key", "ERROR"}) == Maybe.Nothing &&
      Validation.isNumber("0x10", {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string cannot be converted to number" {
    Validation.isNumber("", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }

  test "it returns the error if the string contains letters at the end" {
    Validation.isNumber("0a", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.isDigits" {
  test "it returns nothing if the string consists of one or more digits" {
    Validation.isDigits("123", {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string is empty" {
    Validation.isDigits("", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }

  test "it returns the error if the string contains non-digits" {
    Validation.isDigits("a", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"}) &&
      Validation.isDigits(" 1 ", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"}) &&
      Validation.isDigits("1.2", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.isSame" {
  test "it returns nothing if the two strings are the same" {
    Validation.isSame("a", "a", {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the two strings are not the same" {
    Validation.isSame("a", "b", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.hasExactNumberOfCharacters" {
  test "it returns nothing if the string have the exact number of characters" {
    Validation.hasExactNumberOfCharacters("a", 1, {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string does not have the exact number of characters" {
    Validation.hasExactNumberOfCharacters("a", 2, {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.hasMinimumNumberOfCharacters" {
  test "it returns nothing if the string has at last the given number of characters" {
    Validation.hasMinimumNumberOfCharacters("a", 1, {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string does not have at last the given number of characters" {
    Validation.hasMinimumNumberOfCharacters("a", 2, {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.isValidEmail" {
  test "it returns nothing if the string is a valid email" {
    Validation.isValidEmail("test@test.com", {"key", "ERROR"}) == Maybe.Nothing
  }

  test "it returns the error if the string does not have at last the given number of characters" {
    Validation.isValidEmail("invalid", {"key", "ERROR"}) == Maybe.Just({"key", "ERROR"})
  }
}

suite "Validation.merge" {
  test "it merges the results of each validation" {
    Validation.merge(
      [
        Validation.isNotBlank("", {"firstName", "Please enter the first name."}),
        Validation.isNotBlank("", {"message", "Please enter the message."})
      ]) == (Map.empty()
    |> Map.set("firstName", ["Please enter the first name."])
    |> Map.set("message", ["Please enter the message."]))
  }
}

suite "Validation.getFirstError" {
  test "it returns the first error for a given key" {
    (Map.empty()
    |> Map.set("key", ["ERROR1", "ERROR2"])
    |> Validation.getFirstError("key")) == Maybe.Just("ERROR1")
  }
}
