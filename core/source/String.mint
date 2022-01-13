/* Utility functions for working with `String`. */
module String {
  /*
  Capitalizes each letter in the given string.

    String.capitalize("The quick brown fox jumps.") == "The Quick Brown Fox Jumps."
  */
  fun capitalize (string : String) : String {
    `#{string}.replace(/\b[a-z]/g, char => char.toUpperCase())`
  }

  /*
  Returns a string representing the character (exactly one UTF-16 code unit) at
  the specified index. If index is out of range, it returns an empty string.

    String.charAt(4, "The quick brown fox jumps over the lazy dog.") == "q"
  */
  fun charAt (index : Number, string : String) : String {
    `#{string}.charAt(#{index})`
  }

  /*
  Returns an integer between 0 and 65535 representing the UTF-16 code unit at
  the given index.

    String.charCodeAt(4, "The quick brown fox jumps over the lazy dog.") == Maybe::Just(113)
  */
  fun charCodeAt (index : Number, string : String) : Maybe(Number) {
    `
    (() => {
      const result = #{string}.charCodeAt(#{index});

      if (isNaN(result)) {
        return #{Maybe::Nothing}
      } else {
        return #{Maybe::Just(`result`)}
      }
    })()
    `
  }

  /*
  Removes all occurrences of the given character from the end of the
  given string.

    String.chopEnd(".", "The quick brown fox jumps.") == "The quick brown fox jumps"
  */
  fun chopEnd (char : String, string : String) : String {
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

    String.chopStart("T", "The quick brown fox jumps.") == "he quick brown fox jumps."
  */
  fun chopStart (char : String, string : String) : String {
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
  Returns a non-negative integer that is the UTF-16 code point value.

  * If there is no element at pos, returns `Maybe::Nothing`.
  * If the element at pos is a UTF-16 high surrogate, returns the code point of the surrogate pair.
  * If the element at pos is a UTF-16 low surrogate, returns only the low surrogate code point.


    String.codePointAt(1, "☃★♲") == Maybe::Just(9733)
  */
  fun codePointAt (index : Number, string : String) : Maybe(Number) {
    `
    (() => {
      const result = #{string}.codePointAt(#{index});

      if (result === undefined) {
        return #{Maybe::Nothing}
      } else {
        return #{Maybe::Just(`result`)}
      }
    })()
    `
  }

  /*
  Joins the given array of strings.

    String.concat(["The", "quick", "brown", "fox", "jumps."]) == "Thequickbrownfoxjumps."
  */
  fun concat (array : Array(String)) : String {
    join("", array)
  }

  /*
  Performs a case-sensitive search to determine whether one string may be found
  within another string, returning true or false as appropriate.

    String.contains("fox", "The quick brown fox jumps over the lazy dog.") == true
  */
  fun contains (search : String, string : String) : Bool {
    `#{string}.includes(#{search})`
  }

  /*
  Drops the number of characters from the end of the string.

    String.dropEnd(1, "The quick brown fox jumps.") == "The quick brown fox jumps"
    String.dropEnd(2, "The quick brown fox jumps.") == "The quick brown fox jump"
  */
  fun dropEnd (number : Number, string : String) : String {
    `#{string}.slice(0, -Math.abs(#{number}))`
  }

  /*
  Drops the number of characters from the start of the string.

    String.dropStart(1, "The quick brown fox jumps.") == "he quick brown fox jumps."
    String.dropStart(2, "The quick brown fox jumps.") == "e quick brown fox jumps."
  */
  fun dropStart (number : Number, string : String) : String {
    `#{string}.slice(#{Math.clamp(0, number, String.size(string))})`
  }

  /*
  Determines whether a string ends with the characters of a specified string,
  returning `true` or `false` as appropriate.

    String.endsWith("jumps.", "The quick brown fox jumps.") == true
  */
  fun endsWith (end : String, string : String) : Bool {
    `#{string}.endsWith(#{end})`
  }

  /*
  Returns a string created from the specified UTF-16 code unit.

    String.fromCharCode(65) == "A"
  */
  fun fromCharCode (charCode : Number) : String {
    `String.fromCharCode(#{charCode})`
  }

  /*
  Returns a string created by using the specified code point.

    String.fromCodePoint(9731) == "☃"
  */
  fun fromCodePoint (charCode : Number) : String {
    `String.fromCodePoint(#{charCode})`
  }

  /*
  Indents the string with the given number of spaces.

    String.indent(2, "The quick brown fox jumps.") == "  The quick brown fox jumps."
  */
  fun indent (by : Number, string : String) : String {
    indentWithOptions(by, " ", true, string)
  }

  /*
  Indents the string with the given number of characters
  using the given options.

    String.indentWithOptions(2, "-", false, "The quick brown fox jumps.") == "--The quick brown fox jumps."
  */
  fun indentWithOptions (
    by : Number,
    character : String,
    includeEmptyLines : Bool,
    string : String
  ) : String {
    `#{string}.replace(#{includeEmptyLines} ? /^/gm : /^(?!\s*$)/gm, #{repeat(by, character)})`
  }

  /*
  Returns the index within the calling String object of the first occurrence of
  the specified value, returns `Maybe::Nothing` if the value is not found.

    String.indexOf("whale", "The quick brown fox jumps over the lazy dog.") == Maybe::Nothing
    String.indexOf("fox", "The quick brown fox jumps over the lazy dog.") == Maybe::Just(16)
  */
  fun indexOf (search : String, string : String) : Maybe(Number) {
    `
    (() => {
      const result = #{string}.indexOf(#{search});

      if (result == -1) {
        return #{Maybe::Nothing}
      } else {
        return #{Maybe::Just(`result`)}
      }
    })()
    `
  }

  /*
  Returns if the given string is an anagram of the other string.

    String.isAnagram("The", "quick") == false
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
  Returns whether or not the string is blank (only contains whitespace).

     String.isBlank("") == true
     String.isBlank(" ") == true
     String.isBlank("The quick brown fox jumps.") == false
  */
  fun isBlank (string : String) : Bool {
    String.trim(string) == ""
  }

  /*
  Returns whether or not the string is empty ("").

     String.isEmpty("") == true
     String.isEmpty(" ") == false
     String.isEmpty("The quick brown fox jumps.") == false
  */
  fun isEmpty (string : String) : Bool {
    string == ""
  }

  /*
  Returns whether or not the string is not blank.

    String.isNotBlank("   ") == false
    String.isNotBlank("The quick brown fox jumps.") == true
  */
  fun isNotBlank (string : String) : Bool {
    !String.isBlank(string)
  }

  /*
  Returns whether or not the string is not empty.

    String.isNotEmpty("   ") == true
    String.isNotEmpty("The quick brown fox jumps.") == true
  */
  fun isNotEmpty (string : String) : Bool {
    !String.isEmpty(string)
  }

  /*
  Joins the given array of string into a single string using the separator.

    String.join(" ", ["The","quick","brown", "fox", "jumps."]) == "The quick brown fox jumps."
  */
  fun join (separator : String, array : Array(String)) : String {
    `#{array}.join(#{separator})`
  }

  /*
  Returns the index within the calling String object of the last occurrence of
  the specified value, returns `Maybe::Nothing` if the value is not found.

    String.lastIndexOf("whale", "The quick brown fox jumps over the lazy dog.") == Maybe::Nothing
    String.lastIndexOf("the", "The quick brown fox jumps over the lazy dog.") == Maybe::Just(31)
  */
  fun lastIndexOf (search : String, string : String) : Maybe(Number) {
    `
    (() => {
      const result = #{string}.lastIndexOf(#{search});

      if (result == -1) {
        return #{Maybe::Nothing}
      } else {
        return #{Maybe::Just(`result`)}
      }
    })()
    `
  }

  /*
  Returns the Unicode Normalization Form of the string.

    String.normalize("\u0041\u006d\u0065\u0301\u006c\u0069\u0065") == "\u0041\u006d\u00e9\u006c\u0069\u0065"
  */
  fun normalize (string : String) : String {
    `#{string}.normalize()`
  }

  /*
  Pads the current string with another string (multiple times, if needed) until
  the resulting string reaches the given length. The padding is applied from
  the end of the current string.

    String.padEnd("0", 2, "5") == "50"
  */
  fun padEnd (
    padString : String,
    targetLength : Number,
    string : String
  ) : String {
    `#{string}.padEnd(#{targetLength}, #{padString})`
  }

  /*
  Pads the current string with another string (multiple times, if needed) until
  the resulting string reaches the given length. The padding is applied from
  the start of the current string.

    String.padStart("0", 2, "5") == "05"
  */
  fun padStart (
    padString : String,
    targetLength : Number,
    string : String
  ) : String {
    `#{string}.padStart(#{targetLength}, #{padString})`
  }

  /*
  Parameterizes the string:
  - replaces non alphanumeric, dash and underscore characters with dash
  - converts title case to dash case (TitleCase -> title-case)
  - collapses multiple dashes into a single one
  - removes the leading and trailing dash(es)
  - converts to lowercase

    String.parameterize("The quick brown fox jumps.") == "the-quick-brown-fox-jumps"
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
  Repeats the given string the given number of times.

    String.repeat(3, "The") == "TheTheThe"
  */
  fun repeat (times : Number, string : String) : String {
    `#{string}.repeat(#{times})`
  }

  /*
  Returns a new string with the first matches of a pattern replaced by a
  replacement.

    String.replace("fox", "bear", "The quick brown fox jumps.") ==
      "The quick brown bear jumps."
  */
  fun replace (
    pattern : String,
    replacement : String,
    string : String
  ) : String {
    `#{string}.replace(#{pattern}, #{replacement})`
  }

  /*
  Returns a new string with all matches of a pattern replaced by a replacement.

    String.replaceAll("fox", "bear", "The quick brown fox jumps over the lazy fox.") ==
      "The quick brown bear jumps over the lazy bear."
  */
  fun replaceAll (
    pattern : String,
    replacement : String,
    string : String
  ) : String {
    `#{string}.replaceAll(#{pattern}, #{replacement})`
  }

  /*
  Reverses the given string.

     String.reverse("The quick brown fox jumps.") == ".spmuj xof nworb kciuq ehT"
  */
  fun reverse (string : String) : String {
    `[...#{string}].reverse().join('')`
  }

  /*
  Returns number of characters in the given string.

    String.size("The quick brown fox jumps.") == 26
  */
  fun size (string : String) : Number {
    `#{string}.length`
  }

  /*
  Splits the given string using the given separator.

    String.split(" ", "The quick brown fox jumps.") ==
      ["The", "quick", "brown", "fox", "jumps."]
  */
  fun split (separator : String, string : String) : Array(String) {
    `#{string}.split(#{separator})`
  }

  /*
  Determines whether a string starts with the characters of a specified string,
  returning `true` or `false` as appropriate.

    String.startsWith("The", "The quick brown fox jumps.") == true
  */
  fun startsWith (end : String, string : String) : Bool {
    `#{string}.startsWith(#{end})`
  }

  /*
  Returns the given number of characters from the end of the string.

    String.takeEnd(2, "The quick brown fox jumps.") == "s."
  */
  fun takeEnd (length : Number, string : String) : String {
    `#{string}.slice(#{string}.length - #{length})`
  }

  /*
  Returns the given number of characters from the start of the string.

    String.takeStart(2, "The quick brown fox jumps.") == "Th"
  */
  fun takeStart (length : Number, string : String) : String {
    `#{string}.slice(0, #{length})`
  }

  /*
  Convert the given string into an array of strings.

    String.toArray("Hello") == ["H", "e", "l", "l", "o"]
  */
  fun toArray (string : String) : Array(String) {
    split("", string)
  }

  /*
  Converts the given string to lowercase.

     String.toLowerCase("HELLO") == "hello"
  */
  fun toLowerCase (string : String) : String {
    `#{string}.toLowerCase()`
  }

  /*
  Converts the given string to lowercase.

     String.toUpperCase("hello") == "HELLO"
  */
  fun toUpperCase (string : String) : String {
    `#{string}.toUpperCase()`
  }

  /*
  Removes whitespace from the beginning and end of the string.

    String.trim("  The quick brown fox jumps.  ") == "The quick brown fox jumps."
  */
  fun trim (value : String) : String {
    `#{value}.trim()`
  }

  /*
  Returns the given string or the given default value if the string is empty.

    String.withDefault("The quick brown fox jumps.", "") == "The quick brown fox jumps."
    String.withDefault("The quick brown fox jumps.", "Hello") == "Hello"
  */
  fun withDefault (value : String, string : String) : String {
    if (String.isEmpty(string)) {
      value
    } else {
      string
    }
  }

  /*
  Wraps the string with the given start and end characters.

    String.wrap("{","}", "The quick brown fox jumps.") == "{The quick brown fox jumps.}"
  */
  fun wrap (start : String, end : String, string : String) : String {
    "#{start}#{string}#{end}"
  }
}
