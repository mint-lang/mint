type Result(error, value) {
  Err(error)
  Ok(value)
}

/* Utility function for the `Result` type. */
module Result {
  /*
  Returns a new error result.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun error (input : a) : Result(a, b) {
    Result.Err(input)
  }

  /*
  Maps over the value of the result to an other result and flattens it.

    (Result.Err("error")
    |> Result.flatMap(\item : String => Result.Ok(item + "1"))) == Result.error("error")

    (Result.Ok("ok")
    |> Result.map(\item : String => Result.Ok(item + "1"))) == Result.ok("ok1")
  */
  fun flatMap (
    input : Result(error, a),
    func : Function(a, Result(error, b))
  ) : Result(error, b) {
    input
    |> Result.map(func)
    |> Result.join()
  }

  /*
  Returns true if the result is an error.

    (Result.Err("error")
    |> Result.isError()) == true
  */
  fun isError (input : Result(a, b)) : Bool {
    case input {
      Err => true
      Ok => false
    }
  }

  /*
  Returns true if the result is ok.

    (Result.Ok("ok")
    |> Result.isOk()) == true
  */
  fun isOk (input : Result(a, b)) : Bool {
    case input {
      Err => false
      Ok => true
    }
  }

  /*
  Joins two results together.

    Result.join(Result.Ok(Result.Ok("Hello"))) == Result.Ok("Hello")
    Result.join(Result.Err("Error") == Result.Err("Error")
  */
  fun join (input : Result(error, Result(error, value))) : Result(error, value) {
    case input {
      Err(error) => Result.Err(error)
      Ok(value) => value
    }
  }

  /*
  Maps over the value of the result.

    (Result.Err("error")
    |> Result.map(\item : String => item + "1")) == Result.Err("error")

    (Result.Ok("ok")
    |> Result.map(\item : String => item + "1")) == Result.Ok("ok1")
  */
  fun map (input : Result(a, b), func : Function(b, c)) : Result(a, c) {
    case input {
      Ok(value) => Result.Ok(func(value))
      Err => input
    }
  }

  /*
  Maps over the error of the result.

    (Result.Err("error")
    |> Result.mapError(\item : String => item + "1")) == Result.error("error1")

    (Result.Ok("ok")
    |> Result.mapError(\item : String => item + "1")) == Result.ok("ok")
  */
  fun mapError (input : Result(a, b), func : Function(a, c)) : Result(c, b) {
    case input {
      Err(value) => Result.Err(func(value))
      Ok => input
    }
  }

  /*
  Returns a new ok result.

    (Result.Ok("ok")
    |> Result.isOk()) == true
  */
  fun ok (input : a) : Result(b, a) {
    Result.Ok(input)
  }

  /*
  Converts the result into a maybe.

    (Result.Ok("blah")
    |> Result.toMaybe()) == Maybe.Just("blah")

    (Result.Err("blah")
    |> Result.toMaybe()) == Maybe.Nothing
  */
  fun toMaybe (result : Result(a, b)) : Maybe(b) {
    case result {
      Ok(value) => Maybe.Just(value)
      Err => Maybe.Nothing
    }
  }

  /*
  Returns the value of the result or the default value if it's an error.

    (Result.Err("error")
    |> Result.withDefault("a")) == "a"

    (Result.Ok("ok")
    |> Result.withDefault("a")) == "ok"
  */
  fun withDefault (input : Result(a, b), defaultValue : b) : b {
    case input {
      Ok(value) => value
      Err => defaultValue
    }
  }

  /*
  Returns the error of the result or the default value if it's an ok.

    (Result.Err("error")
    |> Result.withError("a")) == "error"

    (Result.Ok("ok")
    |> Result.withError("a")) == "a"
  */
  fun withError (input : Result(a, b), defaultError : a) : a {
    case input {
      Err(value) => value
      Ok => defaultError
    }
  }
}
