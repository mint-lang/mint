/* Utility functions for working with `String`. */
module String {
  /*
  Converts the given string to lowercase.

     String.toLowerCase("ABC") == "abc"
  */
  fun toLowerCase (string : String) : String {
    `#{string}.toLowerCase()`
  }

  /*
  Converts the given string to lowercase.

     String.toUpperCase("abc") == "ABC"
  */
  fun toUpperCase (string : String) : String {
    `#{string}.toUpperCase()`
  }

  /*
  Reverses the given string.

     String.reverse("ABC") == "CBA"
  */
  fun reverse (string : String) : String {
    `[...#{string}].reverse().join('')`
  }

  /*
  Returns whether or not the string is empty ("").

     String.isEmpty("") == true
     String.isEmpty("a") == false
     String.isEmpty(" ") == false
  */
  fun isEmpty (string : String) : Bool {
    string == ""
  }

  /*
  Returns whether or not the string is not empty.

    String.isNotEmpty("a") == true
    String.isNotEmpty("   ") == true
  */
  fun isNotEmpty (string : String) : Bool {
    !String.isEmpty(string)
  }

  /*
  Returns whether or not the string is blank (only contains whitespace).

     String.isBlank("") == true
     String.isBlank(" ") == true
     String.isBlank("a") == false
  */
  fun isBlank (string : String) : Bool {
    String.trim(string) == ""
  }

  /*
  Returns whether or not the string is not blank.

    String.isNotBlank("a") == true
    String.isNotBlank("   ") == false
  */
  fun isNotBlank (string : String) : Bool {
    !String.isBlank(string)
  }

  /*
  Returns if the given pattern is included in the given string.

     String.match("A", "ABC") == true
     String.match("X", "ABC") == false
  */
  fun match (pattern : String, string : String) : Bool {
    `#{string}.indexOf(#{pattern}) != -1`
  }

  /*
  Splits the given string using the given separator.

    String.split("", "AAA") = ["A", "A", "A"]
  */
  fun split (separator : String, string : String) : Array(String) {
    `#{string}.split(#{separator})`
  }

  /*
  Returns number of characters in the given string.

    String.size("ABC") == 3
  */
  fun size (string : String) : Number {
    `#{string}.length`
  }

  /*
  Capitalizes each letter in the given string.

    String.capitalize("the cake is a lie!") == "The Cake Is A Lie!"
  */
  fun capitalize (string : String) : String {
    `#{string}.replace(/\b[a-z]/g, char => char.toUpperCase())`
  }

  /*
  Repeats the given string the given number of times.

    String.repeat(5, "A") == "AAAAA"
  */
  fun repeat (times : Number, string : String) : String {
    `#{string}.repeat(#{times})`
  }

  /*
  Joins the given array of string into a single string using the separator.

    String.join(",", ["A","B","C"]) == "A,B,C"
  */
  fun join (separator : String, array : Array(String)) : String {
    `#{array}.join(#{separator})`
  }

  /*
  Joins the given array of strings.

    String.concat(["A","B","C"]) == "ABC"
  */
  fun concat (array : Array(String)) : String {
    join("", array)
  }

  /*
  Returns if the given string is an anagram of the other string.

    String.isAnagram("asd", "blah") == false
    String.isAnagram("rail safety", "fairy tales") == true
  */
  fun isAnagram (string1 : String, string2 : String) : Bool {
    `
    (() => {
      const normalize = string =>
        string
          .toLowerCase()
          .replace(/[^a-z0-9]/gi, '')
          .split('')
          .sort()
          .join('');

      return normalize(#{string1}) === normalize(#{string2});
    })()
    `
  }

  /*
  Removes all occurrences of the given character from the end of the
  given string.

    String.rchop("!", "Hello!!!") == "Hello"
  */
  fun rchop (char : String, string : String) : String {
    `
    (() => {
      while (#{string}.slice(-#{char}.length) == #{char}) {
        #{string} = #{string}.slice(0,-#{char}.length)
      }

      return #{string}
    })()
    `
  }

  /*
  Removes all occurrences of the given character from the start of the
  given string.

    String.lchop("!", "!!!Hello") == "Hello"
  */
  fun lchop (char : String, string : String) : String {
    `
    (() => {
      while (#{string}.slice(0, #{char}.length) == #{char}) {
        #{string} = #{string}.slice(#{char}.length)
      }

      return #{string}
    })()
    `
  }

  /*
  Replaces the given pattern with the replacements.

    String.replace("a", "0", "aaaa") == "0000"
  */
  fun replace (
    pattern : String,
    replacement : String,
    string : String
  ) : String {
    `#{string}.replace(new RegExp(#{pattern}, 'g'), #{replacement})`
  }

  /*
  Removes whitespace from the beginning and end of the string.

    String.trim("  asd ") == "asd"
  */
  fun trim (value : String) : String {
    `#{value}.trim()`
  }

  /*
  Returns the given string or the given default value if the string is empty.

    String.withDefault("default", "") == "default"
    String.withDefault("default", "something") == "something"
  */
  fun withDefault (value : String, string : String) : String {
    if (String.isEmpty(string)) {
      value
    } else {
      string
    }
  }

  /*
  Convert the given string into an array of strings.

    String.toArray("AAA") = ["A", "A", "A"]
  */
  fun toArray (string : String) : Array(String) {
    split("", string)
  }

  /*
  Joins the given array of strings, alias for `String.concat`.

    String.fromArray(["A","B","C"]) == "ABC"
  */
  fun fromArray (array : Array(String)) : String {
    concat(array)
  }

  /*
  Drops the number of characters from the string.

    String.dropLeft(1, "abc") == "bc"
    String.dropLeft(2, "abc") == "c"
  */
  fun dropLeft (number : Number, string : String) : String {
    `#{string}.slice(#{Math.clamp(0, number, String.size(string))})`
  }

  /*
  Parameterizes the string:
  - replaces non alphanumeric, dash and underscore characters with dash
  - converts title case to dash case (TitleCase -> title-case)
  - collapses multiple dashes into a single one
  - removes the leading and trailing dash(es)
  - converts to lowercase

    String.parameterize("Ui.ActionSheet") == "ui-action-sheet"
    String.parameterize("HELLO THERE!!!") == "hello-there"
    String.parameterize("-_!ASD!_-") == "asd"
  */
  fun parameterize (string : String) : String {
    `
    #{string}
      .replace(/[^\p{Lu}\p{Ll}0-9\-_]+/gu, '-') // Replace non alphanumerical with dashes
      .replace(/\p{Lu}([\p{Ll}0-9]+|[\p{Lu}0-9]+)?/gu, '-$&')
      .replace(/-{2,}/g, '-')
      .replace(/^-+/i, '')
      .replace(/-+$/i, '')
      .toLowerCase()
    `
  }

  /*
  Wraps the string with the given start and end characters.

    String.wrap("{","}", "Hello there!") == "{Hello there!}"
  */
  fun wrap (start : String, end : String, string : String) : String {
    "#{start}#{string}#{end}"
  }

  /*
  Indents the string with the given number of spaces.

    String.indent(2, "Hello There!") == "  Hello There!"
  */
  fun indent (by : Number, string : String) : String {
    indentWithOptions(by, " ", true, string)
  }

  /*
  Indents the string with the given number of characters
  using the given options.

    String.indentWithOptions(2, "-", false, "Hello There!") == "--Hello There!"
  */
  fun indentWithOptions (
    by : Number,
    character : String,
    includeEmptyLines : Bool,
    string : String
  ) : String {
    `#{string}.replace(#{includeEmptyLines} ? /^/gm : /^(?!\s*$)/gm, #{repeat(by, character)})`
  }
}
