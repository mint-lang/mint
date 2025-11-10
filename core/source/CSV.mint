// Represents a token (character or characters) while parsing a CSV document.
type CSV.Token {
  Separator(String, Number, Number)
  Text(String, Number, Number)
  DoubleQuote(Number, Number)
  LF(Number, Number)
  CR(Number, Number)
}

// Represents the state for parsing a CSV document.
type CSV.State {
  InsideEscapedString
  JustParsedSeparator
  JustParsedNewline
  JustParsedField
  JustParsedCR
  Beginning
}

// Represents an error of parsing a CSV document.
type CSV.Error {
  UnexpectedTokenCarriageReturn(CSV.Token)
  UnexpectedTokenAtStartOfLine(CSV.Token)
  UnexpectedTokenAfterField(CSV.Token)
  UnexpectedToken(CSV.Token)
}

// Represents a line ending for generating CSV documents.
type CSV.LineEnding {
  Windows
  Unix
}

// This module contains functions for parsing a CSV.
module CSV.Parser {
  // Returns the string representation of a CSV token.
  fun tokenToString (token : CSV.Token) : String {
    case token {
      Separator(string) => string
      Text(string) => string
      DoubleQuote => "\""
      LF => "\n"
      CR => "\r"
    }
  }

  // Returns the size of a CSV token.
  fun tokenSize (token : CSV.Token) : Number {
    case token {
      Separator(string) => String.size(string)
      Text(string) => String.size(string)
      DoubleQuote => 1
      LF => 1
      CR => 1
    }
  }

  // Scans the input using the separator and returns an array of CSV tokens,
  // which we can use for parsing (the tokens are in reverse order).
  fun scan (input : String, separator : String) : Array(CSV.Token) {
    (input
    |> String.split("")
    |> Array.reduce({[] of CSV.Token, 0, 0},
      (memo : Tuple(Array(CSV.Token), Number, Number), character : String) {
        let {items, column, line} =
          memo

        if character == separator {
          {
            Array.unshift(items, CSV.Token.Separator(separator, column, line)),
            column + 1,
            line
          }
        } else {
          case character {
            "\n" =>
              {Array.unshift(items, CSV.Token.LF(column, line)), 0, line + 1}

            "\"" =>
              {
                Array.unshift(items, CSV.Token.DoubleQuote(column, line)),
                column + 1,
                line
              }

            "\r" =>
              {
                Array.unshift(items, CSV.Token.CR(column, line)),
                column + 1,
                line
              }

            =>
              case items {
                [CSV.Token.Text(value), ...rest] =>
                  {
                    Array.unshift(rest,
                      CSV.Token.Text(value + character, column, line)),
                    column + 1,
                    line
                  }

                =>
                  {
                    Array.unshift(items,
                      CSV.Token.Text(character, column, line)),
                    column + 1,
                    line
                  }
              }
          }
        }
      }))[0]
  }

  // Parses the next step.
  fun parseNext (
    tokens : Array(CSV.Token),
    state : CSV.State,
    result : Array(Array(String))
  ) : Result(CSV.Error, Array(Array(String))) {
    case {tokens, state, result} {
      // No more tokens to parse, we are done.
      {[], _, items} =>
        items
        |> Array.reverse
        |> Array.map(Array.reverse)
        |> Result.Ok

      // File begins with a nonescaped value.
      {[Text(value), ...remaining], Beginning, []} =>
        parseNext(remaining, CSV.State.JustParsedField, [[value]])

      // File begins with an escaped value.
      {[DoubleQuote, ...remaining], Beginning, []} =>
        parseNext(remaining, CSV.State.InsideEscapedString, [[""]])

      // File starts with line-break, carriage-return or separator.
      {[token, ...remaining], Beginning, []} =>
        parseNext(remaining, CSV.State.Beginning, [])

      // If we just parsed a field, we're expecting either a separator
      // or a CRLF.
      {[Separator, ...remaining], JustParsedField, items} =>
        parseNext(remaining, CSV.State.JustParsedSeparator, items)

      {[LF, ...remaining], JustParsedField, items} =>
        parseNext(remaining, CSV.State.JustParsedNewline, items)

      {[CR, ...remaining], JustParsedField, items} =>
        parseNext(remaining, CSV.State.JustParsedCR, items)

      {[token, ..._], JustParsedField, _} =>
        Result.Err(CSV.Error.UnexpectedTokenAfterField(token))

      // If we just parsed a CR, we're expecting an LF
      {[LF, ...remaining], JustParsedCR, items} =>
        parseNext(remaining, CSV.State.JustParsedNewline, items)

      {[token, ..._], JustParsedCR, _} =>
        Result.Err(CSV.Error.UnexpectedTokenCarriageReturn(token))

      // If we just parsed a separator, we're expecting an escaped or
      // non-escaped string, or another separator (indicating an empty string)
      {[Text(value), ...remaining], JustParsedSeparator, [current, ...previous]} =>
        parseNext(remaining, CSV.State.JustParsedField,
          Array.unshift(previous, Array.unshift(current, value)))

      {[DoubleQuote, ...remaining], JustParsedSeparator, [current, ...previous]} =>
        parseNext(remaining, CSV.State.InsideEscapedString,
          Array.unshift(previous, Array.unshift(current, "")))

      {[Separator, ...remaining], JustParsedSeparator, [current, ...previous]} =>
        parseNext(remaining, CSV.State.JustParsedSeparator,
          Array.unshift(previous, Array.unshift(current, "")))

      {[CR, ...remaining], JustParsedSeparator, [current, ...previous]} =>
        parseNext(remaining, CSV.State.JustParsedCR,
          Array.unshift(previous, Array.unshift(current, "")))

      {[LF, ...remaining], JustParsedSeparator, [current, ...previous]} =>
        parseNext(remaining, CSV.State.JustParsedNewline,
          Array.unshift(previous, Array.unshift(current, "")))

      // If we just parsed a new line, we're expecting an escaped or
      // non-escaped string.
      {[Text(value), ...remaining], JustParsedNewline, items} =>
        parseNext(remaining, CSV.State.JustParsedField,
          Array.unshift(items, [value]))

      {[DoubleQuote, ...remaining], JustParsedNewline, items} =>
        parseNext(remaining, CSV.State.InsideEscapedString,
          Array.unshift(items, [""]))

      {[token, ..._], JustParsedNewline, _} =>
        Result.Err(CSV.Error.UnexpectedTokenAtStartOfLine(token))

      // If we're inside an escaped string, we can take anything until we get
      // a double quote, but a double double quote "" escapes the double quote
      // and we keep parsing.
      {
        [DoubleQuote, DoubleQuote, ...remaining],
        InsideEscapedString,
        [[value, ...current], ...previous]
      } =>
        parseNext(remaining, CSV.State.InsideEscapedString,
          Array.unshift(previous, Array.unshift(current, "#{value}\"")))

      {[DoubleQuote, ...remaining], InsideEscapedString, items} =>
        parseNext(remaining, CSV.State.JustParsedField, items)

      {
        [token, ...remaining],
        InsideEscapedString,
        [[value, ...current], ...previous]
      } =>
        parseNext(remaining, CSV.State.InsideEscapedString,
          Array.unshift(previous,
            Array.unshift(current, "#{value}#{tokenToString(token)}")))

      // Anything else is an error
      {[token, ..._], _, _} => Result.Err(CSV.Error.UnexpectedToken(token))
    }
  }
}

// The main module for parsing and generating CSVs.
module CSV {
  // Parses a CSV into an two dimensional array (rows and columns). The
  // separator can be specified and different line endings are automatically
  // handled.
  //
  //   CSV.parse("a,b,c") == Result.Ok(["a", "b", "c"])
  //
  fun parse (
    input : String,
    separator : String = ","
  ) : Result(CSV.Error, Array(Array(String))) {
    input
    |> CSV.Parser.scan(separator)
    |> Array.reverse()
    |> CSV.Parser.parseNext(CSV.State.Beginning, [])
  }

  // Takes a two dimensional array and writes it to a csv string.
  //
  // Will automatically escape strings that contain double quotes or line
  // endings with double quotes (in csv, double quotes get escaped by doing
  // a double doublequote)
  //
  //   CSV.generate([["Hello\"", "World"]]) == "\"Hello\"\"\",World"
  //
  fun generate (
    rows : Array(Array(String)),
    separator : String = ",",
    lineEnding : CSV.LineEnding = CSV.LineEnding.Unix
  ) : String {
    rows
    |> Array.map(
      (row : Array(String)) {
        Array.map(row,
          (field : String) {
            // Double quotes need to be escaped with an extra doublequote.
            let value =
              String.replace(field, "\"", "\"\"")

            // If the string contains a separator, \n, \r\n or " it needs to
            // be escaped by wrapping in double quotes.
            if String.contains(value, separator) || String.contains(value, "\n") || String.contains(
              value, "\"") {
              "\"#{value}\""
            } else {
              value
            }
          })
      })
    |> Array.map((row : Array(String)) { String.join(row, separator) })
    |> String.join(
      case lineEnding {
        Windows => "\r\n"
        Unix => "\n"
      })
  }
}
