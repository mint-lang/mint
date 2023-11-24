/* Mathematical functions. */
module Math {
  /* Euler's number and the base of natural logarithms; approximately `2.718`. */
  const E = `Math.E`

  /* Natural logarithm of `10`; approximately `2.303`. */
  const LN10 = `Math.LN10`

  /* Natural logarithm of `2`; approximately `0.693`. */
  const LN2 = `Math.LN2`

  /* Base-10 logarithm of `E`; approximately `0.434`. */
  const LOG10E = `Math.LOG10E`

  /* Base-2 logarithm of `E`; approximately `1.443`. */
  const LOG2E = `Math.LOG2E`

  /* Ratio of a circle's circumference to its diameter; approximately `3.14159`. */
  const PI = `Math.PI`

  /* Square root of `0.5`; approximately `0.707`. */
  const SQRT12 = `Math.SQRT1_2`

  /* Square root of `2`; approximately `1.414`. */
  const SQRT2 = `Math.SQRT2`

  /*
  Returns the absolute value of the given number.

    Math.abs(1) == 1
    Math.abs(-1) == 1
  */
  fun abs (number : Number) : Number {
    `Math.abs(#{number})`
  }

  /* Returns the inverse cosine of the given angle in radians */
  fun acos (number : Number) : Number {
    `Math.acos(#{number})`
  }

  /* Returns the inverse hyperbolic cosine of the given angle in radians */
  fun acosh (number : Number) : Number {
    `Math.acosh(#{number})`
  }

  /* Returns the inverse sine of the given angle in radians */
  fun asin (number : Number) : Number {
    `Math.asin(#{number})`
  }

  /* Returns the inverse hyperbolic sine of the given angle in radians */
  fun asinh (number : Number) : Number {
    `Math.asinh(#{number})`
  }

  /* Returns the inverse tangent of the given angle in radians */
  fun atan (number : Number) : Number {
    `Math.atan(#{number})`
  }

  /* Returns the angle in the plane (in radians) between the positive x-axis and the ray from (0, 0) to the point (x, y) */
  fun atan2 (y : Number, x : Number) : Number {
    `Math.atan2(#{y}, #{x})`
  }

  /* Returns the inverse hyperbolic tangent of the given angle in radians */
  fun atanh (number : Number) : Number {
    `Math.atanh(#{number})`
  }

  /*
  Returns the cubic root of the given number

    Math.cbrt(1) == 1
    Math.cbrt(64) == 4
  */
  fun cbrt (number : Number) : Number {
    `Math.cbrt(#{number})`
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

    Math.clamp(100, 0, 10) == 10
    Math.clamp(-100, 0, 10) == 0
  */
  fun clamp (value : Number, lower : Number, upper : Number) : Number {
    Math.min(upper, Math.max(lower, value))
  }

  /*
  Returns the number of leading zero bits in the 32-bit binary representation of a number

   00000000000000000000000000000100
   Math.clz32(4) == 29
  */
  fun clz32 (number : Number) : Number {
    `Math.clz32(#{number})`
  }

  /* Returns the cosine of the given angle in radians */
  fun cos (number : Number) : Number {
    `Math.cos(#{number})`
  }

  /* Returns the hyperbolic cosine of the given angle in radians */
  fun cosh (number : Number) : Number {
    `Math.cosh(#{number})`
  }

  /* Returns the value of `Math.E` raised to the power x, where x is the given number */
  fun exp (x : Number) : Number {
    `Math.exp(#{x})`
  }

  /*
  Returns the value of `Math.E` to the power x, minus 1

    Math.exp(2) == 7.38905609893065
    Math.expm1(2) == 6.38905609893065
  */
  fun expm1 (x : Number) : Number {
    `Math.expm1(#{x})`
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

    Math.fmod(2, 5.3) == 1.3
    Math.fmod(4.2, 18.5) == 1.7
  */
  fun fmod (a : Number, b : Number) : Number {
    `Number((#{b} - (Math.floor(#{b} / #{a}) * #{a})).toPrecision(8))`
  }

  /* Returns the nearest 32-bit single precision float representation of the given number. */
  fun fround (number : Number) : Number {
    `Math.fround(#{number})`
  }

  /*
  Returns the square root of the sum of squares of its arguments.

    Math.hypot(3, 4) == 5
  */
  fun hypot (a : Number, b : Number) : Number {
    `Math.hypot(#{a}, #{b})`
  }

  /*
  Returns the result using C-like 32-bit multiplication of the two parameters.

    Math.imul(3, 4) == 12
  */
  fun imul (a : Number, b : number) : Number {
    `Math.imul(#{a}, #{b})`
  }

  /*
  Returns natural logarithm (base e) of the given value

    Math.log(1) == 0
  */
  fun log (number : Number) : Number {
    `Math.log(#{number})`
  }

  /*
  Returns natural logarithm (base 10) of the given value

    Math.log10(100) == 10
  */
  fun log10 (number : Number) : Number {
    `Math.log10(#{number})`
  }

  /*
  Returns natural logarithm (base e) of the given value, plus 1

    Math.log1p(1) == 0
  */
  fun log1p (number : Number) : Number {
    `Math.log1p(#{number})`
  }

  /*
  Returns natural logarithm (base 2) of the given value

    Math.log2(8) == 3
  */
  fun log2 (number : Number) : Number {
    `Math.log2(#{number})`
  }

  /*
  Returns the highest-valued number from the arguments.

    Math.max(1, 2) == 2
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
  fun pow (value : Number, exponent : Number) : Number {
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
  Returns the sign of the given number (1 or -1)

    Math.sign(5) == 1
    Math.sign(-5) == -1
  */
  fun sign (number : Number) : Number {
    `Math.sign(#{number})`
  }

  /* Calculates the sine of the given angle in radians */
  fun sin (value : Number) : Number {
    `Math.sin(#{value})`
  }

  /* Calculates the hyperbolic sine of the given angle in radians */
  fun sinh (number : Number) : Number {
    `Math.sinh(#{number})`
  }

  /*
  Returns the square root of the given number

    Math.sqrt(4) == 2
  */
  fun sqrt (value : Number) : Number {
    `Math.sqrt(#{value})`
  }

  /* Calculates the tangent of the given angle in radians */
  fun tan (number : Number) {
    `Math.tan(#{number})`
  }

  /* Calculates the hyperbolic tangent of the given angle in radians */
  fun tanh (number : Number) : Number {
    `Math.tanh(#{number})`
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

    Math.truncate(0.123456, 2) == 0.12
  */
  fun truncate (value : Number, to : Number) : Number {
    let multiplier =
      if to == 0 {
        1
      } else {
        to * 100
      }

    `Math.trunc(#{value} * #{multiplier}) / #{multiplier}`
  }
}
