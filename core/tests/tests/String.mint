suite "String.capitalize" {
  test "returns capitalized string" {
    String.capitalize("The quick brown fox jumps.") == "The Quick Brown Fox Jumps."
  }
}

suite "String.charAt" {
  test "returns the character at the given index" {
    String.charAt(4, "The quick brown fox jumps over the lazy dog.") == "q"
  }

  test "returns empty string if negative" {
    String.charAt(-1, "Hello") == ""
  }

  test "returns empty string if index is bigger then length" {
    String.charAt(100, "Hello") == ""
  }
}

suite "String.charCodeAt" {
  test "returns just the character code at the given index" {
    String.charCodeAt(2, "Hello") == Maybe::Just(108)
  }

  test "returns nothing if negative" {
    String.charCodeAt(-1, "Hello") == Maybe::Nothing
  }

  test "returns nothing if index is bigger then length" {
    String.charCodeAt(100, "Hello") == Maybe::Nothing
  }
}

suite "String.chopEnd" {
  test "it removes strings from the end of the string" {
    String.chopEnd(".", "The quick brown fox jumps.") == "The quick brown fox jumps"
  }
}

suite "String.chopStart" {
  test "it removes strings from the start of the string" {
    String.chopStart("T", "The quick brown fox jumps.") == "he quick brown fox jumps."
  }
}

suite "String.codePointAt" {
  test "returns just the character code at the given index" {
    String.codePointAt(1, "☃★♲") == Maybe::Just(9733)
  }

  test "returns nothing if negative" {
    String.codePointAt(-1, "☃★♲") == Maybe::Nothing
  }

  test "returns nothing if index is bigger then length" {
    String.codePointAt(100, "☃★♲") == Maybe::Nothing
  }
}

suite "String.concat" {
  test "joins an array of strings together" {
    String.concat(["The", "quick", "brown", "fox", "jumps."]) == "Thequickbrownfoxjumps."
  }
}

suite "String.contains" {
  test "returns true if string contains the pattern" {
    String.contains("fox", "The quick brown fox jumps over the lazy dog.") == true
  }

  test "returns false if string doesnot contain the pattern" {
    String.contains("bear", "The quick brown fox jumps over the lazy dog.") == false
  }
}

suite "String.dropEnd" {
  test "it removes the given number of characters" {
    String.dropEnd(1, "The quick brown fox jumps.") == "The quick brown fox jumps" &&
      String.dropEnd(2, "The quick brown fox jumps.") == "The quick brown fox jump"
  }
}

suite "String.dropStart" {
  test "it removes the given number of characters" {
    String.dropStart(1, "The quick brown fox jumps.") == "he quick brown fox jumps." &&
      String.dropStart(2, "The quick brown fox jumps.") == "e quick brown fox jumps."
  }
}

suite "String.endsWith" {
  test "it returns true if the given string ends with the given string" {
    String.endsWith("jumps.", "The quick brown fox jumps.") == true
  }
}

suite "String.fromCharCode" {
  test "it retunrs a string form a char chode" {
    String.fromCharCode(65) == "A"
  }
}

suite "String.fromCodePoint" {
  test "it retunrs a string form a char chode" {
    String.fromCodePoint(9731) == "☃"
  }
}

suite "String.indent" {
  test "it indents the given string by the given number of spaces" {
    String.indent(2, "The quick brown fox jumps.") == "  The quick brown fox jumps."
  }
}

suite "String.indentWithOptions" {
  test "it indents the given string by the given options" {
    String.indentWithOptions(2, " ", false, "The quick brown fox jumps.") == "  The quick brown fox jumps."
  }

  test "it skips empty lines" {
    String.indentWithOptions(2, " ", false, "The quick brown fox jumps.\n\nHello") == "  The quick brown fox jumps.\n\n  Hello"
  }

  test "it does not skip empty lines" {
    String.indentWithOptions(2, " ", true, "The quick brown fox jumps.\n\nHello") == "  The quick brown fox jumps.\n  \n  Hello"
  }
}

suite "String.indexOf" {
  test "it returns the index of the search param" {
    String.indexOf("whale", "The quick brown fox jumps over the lazy dog.") == Maybe::Nothing &&
      String.indexOf("fox", "The quick brown fox jumps over the lazy dog.") == Maybe::Just(16)
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
    String.join(" ", ["The", "quick", "brown", "fox", "jumps."]) == "The quick brown fox jumps."
  }
}

suite "String.lastIndexOf" {
  test "it returns the last index of the search param" {
    String.lastIndexOf("whale", "The quick brown fox jumps over the lazy dog.") == Maybe::Nothing &&
      String.lastIndexOf("the", "The quick brown fox jumps over the lazy dog.") == Maybe::Just(31)
  }
}

suite "String.normalize" {
  test "it normalizes the string" {
    String.normalize("\u0041\u006d\u0065\u0301\u006c\u0069\u0065") == "\u0041\u006d\u00e9\u006c\u0069\u0065"
  }
}

suite "String.padEnd" {
  test "it pads the string from the end" {
    String.padEnd("0", 2, "5") == "50"
  }
}

suite "String.padStart" {
  test "it pads the string from the start" {
    String.padStart("0", 2, "5") == "05"
  }
}

suite "String.paramterize" {
  test "it converts title case to dash case" {
    String.parameterize("The quick brown fox jumps.") == "the-quick-brown-fox-jumps"
  }
}

suite "String.repeat" {
  test "repeats a string the given number of times" {
    String.repeat(3, "The") == "TheTheThe"
  }
}

suite "String.replace" {
  test "it replaces the given pattern with replacement" {
    String.replace("fox", "bear", "The quick brown fox jumps.") == "The quick brown bear jumps."
  }
}

suite "String.replaceAll" {
  test "it replaces the given pattern with replacement" {
    String.replaceAll("fox", "bear", "The quick brown fox jumps over the lazy fox.") == "The quick brown bear jumps over the lazy bear."
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
    String.split(" ", "The quick brown fox jumps.") == ["The", "quick", "brown", "fox", "jumps."]
  }
}

suite "String.startsWith" {
  test "it returns true if the given string ends with the given string" {
    String.startsWith("The", "The quick brown fox jumps.") == true
  }
}

suite "String.takeEnd" {
  test "it takes the given number of characters from the end" {
    String.takeEnd(2, "The quick brown fox jumps.") == "s."
  }
}

suite "String.takeStart" {
  test "it takes the given number of characters from the end" {
    String.takeStart(2, "The quick brown fox jumps.") == "Th"
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
    String.withDefault("The quick brown fox jumps.", "") == "The quick brown fox jumps."
  }

  test "it returns the string for non-empty string" {
    String.withDefault("The quick brown fox jumps.", "Hello") == "Hello"
  }
}

suite "String.wrap" {
  test "it wraps the string with the given characters" {
    String.wrap("{", "}", "The quick brown fox jumps.") == "{The quick brown fox jumps.}"
  }
}
