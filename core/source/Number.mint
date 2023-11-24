module Number {
  /*
  Formats the given number using the given prefix and separating the digits
  by 3 with a comma.

    Number.format("$ ", 1034150) == "$ 1,034,150"
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
  Tries to parse the given string into a number.

    Number.fromString("asd") == Maybe.nothing()
    Number.fromString("012") == Maybe.just(12)
  */
  fun fromString (input : String) : Maybe(Number) {
    `
    (() => {
      if (#{input}.trim() === '') {
        return #{Maybe.Nothing}
      }

      let value = Number(#{input})

      if (Number.isNaN(value)) {
        return #{Maybe.Nothing}
      }

      return #{Maybe.Just(`value`)}
    })()
    `
  }

  /*
  Returns true if given number is even.

    Number.isEven(1) == true
    Number.isEven(2) == false
  */
  fun isEven (input : Number) : Bool {
    `Math.abs(#{input} % 2) === 0`
  }

  /*
  Returns true if given number is `NaN`.

    Number.isNaN(`NaN`) == true
    Number.isNaN(0) == false
  */
  fun isNaN (input : Number) : Bool {
    `isNaN(#{input})`
  }

  /*
  Returns true if given number is odd.

    Number.isOdd(1) == false
    Number.isOdd(2) == true
  */
  fun isOdd (input : Number) : Bool {
    `#{input} % 2 === 1`
  }

  /*
  Formats a number using fixed-point notation.

  The first arguments specifies the number of digits to appear after the decimal
  point, it can be between 0 and 20.

    Number.toFixed(2, 0.1234567) == "0.12"
  */
  fun toFixed (input : Number, decimalPlaces : Number) : String {
    `#{input}.toFixed(#{decimalPlaces})`
  }

  /*
  Returns the string representation of the given number.

    Number.toString(123) == 123
  */
  fun toString (input : Number) : String {
    `#{input}.toString()`
  }
}
