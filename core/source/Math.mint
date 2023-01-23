/* Mathematical functions. */
module Math {
  /*
  Returns the absolute value of the given number.

    Math.abs(1) == 1
    Math.abs(-1) == 1
  */
  fun abs (number : Number) : Number {
    `Math.abs(#{number})`
  }

  /*
  Returns the smallest integer greater than or equal to the given number.

    Math.ceil(0.3) == 1
  */
  fun ceil (number : Number) : Number {
    `Math.ceil(#{number})`
  }

  /*
  Clamps the given number between the given upper and lower bounds.

    Math.clamp(0, 10, 100) == 10
    Math.clamp(0, 10, -100) == 0
  */
  fun clamp (lower : Number, upper : Number, value : Number) : Number {
    Math.min(upper, Math.max(lower, value))
  }

  /*
  Returns the largest integer less than or equal to the given number.

    Math.floor(0.8) == 0
  */
  fun floor (number : Number) : Number {
    `Math.floor(#{number})`
  }

  /*
  Returns the floating-point remainder of two numbers.

    Math.fmod(5.3, 2) == 1.3
    Math.fmod(18.5, 4.2) == 1.7
  */
  fun fmod (a : Number, b : Number) : Number {
    `Number((#{a} - (Math.floor(#{a} / #{b}) * #{b})).toPrecision(8))`
  }

  /*
  Returns the highest-valued number from the arguments.

    Math.min(1, 2) == 2
  */
  fun max (number1 : Number, number2 : Number) : Number {
    `Math.max(#{number1}, #{number2})`
  }

  /*
  Returns the lowest-valued number from the arguments.

    Math.min(1, 2) == 1
  */
  fun min (number1 : Number, number2 : Number) : Number {
    `Math.min(#{number1}, #{number2})`
  }

  /*
  Negates the given number.

    Math.negate(1) == -1
  */
  fun negate (number : Number) : Number {
    `-#{number}`
  }

  /*
  Returns the exponent power of the given number.

    Math.pow(2, 2) == 4
  */
  fun pow (exponent : Number, value : Number) : Number {
    `Math.pow(#{value}, #{exponent})`
  }

  /* Returns a pseudo-random number in the range 0 to less than 1. */
  fun random : Number {
    `Math.random()`
  }

  /*
  Returns the value of a number rounded to the nearest integer.

    Math.round(0.5) == 1
  */
  fun round (number : Number) : Number {
    `Math.round(#{number})`
  }

  /*
  Returns the square root of the given number

    Math.sqrt(4) == 2
  */
  fun sqrt (value : Number) : Number {
    `Math.sqrt(#{value})`
  }

  /*
  Returns the integer part of a number by removing any fractional digits.

    Math.trunc(13.37) == 13
    Math.trunc(42.84) == 42
  */
  fun trunc (number : Number) {
    `Math.trunc(#{number})`
  }

  /*
  Truncates the given number to the given amount.

    Math.truncate(0.123456) == 0.12
  */
  fun truncate (to : Number, value : Number) : Number {
    let multiplier =
      if (to == 0) {
        1
      } else {
        to * 100
      }

    `Math.trunc(#{value} * #{multiplier}) / #{multiplier}`
  }
}
