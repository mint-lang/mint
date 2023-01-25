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
