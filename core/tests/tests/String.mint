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

suite "String.fromArray" {
  test "joins an array of strings together" {
    String.fromArray(["a", "b", "c"]) == "abc"
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

suite "String.isNotEmpty" {
  test "it returns true for non-empty string" {
    String.isNotEmpty("a") == true
  }

  test "it returns false for fully empty string" {
    String.isNotEmpty("") == false
  }

  test "it returns false for empty string (whitespace)" {
    String.isNotEmpty(" ") == true
  }
}

suite "String.isBlank" {
  test "returns true if the string is empty" {
    String.isBlank("")
  }

  test "returns false if the string contains whitespace" {
    String.isBlank(" \n\r") == true
  }

  test "returns false if the string contains anything" {
    String.isBlank("asd") == false
  }
}

suite "String.isNotBlank" {
  test "it returns true for non-empty string" {
    String.isNotBlank("a") == true
  }

  test "it returns false for fully empty string" {
    String.isNotBlank("") == false
  }

  test "it returns false for empty string (whitespace)" {
    String.isNotBlank(" \n\r") == false
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

suite "String.toArray" {
  test "converts a string to an array of strings" {
    String.toArray("abcde") == ["a", "b", "c", "d", "e"]
  }
}

suite "String.capitalize" {
  test "returns capitalized string" {
    String.capitalize("hello there mate!") == "Hello There Mate!"
  }
}

suite "String.isAnagram" {
  test "returns false for non anagrams" {
    String.isAnagram("asd", "blah") == false
  }

  test "returns true for anagrams" {
    String.isAnagram("rail safety", "fairy tales") == true
  }
}

suite "String.rchop" {
  test "it removes strings from the end of the string" {
    String.rchop("!", "Hello!!!") == "Hello"
  }
}

suite "String.lchop" {
  test "it removes strings from the start of the string" {
    String.lchop("!", "!!!Hello") == "Hello"
  }
}

suite "String.replace" {
  test "it replaces the given pattern with replacement" {
    String.replace("a", "0", "aaaa") == "0000"
  }
}

suite "String.trim" {
  test "it removes whitespace from the string" {
    String.trim("   \n\n\r\r   ") == ""
  }
}

suite "String.dropLeft" {
  test "it removes the given number of characters" {
    String.dropLeft(1, "abc") == "bc" &&
      String.dropLeft(2, "abc") == "c"
  }
}

suite "String.paramterize" {
  test "it parameterizes the given string" {
    String.parameterize("HELLO THERE!!!") == "hello-there"
  }
}
