suite "Math.negate" {
  test "negates positive numbers" {
    Math.negate(1) == -1
  }

  test "negates negative numbers" {
    Math.negate(-1) == 1
  }
}

suite "Math.abs" {
  test "returns the absolute value of a number" {
    Math.abs(-100) == 100
  }
}

suite "Math.ceil" {
  test "returns the ceiling of a float" {
    Math.ceil(0.1) == 1
  }
}

suite "Math.floor" {
  test "returns the floor of a float" {
    Math.floor(0.9) == 0
  }
}

suite "Math.round" {
  test "rounds up correctly" {
    Math.round(0.51) == 1
  }

  test "rounds down correctly" {
    Math.round(0.49) == 0
  }
}

suite "Math.min" {
  test "returns the lower number" {
    Math.min(0, 1) == 0
  }
}

suite "Math.max" {
  test "returns the higher number" {
    Math.max(0, 1) == 1
  }
}

suite "Math.sqrt" {
  test "returns the square root" {
    Math.sqrt(4) == 2
  }
}

suite "Math.pow" {
  test "returns the exponent power" {
    Math.pow(2, 2) == 4
  }
}

suite "Math.clamp" {
  test "it clamps to lower bound" {
    Math.clamp(-100, 0, 10) == 0
  }

  test "it clamps to upper bound" {
    Math.clamp(100, 0, 10) == 10
  }
}

suite "Math.fmod" {
  test "it returns the float remainder of two numbers" {
    Math.fmod(2, 5.3) == 1.3
  }

  test "it returns the float remainder of two numbers #2" {
    Math.fmod(4.2, 18.5) == 1.7
  }
}

suite "Math.truncate" {
  test "it truncates number to given amount" {
    Math.trunc(13.37) == 13
  }
}

suite "Math.truncate" {
  test "it truncates number to given amount" {
    Math.truncate(0.123456, 2) == 0.12
  }
}

suite "Math.random" {
  test "it returns a pseudo-random number in the range 0 to less than 1" {
    let n =
      Math.random()

    n >= 0.0 && n < 1.0
  }
}

suite "Math.E" {
  test "returns Math.E" {
    Math.E == `Math.E`
  }
}

suite "Math.LN2" {
  test "returns Math.LN2" {
    Math.LN2 == `Math.LN2`
  }
}

suite "Math.LN10" {
  test "returns Math.LN10" {
    Math.LN10 == `Math.LN10`
  }
}

suite "Math.LOG2E" {
  test "returns Math.LOG2E" {
    Math.LOG2E == `Math.LOG2E`
  }
}

suite "Math.LOG10E" {
  test "returns Math.LOG10E" {
    Math.LOG10E == `Math.LOG10E`
  }
}

suite "Math.PI" {
  test "returns Math.PI" {
    Math.PI == `Math.PI`
  }
}

suite "Math.SQRT12" {
  test "returns Math.SQRT12" {
    Math.SQRT12 == `Math.SQRT1_2`
  }
}

suite "Math.SQRT2" {
  test "returns Math.SQRT2" {
    Math.SQRT2 == `Math.SQRT2`
  }
}

suite "Math.acos" {
  test "it returns the inverse cosine of an angle in radians" {
    Math.acos(1) == `Math.acos(1)`
  }
}

suite "Math.acosh" {
  test "it returns the inverse hyperbolic cosine of an angle in radians" {
    Math.acosh(1) == `Math.acosh(1)`
  }
}

suite "Math.asin" {
  test "it returns the inverse sine of an angle in radians" {
    Math.asin(1) == `Math.asin(1)`
  }
}

suite "Math.asinh" {
  test "it returns the inverse hyperbolic sine of an angle in radians" {
    Math.asinh(1) == `Math.asinh(1)`
  }
}

suite "Math.atan" {
  test "it returns the inverse tangent of an angle in radians" {
    Math.atan(1) == `Math.atan(1)`
  }
}

suite "Math.atan2" {
  test "it returns the angle in the plane (in radians) between the positive x-axis and the ray from (0, 0) to the point (x, y)" {
    Math.atan2(3, 4) == `Math.atan2(3, 4)`
  }
}

suite "Math.atanh" {
  test "it returns the inverse hyperbolic tangent of an angle in radians" {
    Math.atanh(1) == `Math.atanh(1)`
  }
}

suite "Math.cbrt" {
  test "it returns the cubic root" {
    Math.cbrt(8) == `Math.cbrt(8)`
  }
}

suite "Math.clz32" {
  test "it returns the sin of an angle in radians" {
    Math.clz32(4) == `Math.clz32(4)`
  }
}

suite "Math.cos" {
  test "it returns the cosine of an angle in radians" {
    Math.cos(1) == `Math.cos(1)`
  }
}

suite "Math.cosh" {
  test "it returns the hyperbolic cosine of an angle in radians" {
    Math.cosh(1) == `Math.cosh(1)`
  }
}

suite "Math.exp" {
  test "it returns e raised to the power of x, where x is the number provided" {
    Math.exp(2) == `Math.exp(2)`
  }
}

suite "Math.expm1" {
  test "it returns e raised to the power of x - 1, where x is the number provided" {
    Math.expm1(2) == `Math.expm1(2)`
  }
}

suite "Math.fround" {
  test "returns the nearest 32-bit single precision float representation of a number" {
    Math.fround(5.5) == `Math.fround(5.5)`
    Math.fround(5.05) == `Math.fround(5.05)`
  }
}

suite "Math.hypot" {
  test "returns the square root of the sum of squares of two numbers" {
    Math.hypot(3, 4) == 5
  }
}

suite "Math.imul" {
  test "multiples two numbers using C-like 32-bit multiplication" {
    Math.imul(-5, 12) == -60
  }
}

suite "Math.log" {
  test "returns the natural log (base e) of a number" {
    Math.log(Math.E) == 1
  }
}

suite "Math.log1p" {
  test "returns the natural log (base e) of x + 1, where x is the provided value" {
    Math.log1p(Math.E) == `Math.log1p(#{Math.E})`
  }
}

suite "Math.log2" {
  test "returns the natural log (base 2) of a number" {
    Math.log2(8) == 3
  }
}

suite "Math.log10" {
  test "it returns the natural log (base 10) of a number" {
    Math.log10(100) == 2
  }
}

suite "Math.sign" {
  test "it returns the sign (1 or -1) of a number" {
    Math.sign(5) == 1
  }

  test "it returns the sign (1 or -1) of a number #2" {
    Math.sign(-5) == -1
  }
}
