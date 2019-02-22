module Number {
  /*
  Returns true if number is odd.

    Number.isOdd(1) == false
    Number.isOdd(2) == true
  */
  fun isOdd (input : Number) : Bool {
    `input % 2 === 1`
  }

  /*
  Returns true if number is even.

    Number.isEven(1) == true
    Number.isEven(2) == false
  */
  fun isEven (input : Number) : Bool {
    `Math.abs(input % 2) === 0`
  }

  /*
  Returns true if a number is a `NaN`.

    Number.isNaN(`NaN`) == true
    Number.isNaN(0) == false
  */
  fun isNaN (input : Number) : Bool {
    `isNaN(input)`
  }

  /*
  Returns the string representation of the given number.

    Number.toString(123) == 123
  */
  fun toString (input : Number) : String {
    `input.toString()`
  }

  /*
  Formats a number using fixed-point notation.

  The first arguments speficies the number of digits to appear after the decimal
  point, it can be between 0 and 20.

    Number.toFixed(2, 0.1234567) == "0.12"
  */
  fun toFixed (decimalPlaces : Number, input : Number) : String {
    `input.toFixed(decimalPlaces)`
  }

  /*
  Tries to parse the given string into a number.

    Number.fromString("asd") == Maybe.nothing()
    Number.fromString("012") == Maybe.just(12)
  */
  fun fromString (input : String) : Maybe(Number) {
    `
    (() => {
      let value = parseFloat(input)
      if (isNaN(value)) {
        return new Nothing()
      } else {
        return new Just(value)
      }
    })()
    `
  }
}
