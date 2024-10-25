/* This module provides mathematical functions and constants. */
module Math {
  /* Base-10 logarithm of `E` (approximately `0.434`) */
  const LOG10E = `Math.LOG10E`

  /* Square root of `0.5` (approximately `0.707`) */
  const SQRT1_2 = `Math.SQRT1_2`

  /* Base-2 logarithm of `E` (approximately `1.443`) */
  const LOG2E = `Math.LOG2E`

  /* Square root of `2` (approximately `1.414`) */
  const SQRT2 = `Math.SQRT2`

  /* Natural logarithm of `10` (approximately `2.303`) */
  const LN10 = `Math.LN10`

  /* Natural logarithm of `2` (approximately `0.693`) */
  const LN2 = `Math.LN2`

  /* Ratio of a circle's circumference to its diameter (approximately `3.14159`) */
  const PI = `Math.PI`

  /* Euler's number and the base of natural logarithms (approximately `2.718`) */
  const E = `Math.E`

  /*
  Returns the absolute value of the number.

    Math.abs(1) == 1
    Math.abs(-1) == 1
  */
  fun abs (number : Number) : Number {
    `Math.abs(#{number})`
  }

  /*
  Returns the inverse cosine of the angle in radian.

    Math.acos(0) == 1.5707963267948966
  */
  fun acos (angle : Number) : Number {
    `Math.acos(#{angle})`
  }

  /*
  Returns the inverse hyperbolic cosine of the angle in radians.

    Math.acosh(2) == 1.3169578969248166
  */
  fun acosh (angle : Number) : Number {
    `Math.acosh(#{angle})`
  }

  /*
  Returns the inverse sine of the angle in radians.

    Math.asin(0.5) == 0.5235987755982989
  */
  fun asin (angle : Number) : Number {
    `Math.asin(#{angle})`
  }

  /*
  Returns the inverse hyperbolic sine of the angle in radians.

    Math.asinh(1) == 0.881373587019543
  */
  fun asinh (angle : Number) : Number {
    `Math.asinh(#{angle})`
  }

  /*
  Returns the inverse tangent of the angle in radians.

    Math.atan(1) == 0.7853981633974483
  */
  fun atan (angle : Number) : Number {
    `Math.atan(#{angle})`
  }

  /*
  Returns the angle in the plane (in radians) between the positive x-axis
  and the ray from (0, 0) to the point (x, y).

    Math.atan2(90, 15) == 1.4056476493802699
  */
  fun atan2 (y : Number, x : Number) : Number {
    `Math.atan2(#{y}, #{x})`
  }

  /*
  Returns the inverse hyperbolic tangent of the angle in radians.

    Math.atanh(0.5) == 0.5493061443340548
  */
  fun atanh (angle : Number) : Number {
    `Math.atanh(#{angle})`
  }

  /*
  Returns the cubic root of the number.

    Math.cbrt(1) == 1
    Math.cbrt(64) == 4
  */
  fun cbrt (number : Number) : Number {
    `Math.cbrt(#{number})`
  }

  /*
  Returns the smallest integer greater than or equal to the number.

    Math.ceil(0.3) == 1
  */
  fun ceil (number : Number) : Number {
    `Math.ceil(#{number})`
  }

  /*
  Clamps the number between the upper and lower bounds.

    Math.clamp(100, 0, 10) == 10
    Math.clamp(-100, 0, 10) == 0
  */
  fun clamp (value : Number, lower : Number, upper : Number) : Number {
    Math.min(upper, Math.max(lower, value))
  }

  /*
  Returns the number of leading zero bits in the 32-bit binary representation
  of the number.

    // 00000000000000000000000000000100
    Math.clz32(4) == 29
  */
  fun clz32 (number : Number) : Number {
    `Math.clz32(#{number})`
  }

  /*
  Returns the cosine of the angle in radians.

    Math.cos(1) == 0.5403023058681398
  */
  fun cos (angle : Number) : Number {
    `Math.cos(#{angle})`
  }

  /*
  Returns the hyperbolic cosine of the angle in radians.

    Math.cosh(1) == 1.5430806348152437
  */
  fun cosh (angle : Number) : Number {
    `Math.cosh(#{angle})`
  }

  /*
  Returns the value of `Math.E` raised to the power x, where x is the number.

    Math.exp(1) == 2.718281828459045
  */
  fun exp (x : Number) : Number {
    `Math.exp(#{x})`
  }

  /*
  Returns the value of `Math.E` to the power x, minus 1.

    Math.exp(2) == 7.38905609893065
    Math.expm1(2) == 6.38905609893065
  */
  fun expm1 (x : Number) : Number {
    `Math.expm1(#{x})`
  }

  /*
  Returns the largest integer less than or equal to the number.

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

  /*
  Returns the nearest 32-bit single precision float representation of the
  number.

    Math.fround(1.337) == 1.3370000123977661
  */
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
  Returns natural logarithm (base e) of the value.

    Math.log(1) == 0
  */
  fun log (number : Number) : Number {
    `Math.log(#{number})`
  }

  /*
  Returns natural logarithm (base 10) of the value.

    Math.log10(100) == 10
  */
  fun log10 (number : Number) : Number {
    `Math.log10(#{number})`
  }

  /*
  Returns natural logarithm (base e) of the value, plus 1.

    Math.log1p(1) == 0
  */
  fun log1p (number : Number) : Number {
    `Math.log1p(#{number})`
  }

  /*
  Returns natural logarithm (base 2) of the value.

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
  Negates the number.

    Math.negate(1) == -1
  */
  fun negate (number : Number) : Number {
    `-#{number}`
  }

  /*
  Returns the exponent power of the number.

    Math.pow(2, 2) == 4
  */
  fun pow (value : Number, exponent : Number) : Number {
    `Math.pow(#{value}, #{exponent})`
  }

  /*
  Returns a pseudo-random number in the range 0 to less than 1.

    Math.random() // A random number between 0 and 1.
  */
  fun random : Number {
    `Math.random()`
  }

  /*
  Returns the value of a number rounded to the nearest decimal point (0 by
  default).

    Math.round(0.5) == 1
    Math.round(0.53, 1) == 0.5
  */
  fun round (number : Number, decimals : Number = 0) : Number {
    if decimals == 0 {
      `Math.round(#{number})`
    } else {
      `Math.round(#{number} * (10 * #{decimals})) / (10 * #{decimals})`
    }
  }

  /*
  Returns the sign of the number (1 or -1).

    Math.sign(5) == 1
    Math.sign(-5) == -1
  */
  fun sign (number : Number) : Number {
    `Math.sign(#{number})`
  }

  /*
  Calculates the sine of the angle in radians.

    Math.sin(1) == 0.8414709848078965
  */
  fun sin (angle : Number) : Number {
    `Math.sin(#{angle})`
  }

  /*
  Calculates the hyperbolic sine of the angle in radians.

    Math.sinh(1) == 1.1752011936438014
  */
  fun sinh (angle : Number) : Number {
    `Math.sinh(#{angle})`
  }

  /*
  Returns the square root of the number.

    Math.sqrt(4) == 2
  */
  fun sqrt (value : Number) : Number {
    `Math.sqrt(#{value})`
  }

  /*
  Calculates the tangent of the angle in radians.

    Math.tan(1) == 1.5574077246549023
  */
  fun tan (angle : Number) {
    `Math.tan(#{angle})`
  }

  /*
  Calculates the hyperbolic tangent of the angle in radians.

    Math.tanh(1) == 0.7615941559557649
  */
  fun tanh (angle : Number) : Number {
    `Math.tanh(#{angle})`
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
