/* Utility functions for working with `String`. */
module String {
  /*
  Converts the given string to lowercase.

     String.toLowerCase("ABC") == "abc"
  */
  toLowerCase (string : String) : String {
    `#{string}.toLowerCase()`
  }

  /*
  Converts the given string to lowercase.

     String.toUpperCase("abc") == "ABC"
  */
  toUpperCase (string : String) : String {
    `#{string}.toUpperCase()`
  }

  /*
  Reverses the given string.

     String.reverse("ABC") == "CBA"
  */
  reverse (string : String) : String {
    `[...#{string}].reverse().join('')`
  }

  /*
  Returns whether or not the string is empty.

     String.isEmpty("") == true
     String.isEmpty("a") == false
     String.isEmpty(" ") == false
  */
  isEmpty (string : String) : Bool {
    string == ""
  }

  /*
  Returns if the given pattern is included in the given string.

     String.match("A", "ABC") == true
     String.match("X", "ABC") == false
  */
  match (pattern : String, string : String) : Bool {
    `#{string}.indexOf(#{pattern}) != -1`
  }

  /*
  Splits the given string using the given separator.

    String.split("", "AAA") = ["A", "A", "A"]
  */
  split (separator : String, string : String) : Array(String) {
    `#{string}.split(#{separator})`
  }

  /*
  Returns number of characters in the given string.

    String.size("ABC") == 3
  */
  size (string : String) : Number {
    `#{string}.length`
  }

  /*
  Capitalizes each letter in the given string.

    String.capitalize("the cake is a lie!") == "The Cake Is A Lie!"
  */
  capitalize (string : String) : String {
    `#{string}.replace(/\b[a-z]/g, char => char.toUpperCase())`
  }

  /*
  Repeats the given string the given number of times.

    String.repeat(5, "A") == "AAAAA"
  */
  repeat (times : Number, string : String) : String {
    `#{string}.repeat(#{times})`
  }

  /*
  Joins the given array of string into a single string using the separator.

    String.join(",", ["A","B","C"]) == "A,B,C"
  */
  join (separator : String, array : Array(String)) : String {
    `#{array}.join(#{separator})`
  }

  /*
  Joins the given array of strings.

    String.concat(["A","B","C"]) == "ABC"
  */
  concat (array : Array(String)) : String {
    join("", array)
  }

  /*
  Returns if the given string is an anagram of the other string.

    String.isAnagarm("asd", "blah") == false
    String.isAnagarm("rail safety", "fairy tales") == true
  */
  isAnagarm (string1 : String, string2 : String) : Bool {
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
  Removes all occurances of the given character from the end of the
  given string.

    String.rchop("!", "Hello!!!") == "Hello"
  */
  rchop (char : String, string : String) : String {
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
  Removes all occurances of the given character from the start of the
  given string.

    String.lchop("!", "!!!Hello") == "Hello"
  */
  lchop (char : String, string : String) : String {
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
  Replaces the given pattern with the replacemet.

    String.replace("a", "0", "aaaa") == "0000"
  */
  replace (
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
  trim (value : String) : String {
    `#{value}.trim()`
  }

  /*
  Returns the given string or the given default value if the string is empty.

    String.withDefault("default", "") == "default"
    String.withDefault("default", "something") == "something"
  */
  withDefault (value : String, string : String) : String {
    if (String.isEmpty(string)) {
      value
    } else {
      string
    }
  }
}
