/* Represents the options for a regular expression. */
type Regexp.Options {
  caseInsensitive : Bool,
  multiline : Bool,
  unicode : Bool,
  global : Bool,
  sticky : Bool
}

/* Represents a regular expression match. */
type Regexp.Match {
  submatches : Array(String),
  match : String,
  index : Number
}

/* This module provides functions for working with regular expressions. */
module Regexp {
  /*
  Creates a new regular expression from a string.

    Regexp.create("test") == /test/
  */
  fun create (input : String) : Regexp {
    `new RegExp(#{input})`
  }

  /*
  Creates a new regular expression using the options.

    Regexp.createWithOptions(
      "test",
      {
        caseInsensitive: true,
        multiline: true,
        unicode: true,
        global: true,
        sticky: true
      }) == /test/gimuy
  */
  fun createWithOptions (input : String, options : Regexp.Options) : Regexp {
    `
    (() => {
      let flags = ""

      if (#{options.caseInsensitive}) { flags += "i" }
      if (#{options.multiline}) { flags += "m" }
      if (#{options.unicode}) { flags += "u" }
      if (#{options.global}) { flags += "g" }
      if (#{options.sticky}) { flags += "y" }

      return new RegExp(#{input}, flags)
    })()
    `
  }

  /*
  Escapes the input to use in a regular expression.

    Regexp.escape("-{") == "\\-\\{"
  */
  fun escape (input : String) : String {
    `#{input}.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')`
  }

  /*
  Returns whether or not the regular expression matches the string.

    Regexp.match(/,/, "asd,asd")) == true
  */
  fun match (regexp : Regexp, input : String) : Bool {
    `#{regexp}.test(#{input})`
  }

  /*
  Returns all of the matches of the regular expression against the string.

    Regexp.matces(/\w/i, "a,b,c,d") == [
      {
        submatches: [],
        match: "a",
        index: 0
      }
    ]
  */
  fun matches (regexp : Regexp, input : String) : Array(Regexp.Match) {
    `
    (() => {
      let results = []
      let index = 0

      #{input}.replace(#{regexp}, function() {
        const args =
          Array.from(arguments)

        const match =
          args.shift()

        const submatches =
          args.slice(0, -2)

        index += 1

        results.push(#{{
          submatches: `submatches`,
          index: `index`,
          match: `match`
        }})
      })

      return results
    })()
    `
  }

  /*
  Replaces the matches of the regular expression using the function to
  calculate the replacement string.

    Regexp.replace(
      /\w/i,
      "a,b,c,d",
      (match : Regexp.Match) { match.match + "1" }) == "a1,b1,c1,d1"
  */
  fun replace (
    regexp : Regexp,
    input : String,
    replacer : Function(Regexp.Match, String)
  ) : String {
    `
    (() => {
      let index = 0

      return #{input}.replace(#{regexp}, function() {
        const args =
          Array.from(arguments)

        const match =
          args.shift()

        const submatches =
          args.slice(0, -2)

        index += 1

        return #{replacer}(#{{
          submatches: `submatches`,
          index: `index`,
          match: `match`
        }})
      })
    })()
    `
  }

  /*
  Splits the string by the regular expression.

    Regexp.split(/,/, "a,b,c,d") == ["a", "b", "c", "d"]
  */
  fun split (regexp : Regexp, input : String) : Array(String) {
    `#{input}.split(#{regexp})`
  }

  /*
  Returns the string representation of the regular expression.

    Regexp.toString(/test/) == "/test/"
  */
  fun toString (regexp : Regexp) : String {
    `#{regexp}.toString()`
  }

  /*
  Executes the regular expression and returns an array of matches.
  The returned array has the matched text as the first item, and then one item
  for each capturing group of the matched text.

    Regexp.exec(/,/, "a,b,c,d") == [","]
  */
  fun exec (regexp : Regexp, string : String) : Array(String) {
    `[...#{regexp}.exec(#{string})] || []`
  }
}
