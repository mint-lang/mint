/* Data structure for a computation that can fail. */
type Result(error, value) {
  Err(error)
  Ok(value)
}

/* This module provides functions for working with the `Result` type. */
module Result {
  /*
  Returns an `Err` result wit the the error.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun error (error : a) : Result(a, b) {
    Result.Err(error)
  }

  /*
  Maps over the value of the result to an other result and flattens it.

    (Result.Err("error")
    |> Result.flatMap((item : String) { Result.Ok(item + "1") })) == Result.Err("error")

    (Result.Ok("ok")
    |> Result.map((item : String) { Result.Ok(item + "1") })) == Result.Ok("ok1")
  */
  fun flatMap (
    result : Result(error, a),
    function : Function(a, Result(error, b))
  ) : Result(error, b) {
    result
    |> Result.map(function)
    |> Result.flatten()
  }

  /*
  Returns `true` if the result is an `Err`.

    (Result.Err("error")
    |> Result.isError()) == true
  */
  fun isError (result : Result(a, b)) : Bool {
    case result {
      Err => true
      Ok => false
    }
  }

  /*
  Returns `true` if the result is an `Ok`.

    (Result.Ok("ok")
    |> Result.isOk()) == true
  */
  fun isOk (result : Result(a, b)) : Bool {
    case result {
      Err => false
      Ok => true
    }
  }

  /*
  Flattens a nested result (where the other result is in an `Ok`).

    Result.flatten(Result.Ok(Result.Ok("Hello"))) == Result.Ok("Hello")
    Result.flatten(Result.Err("Error")) == Result.Err("Error")
  */
  fun flatten (result : Result(error, Result(error, value))) : Result(error, value) {
    case result {
      Err(error) => Result.Err(error)
      Ok(value) => value
    }
  }

  /*
  Apply a function to a result. If the result is `Ok`, it will be converted.
  If the result is an `Err`, the same error value will propagate through.

    (Result.Err("error")
    |> Result.map((item : String) { item + "1" })) == Result.Err("error")

    (Result.Ok("ok")
    |> Result.map((item : String) { item + "1" })) == Result.Ok("ok1")
  */
  fun map (result : Result(a, b), function : Function(b, c)) : Result(a, c) {
    case result {
      Ok(value) => Result.Ok(function(value))
      Err => result
    }
  }

  /*
  Transform an `Err` value.

    (Result.Err("error")
    |> Result.mapError((item : String) { item + "1" })) == Result.Err("error1")

    (Result.Ok("ok")
    |> Result.mapError((item : String) { item + "1" })) == Result.Ok("ok")
  */
  fun mapError (result : Result(a, b), function : Function(a, c)) : Result(c, b) {
    case result {
      Err(value) => Result.Err(function(value))
      Ok => result
    }
  }

  /*
  Returns an `Ok` result with the input.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun ok (input : a) : Result(b, a) {
    Result.Ok(input)
  }

  /*
  Convert to a simpler `Maybe` if the actual error message is not needed or you
  need to interact with some code that primarily uses maybes.

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
  If the result is `Ok` return the value, but if the result is an `Err` then
  return a given default value.

    (Result.Err("error")
    |> Result.withDefault("a")) == "a"

    (Result.Ok("ok")
    |> Result.withDefault("a")) == "ok"
  */
  fun withDefault (result : Result(a, b), defaultValue : b) : b {
    case result {
      Ok(value) => value
      Err => defaultValue
    }
  }

  /*
  If the result is `Err` return the error, but if the result is an `Ok` then
  return a given default error.

    (Result.Err("error")
    |> Result.withError("a")) == "error"

    (Result.Ok("ok")
    |> Result.withError("a")) == "a"
  */
  fun withError (result : Result(a, b), defaultError : a) : a {
    case result {
      Err(value) => value
      Ok => defaultError
    }
  }
}
