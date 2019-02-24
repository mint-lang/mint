/* Utility function for the `Result` type. */
module Result {
  /*
  Returns a new ok result.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun ok (input : a) : Result(b, a) {
    `new Ok(input)`
  }

  /*
  Returns a new error result.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun error (input : a) : Result(a, b) {
    `new Err(input)`
  }

  /*
  Returns the value of the given result or the default value if it's an error.

    (Result.error("error")
    |> Result.withDefault("a")) == "a"

    (Result.ok("ok")
    |> Result.withDefault("a")) == "ok"
  */
  fun withDefault (value : b, input : Result(a, b)) : b {
    `input instanceof Ok ? input.value : value`
  }

  /*
  Returns the error of the given result or the default value if it's an ok.

    (Result.error("error")
    |> Result.withDefault("a")) == "error"

    (Result.ok("ok")
    |> Result.withDefault("a")) == "a"
  */
  fun withError (value : a, input : Result(a, b)) : a {
    `input instanceof Err ? input.value : value`
  }

  /*
  Maps over the value of the given result.

    (Result.error("error")
    |> Result.map(\item : String => item + "1")) == Result.error("error")

    (Result.ok("ok")
    |> Result.map(\item : String => item + "1")) == Result.ok("ok1")
  */
  fun map (func : Function(b, c), input : Result(a, b)) : Result(a, c) {
    `input instanceof Ok ? new Ok(func(input.value)) : input`
  }

  /*
  Maps over the error of the given result.

    (Result.error("error")
    |> Result.mapError(\item : String => item + "1")) == Result.error("error1")

    (Result.ok("ok")
    |> Result.mapError(\item : String => item + "1")) == Result.ok("ok")
  */
  fun mapError (func : Function(a, c), input : Result(a, b)) : Result(c, b) {
    `input instanceof Err ? new Err(func(input.value)) : input`
  }

  /*
  Returns true if the result is ok.

    (Result.ok("ok")
    |> Result.isOk()) == true
  */
  fun isOk (input : Result(a, b)) : Bool {
    `input instanceof Ok`
  }

  /*
  Returns true if the result is an error.

    (Result.error("error")
    |> Result.isError()) == true
  */
  fun isError (input : Result(a, b)) : Bool {
    `input instanceof Err`
  }

  /*
  Converts the given result into a maybe.

    (Result.ok("blah")
    |> Result.toMaybe()) == Maybe.just("blah")

    (Result.error("blah")
    |> Result.toMaybe()) == Maybe.nothing()
  */
  fun toMaybe (result : Result(a, b)) : Maybe(b) {
    `
    (() => {
      if (result instanceof Ok) {
        return new Just(result.value)
      } else {
        return new Nothing()
      }
    })()
    `
  }

  fun join (input : Result(error, Result(error, value))) : Result(error, value) {
    if (Result.isOk(input)) {
      `input.value`
    } else {
      `new Err()`
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
