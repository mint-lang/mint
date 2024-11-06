suite "String.capitalize" {
  test "returns capitalized string" {
    String.capitalize("The quick brown fox jumps.") == "The Quick Brown Fox Jumps."
  }
}

suite "String.charAt" {
  test "returns the character at the given index" {
    String.charAt("The quick brown fox jumps over the lazy dog.", 4) == "q"
  }

  test "returns empty string if negative" {
    String.charAt("Hello", -1) == ""
  }

  test "returns empty string if index is bigger then length" {
    String.charAt("Hello", 100) == ""
  }
}

suite "String.charCodeAt" {
  test "returns just the character code at the given index" {
    String.charCodeAt("Hello", 2) == Maybe.Just(108)
  }

  test "returns nothing if negative" {
    String.charCodeAt("Hello", -1) == Maybe.Nothing
  }

  test "returns nothing if index is bigger then length" {
    String.charCodeAt("Hello", 100) == Maybe.Nothing
  }
}

suite "String.chopEnd" {
  test "it removes strings from the end of the string" {
    String.chopEnd("The quick brown fox jumps.", ".") == "The quick brown fox jumps"
  }
}

suite "String.chopStart" {
  test "it removes strings from the start of the string" {
    String.chopStart("The quick brown fox jumps.", "T") == "he quick brown fox jumps."
  }
}

suite "String.codePointAt" {
  test "returns just the character code at the given index" {
    String.codePointAt("☃★♲", 1) == Maybe.Just(9733)
  }

  test "returns nothing if negative" {
    String.codePointAt("☃★♲", -1) == Maybe.Nothing
  }

  test "returns nothing if index is bigger then length" {
    String.codePointAt("☃★♲", 100) == Maybe.Nothing
  }
}

suite "String.concat" {
  test "joins an array of strings together" {
    String.concat(["The", "quick", "brown", "fox", "jumps."]) == "Thequickbrownfoxjumps."
  }
}

suite "String.contains" {
  test "returns true if string contains the pattern" {
    String.contains("The quick brown fox jumps over the lazy dog.", "fox") == true
  }

  test "returns false if string doesnot contain the pattern" {
    String.contains("The quick brown fox jumps over the lazy dog.", "bear") == false
  }
}

suite "String.dropEnd" {
  test "it removes the given number of characters" {
    String.dropEnd("The quick brown fox jumps.", 1) == "The quick brown fox jumps" && String.dropEnd(
      "The quick brown fox jumps.", 2) == "The quick brown fox jump"
  }
}

suite "String.dropStart" {
  test "it removes the given number of characters" {
    String.dropStart("The quick brown fox jumps.", 1) == "he quick brown fox jumps." && String.dropStart(
      "The quick brown fox jumps.", 2) == "e quick brown fox jumps."
  }
}

suite "String.endsWith" {
  test "it returns true if the given string ends with the given string" {
    String.endsWith("The quick brown fox jumps.", "jumps.") == true
  }
}

suite "String.fromCharCode" {
  test "it returns a string from a char code" {
    String.fromCharCode(65) == "A"
  }
}

suite "String.fromCodePoint" {
  test "it returns a string from a char code" {
    String.fromCodePoint(9731) == "☃"
  }
}

suite "String.indent" {
  test "it indents the given string by the given number of spaces" {
    String.indent("The quick brown fox jumps.", 2) == "  The quick brown fox jumps."
  }

  test "it indents the given string by the given options" {
    String.indent("The quick brown fox jumps.", 2, " ", false) == "  The quick brown fox jumps."
  }

  test "it skips empty lines" {
    String.indent("The quick brown fox jumps.\n\nHello", 2, " ", false) == "  The quick brown fox jumps.\n\n  Hello"
  }

  test "it does not skip empty lines" {
    String.indent("The quick brown fox jumps.\n\nHello", 2, " ", true) == "  The quick brown fox jumps.\n  \n  Hello"
  }
}

suite "String.indexOf" {
  test "it returns the index of the search param" {
    String.indexOf("The quick brown fox jumps over the lazy dog.", "whale") == Maybe.Nothing && String.indexOf(
      "The quick brown fox jumps over the lazy dog.", "fox") == Maybe.Just(16)
  }
}

suite "String.isAnagram" {
  test "returns false for non anagrams" {
    String.isAnagram("The", "quick") == false
  }

  test "returns true for anagrams" {
    String.isAnagram("rail safety", "fairy tales") == true
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
    String.isBlank("The quick brown fox jumps.") == false
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
    String.isEmpty("The quick brown fox jumps.") == false
  }
}

suite "String.isNotBlank" {
  test "it returns true for non-empty string" {
    String.isNotBlank("The quick brown fox jumps.") == true
  }

  test "it returns false for fully empty string" {
    String.isNotBlank("") == false
  }

  test "it returns false for empty string (whitespace)" {
    String.isNotBlank(" \n\r") == false
  }
}

suite "String.isNotEmpty" {
  test "it returns true for non-empty string" {
    String.isNotEmpty("The quick brown fox jumps.") == true
  }

  test "it returns false for fully empty string" {
    String.isNotEmpty("") == false
  }

  test "it returns false for empty string (whitespace)" {
    String.isNotEmpty(" ") == true
  }
}

suite "String.join" {
  test "joins an array of strings with the given separator" {
    String.join(["The", "quick", "brown", "fox", "jumps."], " ") == "The quick brown fox jumps."
  }
}

suite "String.lastIndexOf" {
  test "it returns the last index of the search param" {
    String.lastIndexOf("The quick brown fox jumps over the lazy dog.", "whale") == Maybe.Nothing && String.lastIndexOf(
      "The quick brown fox jumps over the lazy dog.", "the") == Maybe.Just(31)
  }
}

suite "String.normalize" {
  test "it normalizes the string" {
    String.normalize("\u0041\u006d\u0065\u0301\u006c\u0069\u0065") == "\u0041\u006d\u00e9\u006c\u0069\u0065"
  }
}

suite "String.padEnd" {
  test "it pads the string from the end" {
    String.padEnd("5", "0", 2) == "50"
  }
}

suite "String.padStart" {
  test "it pads the string from the start" {
    String.padStart("5", "0", 2) == "05"
  }
}

suite "String.parametrize" {
  test "it converts title case to dash case" {
    String.parameterize("The quick brown fox jumps.") == "the-quick-brown-fox-jumps"
  }
}

suite "String.repeat" {
  test "repeats a string the given number of times" {
    String.repeat("The", 3) == "TheTheThe"
  }
}

suite "String.replace" {
  test "it replaces the given pattern with replacement" {
    String.replace("The quick brown fox jumps.", "fox", "bear") == "The quick brown bear jumps."
  }
}

suite "String.replaceAll" {
  test "it replaces the given pattern with replacement" {
    String.replaceAll("The quick brown fox jumps over the lazy fox.", "fox",
      "bear") == "The quick brown bear jumps over the lazy bear."
  }
}

suite "String.reverse" {
  test "reverses a string" {
    String.reverse("The quick brown fox jumps.") == ".spmuj xof nworb kciuq ehT"
  }
}

suite "String.size" {
  test "returns the size of the string" {
    String.size("The quick brown fox jumps.") == 26
  }

  test "returns 0 for empty string" {
    String.size("") == 0
  }
}

suite "String.split" {
  test "splits the string with a separator" {
    String.split("The quick brown fox jumps.", " ") == [
      "The",
      "quick",
      "brown",
      "fox",
      "jumps."
    ]
  }
}

suite "String.startsWith" {
  test "it returns true if the given string ends with the given string" {
    String.startsWith("The quick brown fox jumps.", "The") == true
  }
}

suite "String.takeEnd" {
  test "it takes the given number of characters from the end" {
    String.takeEnd("The quick brown fox jumps.", 2) == "s."
  }
}

suite "String.takeStart" {
  test "it takes the given number of characters from the end" {
    String.takeStart("The quick brown fox jumps.", 2) == "Th"
  }
}

suite "String.toArray" {
  test "converts a string to an array of strings" {
    String.toArray("Hello") == ["H", "e", "l", "l", "o"]
  }
}

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

suite "String.trim" {
  test "it removes whitespace from the string" {
    String.trim("  The quick brown fox jumps.  ") == "The quick brown fox jumps."
  }
}

suite "String.withDefault" {
  test "it returns the default value for empty string" {
    String.withDefault("", "The quick brown fox jumps.") == "The quick brown fox jumps."
  }

  test "it returns the string for non-empty string" {
    String.withDefault("Hello", "The quick brown fox jumps.") == "Hello"
  }
}

suite "String.wrap" {
  test "it wraps the string with the given characters" {
    String.wrap("The quick brown fox jumps.", "{", "}") == "{The quick brown fox jumps.}"
  }
}
