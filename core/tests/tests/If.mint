suite "If" {
  test "unboxes Maybe" {
    let item =
      Maybe.Just("Hello")

    if item {
      item == "Hello"
    } else {
      false
    }
  }

  test "unboxes Result" {
    let item =
      Result.Ok("Hello")

    if item {
      item == "Hello"
    } else {
      false
    }
  }

  test "checks Maybe" {
    if Maybe.Just("Hello") {
      true
    } else {
      false
    }
  }

  test "checks Result" {
    if Result.Ok("Hello") {
      true
    } else {
      false
    }
  }

  test "checks Html" {
    if <></> {
      false
    } else {
      true
    }
  }

  test "checks Html" {
    if <div/> {
      true
    } else {
      false
    }
  }
}
