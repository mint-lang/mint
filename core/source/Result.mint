enum Result(error, value) {
  Err(error)
  Ok(value)
}

/* Utility function for the `Result` type. */
module Result {
  /*
  Returns a new ok result.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun ok (input : a) : Result(b, a) {
    Result::Ok(input)
  }

  /*
  Returns a new error result.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun error (input : a) : Result(a, b) {
    Result::Err(input)
  }

  /*
  Returns the value of the given result or the default value if it's an error.

    (Result.error("error")
    |> Result.withDefault("a")) == "a"

    (Result.ok("ok")
    |> Result.withDefault("a")) == "ok"
  */
  fun withDefault (defaultValue : b, input : Result(a, b)) : b {
    case (input) {
      Result::Ok value => value
      Result::Err => defaultValue
    }
  }

  /*
  Returns the error of the given result or the default value if it's an ok.

    (Result.error("error")
    |> Result.withDefault("a")) == "error"

    (Result.ok("ok")
    |> Result.withDefault("a")) == "a"
  */
  fun withError (defaultError : a, input : Result(a, b)) : a {
    case (input) {
      Result::Err value => value
      Result::Ok => defaultError
    }
  }

  /*
  Maps over the value of the given result.

    (Result.error("error")
    |> Result.map(\item : String => item + "1")) == Result.error("error")

    (Result.ok("ok")
    |> Result.map(\item : String => item + "1")) == Result.ok("ok1")
  */
  fun map (func : Function(b, c), input : Result(a, b)) : Result(a, c) {
    case (input) {
      Result::Ok value => Result::Ok(func(value))
      Result::Err => input
    }
  }

  /*
  Maps over the error of the given result.

    (Result.error("error")
    |> Result.mapError(\item : String => item + "1")) == Result.error("error1")

    (Result.ok("ok")
    |> Result.mapError(\item : String => item + "1")) == Result.ok("ok")
  */
  fun mapError (func : Function(a, c), input : Result(a, b)) : Result(c, b) {
    case (input) {
      Result::Err value => Result::Err(func(value))
      Result::Ok => input
    }
  }

  /*
  Returns true if the result is ok.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun isOk (input : Result(a, b)) : Bool {
    case (input) {
      Result::Err => false
      Result::Ok => true
    }
  }

  /*
  Returns true if the result is an error.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun isError (input : Result(a, b)) : Bool {
    case (input) {
      Result::Err => true
      Result::Ok => false
    }
  }

  /*
  Converts the given result into a maybe.

    (Result.ok("blah")
    |> Result.toMaybe()) == Maybe.just("blah")

    (Result.error("blah")
    |> Result.toMaybe()) == Maybe.nothing()
  */
  fun toMaybe (result : Result(a, b)) : Maybe(b) {
    case (result) {
      Result::Ok value => Maybe::Just(value)
      Result::Err => Maybe::Nothing
    }
  }

  fun join (input : Result(error, Result(error, value))) : Result(error, value) {
    case (input) {
      Result::Ok value => value
      Result::Err => input
    }
  }

  fun flatMap (
    func : Function(a, Result(error, b)),
    input : Result(error, a)
  ) : Result(error, b) {
    Result.map(func, input)
    |> Result.join()
  }
}
