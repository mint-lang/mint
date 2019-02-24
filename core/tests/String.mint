suite "String.toLowerCase" {
  test "converts string to lowercase representation" {
    String.toLowerCase("HELLO") == "hello"
  }
}

suite "String.toUpperCase" {
  test "converts string to uppercase representation" {
    String.toUpperCase("hello") == "HELLO"
  }
}

suite "String.match" {
  test "returns true if string contains the pattern" {
    String.match("ab", "aabbccdd")
  }

  test "returns false if string doesnot contain the pattern" {
    String.match("xxs", "aabbccdd") == false
  }
}

suite "String.reverse" {
  test "reverses a string" {
    String.reverse("hello") == "olleh"
  }
}

suite "String.repeat" {
  test "repeats a string the given number of times" {
    String.repeat(5, "a") == "aaaaa"
  }
}

suite "String.join" {
  test "joins an array of strings with the given separator" {
    ([
      "a",
      "b",
      "c"
    ]
    |> String.join(",")) == "a,b,c"
  }
}

suite "String.concat" {
  test "joins an array of strings together" {
    ([
      "a",
      "b",
      "c"
    ]
    |> String.concat()) == "abc"
  }
}

suite "String.isEmpty" {
  test "returns true if the string is empty" {
    String.isEmpty("")
  }

  test "returns false if the string contains whitespace" {
    String.isEmpty(" ") == false
  }

  test "returns false if the string contains anything" {
    String.isEmpty("asd") == false
  }
}

suite "String.size" {
  test "returns the size of the string" {
    String.size("123456") == 6
  }

  test "returns 0 for empty string" {
    String.size("") == 0
  }
}

suite "String.split" {
  test "splits the string with a separator" {
    ("a,b,c,d,e"
    |> String.split(",")
    |> Array.size()) == 5
  }
}

suite "String.capitalize" {
  test "returns capitalized string" {
    String.capitalize("hello there mate!") == "Hello There Mate!"
  }
}

suite "String.isAnagram" {
  test "returns false for non anagrams" {
    String.isAnagarm("asd", "blah") == false
  }

  test "returns true for anagrams" {
    String.isAnagarm("rail safety", "fairy tales") == true
  }
}
