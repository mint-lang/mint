/* Represents the options for a regular expression. */
record Regexp.Options {
  caseInsensitive : Bool,
  multiline : Bool,
  unicode : Bool,
  global : Bool,
  sticky : Bool
}

/* Represents a regular expression match. */
record Regexp.Match {
  submatches : Array(String),
  match : String,
  index : Number
}

/* Functions for working with regular expressions. */
module Regexp {
  /*
  Creates a new regular expression from a string.

    (Regexp.create("test")
    |> Regexp.toString()) == "/test/"
  */
  fun create (input : String) : Regexp {
    `new RegExp(input)`
  }

  /*
  Creates a new regular expression using the given options.

    (Regexp.createWithOptions(
      "test",
      {
        caseInsensitive = true,
        multiline = true,
        unicode = true,
        global = true,
        sticky = true
      })
    |> Regexp.toString()) == "/test/gimuy"
  */
  fun createWithOptions (input : String, options : Regexp.Options) : Regexp {
    `
    (() => {
      let flags = ""

      if (options.caseInsensitive) { flags += "i" }
      if (options.multiline) { flags += "m" }
      if (options.unicode) { flags += "u" }
      if (options.global) { flags += "g" }
      if (options.sticky) { flags += "y" }

      return new RegExp(input, flags)
    })()
    `
  }

  /*
  Returns the string representation of the given regular expression.

    (Regexp.create("test")
    |> Regexp.toString()) == "/test/"
  */
  fun toString (regexp : Regexp) : String {
    `regexp.toString()`
  }

  /*
  Escapes the given input to use in the regular expression.

    Regexp.escape("-{") == "\\-\\{"
  */
  fun escape (input : String) : String {
    `input.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')`
  }

  /*
  Splits the given string by the given regular expression.

    (Regexp.create(",")
    |> Regexp.split("a,b,c,d")) == ["a", "b", "c", "d"]
  */
  fun split (input : String, regexp : Regexp) : Array(String) {
    `input.split(regexp)`
  }

  /*
  Returns whether or not the given regular expression matches the given string.

    (Regexp.create(",")
    |> Regexp.match("asd,asd")) == true
  */
  fun match (input : String, regexp : Regexp) : Bool {
    `regexp.test(input)`
  }

  /*
  Returns all of the matches of the given regular expession agains the
  given string.

    (Regexp.createWithOptions(
      "\\w",
      {
        caseInsensitive = true,
        multiline = false,
        unicode = false,
        global = true,
        sticky = false
      })
    |> Regexp.matces("a,b,c,d") == [
      {
        submatches = [],
        match = "a",
        index = 0
      }
    ]
      \match : Regexp.Match => match.match + "1")) == "a1,b1,c1,d1"
  */
  fun matches (input : String, regexp : Regexp) : Array(Regexp.Match) {
    `
    (() => {
      let results = []
      let index = 0

      input.replace(regexp, function() {
        const args =
          Array.from(arguments)

        const match =
          args.shift()

        const submatches =
          args.slice(0, -2)

        index += 1

        results.push(new Record({
          submatches: submatches,
          index: index,
          match: match
        }))
      })

      return results
    })()
    `
  }

  /*
  Replaces the matches of the given regular expression using the given function
  to caluclate the replacement string.

    (Regexp.createWithOptions(
      "\\w",
      {
        caseInsensitive = true,
        multiline = false,
        unicode = false,
        global = true,
        sticky = false
      })
    |> Regexp.replace(
      "a,b,c,d",
      \match : Regexp.Match => match.match + "1")) == "a1,b1,c1,d1"
  */
  fun replace (
    input : String,
    replacer : Function(Regexp.Match, String),
    regexp : Regexp
  ) : String {
    `
    (() => {
      let index = 0

      return input.replace(regexp, function() {
        const args =
          Array.from(arguments)

        const match =
          args.shift()

        const submatches =
          args.slice(0, -2)

        index += 1

        return replacer({
          submatches: submatches,
          index: index,
          match: match
        })
      })
    })()
    `
  }
}
