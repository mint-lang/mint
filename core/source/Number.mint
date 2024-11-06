/* This module provides functions for working with the `Number` type. */
module Number {
  /*
  Formats the number using the prefix and separating the digits by 3 with a
  comma.

    Number.format(1034150, "$ ") == "$ 1,034,150"
  */
  fun format (number : Number, prefix : String) : String {
    let string =
      Number.toFixed(number, 2)

    let parts =
      String.split(string, ".")

    let digits =
      parts[0]
      |> Maybe.withDefault("")
      |> String.chopStart("-")
      |> String.split("")
      |> Array.groupsOfFromEnd(3)
      |> Array.map((items : Array(String)) { String.join(items, "") })
      |> String.join(",")

    let decimals =
      parts[1]
      |> Maybe.withDefault("")
      |> String.chopEnd("0")

    if String.isEmpty(decimals) {
      prefix + digits
    } else {
      prefix + digits + "." + decimals
    }
  }

  /*
  Tries to parse the string input into a number.

    Number.fromString("012") == Maybe.Just(12)
    Number.fromString("asd") == Maybe.Nothing
  */
  fun fromString (input : String) : Maybe(Number) {
    `
    (() => {
      if (#{input}.trim() === '') {
        return #{Maybe.Nothing}
      }

      const value = Number(#{input})

      if (Number.isNaN(value)) {
        return #{Maybe.Nothing}
      }

      return #{Maybe.Just(`value`)}
    })()
    `
  }

  /*
  Returns `true` if number is even.

    Number.isEven(2) == false
    Number.isEven(1) == true
  */
  fun isEven (number : Number) : Bool {
    `Math.abs(#{number} % 2) === 0`
  }

  /*
  Returns `true` if number is `NaN`.

    Number.isNaN(`NaN`) == true
    Number.isNaN(0) == false
  */
  fun isNaN (number : Number) : Bool {
    `isNaN(#{number})`
  }

  /*
  Returns `true` if number is odd.

    Number.isOdd(1) == false
    Number.isOdd(2) == true
  */
  fun isOdd (number : Number) : Bool {
    `#{number} % 2 === 1`
  }

  /*
  Formats a number using fixed-point notation.

  The last arguments specifies the number of digits to appear after the
  decimal point, it can be between 0 and 20.

    Number.toFixed(0.1234567, 2) == "0.12"
  */
  fun toFixed (number : Number, decimalPlaces : Number) : String {
    `#{number}.toFixed(#{decimalPlaces})`
  }

  /*
  Returns the string representation of the number.

    Number.toString(123) == 123
  */
  fun toString (number : Number) : String {
    `#{number}.toString()`
  }
}
