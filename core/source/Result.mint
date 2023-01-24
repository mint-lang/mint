enum Result(error, value) {
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
    Result::Err(input)
  }

  /*
  Maps over the value of the result to an other result and flattens it.

    (Result.error("error")
    |> Result.flatMap(\item : String => Result::Ok(item + "1"))) == Result.error("error")

    (Result.ok("ok")
    |> Result.map(\item : String => Result::Ok(item + "1"))) == Result.ok("ok1")
  */
  fun flatMap (
    input : Result(error, a),
    func : Function(a, Result(error, b))
  ) : Result(error, b) {
    Result.map(input, func)
    |> Result.join()
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
  Joins two results together.

    Result.join(Result::Ok(Result::Ok("Hello"))) == Result::Ok("Hello")
    Result.join(Result::Err("Error") == Result::Err("Error")
  */
  fun join (input : Result(error, Result(error, value))) : Result(error, value) {
    case (input) {
      Result::Err(error) => Result::Err(error)
      Result::Ok(value) => value
    }
  }

  /*
  Maps over the value of the result.

    (Result.error("error")
    |> Result.map(\item : String => item + "1")) == Result.error("error")

    (Result.ok("ok")
    |> Result.map(\item : String => item + "1")) == Result.ok("ok1")
  */
  fun map (input : Result(a, b), func : Function(b, c)) : Result(a, c) {
    case (input) {
      Result::Ok(value) => Result::Ok(func(value))
      Result::Err => input
    }
  }

  /*
  Maps over the error of the result.

    (Result.error("error")
    |> Result.mapError(\item : String => item + "1")) == Result.error("error1")

    (Result.ok("ok")
    |> Result.mapError(\item : String => item + "1")) == Result.ok("ok")
  */
  fun mapError (input : Result(a, b), func : Function(a, c)) : Result(c, b) {
    case (input) {
      Result::Err(value) => Result::Err(func(value))
      Result::Ok => input
    }
  }

  /*
  Returns a new ok result.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun ok (input : a) : Result(b, a) {
    Result::Ok(input)
  }

  /*
  Converts the result into a maybe.

    (Result.ok("blah")
    |> Result.toMaybe()) == Maybe.just("blah")

    (Result.error("blah")
    |> Result.toMaybe()) == Maybe.nothing()
  */
  fun toMaybe (result : Result(a, b)) : Maybe(b) {
    case (result) {
      Result::Ok(value) => Maybe::Just(value)
      Result::Err => Maybe::Nothing
    }
  }

  /*
  Returns the value of the result or the default value if it's an error.

    (Result.error("error")
    |> Result.withDefault("a")) == "a"

    (Result.ok("ok")
    |> Result.withDefault("a")) == "ok"
  */
  fun withDefault (input : Result(a, b), defaultValue : b) : b {
    case (input) {
      Result::Ok(value) => value
      Result::Err => defaultValue
    }
  }

  /*
  Returns the error of the result or the default value if it's an ok.

    (Result.error("error")
    |> Result.withError("a")) == "error"

    (Result.ok("ok")
    |> Result.withError("a")) == "a"
  */
  fun withError (input : Result(a, b), defaultError : a) : a {
    case (input) {
      Result::Err(value) => value
      Result::Ok => defaultError
    }
  }
}
