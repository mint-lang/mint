/* Represent values that may or may not exist. */
type Maybe(value) {
  Just(value)
  Nothing
}

/* This module provides functions to work with the `Maybe` type. */
module Maybe {
  /*
  Maps the value of a maybe with a possibility to discard it.

    Maybe.andThen(Maybe.Just(4), (num : Number) : Maybe(String) {
      if (num > 4) {
        Maybe.Just(Number.toString(num))
      } else {
        Maybe.Nothing
      }
    })
  */
  fun andThen (
    maybe : Maybe(value),
    function : Function(value, Maybe(result))
  ) : Maybe(result) {
    case maybe {
      Just(value) => function(value)
      Nothing => Maybe.Nothing
    }
  }

  /*
  Flattens a nested maybe.

    (Maybe.Just("A")
    |> Maybe.Just
    |> Maybe.flatten) == Maybe.Just("A")
  */
  fun flatten (maybe : Maybe(Maybe(value))) : Maybe(value) {
    case maybe {
      Nothing => Maybe.Nothing
      Just(value) => value
    }
  }

  /*
  Returns whether the maybe is just a value.

    Maybe.isJust(Maybe.Just("A")) == true
    Maybe.isJust(Maybe.Nothing) == false
  */
  fun isJust (maybe : Maybe(value)) : Bool {
    maybe != Maybe.Nothing
  }

  /*
  Returns whether the maybe is nothing.

    Maybe.isNothing(Maybe.Nothing("A")) == false
    Maybe.isNothing(Maybe.Just("A")) == false
  */
  fun isNothing (maybe : Maybe(value)) : Bool {
    maybe == Maybe.Nothing
  }

  /*
  Returns a maybe containing just the value.

    Maybe.just("A") == Maybe.Just("A")
  */
  fun just (value : value) : Maybe(value) {
    Maybe.Just(value)
  }

  /*
  Maps the value of a maybe.

    Maybe.map(
      Maybe.Just(1),
      (number : Number) { number + 2 })) == Maybe.Just(3)
  */
  fun map (
    maybe : Maybe(value),
    function : Function(value, result)
  ) : Maybe(result) {
    case maybe {
      Just(value) => Maybe.Just(function(value))
      Nothing => Maybe.Nothing
    }
  }

  /*
  Returns nothing.

    Maybe.nothing() == Maybe.Nothing
  */
  fun nothing : Maybe(value) {
    Maybe.Nothing
  }

  /*
  Returns the first maybe with a value or nothing if all are nothing.

    Maybe.oneOf([Maybe.Just("A"), Maybe.Nothing]) == Maybe.just("A")
  */
  fun oneOf (array : Array(Maybe(value))) : Maybe(value) {
    array
    |> Array.find(Maybe.isJust)
    |> flatten()
  }

  /*
  Converts the maybe to a result using the value as the error.

    Maybe.toResult(Maybe.Nothing, "Error") == Result.Error("Error")
    Maybe.toResult(Maybe.Just("A"), "Error") == Result.Ok("A")
  */
  fun toResult (maybe : Maybe(value), error : error) : Result(error, value) {
    case maybe {
      Just(value) => Result.Ok(value)
      Nothing => Result.Err(error)
    }
  }

  /*
  Returns the value of a maybe or the given value if it's nothing.

    Maybe.withDefault(Maybe.Just("B"), "A") == "B"
    Maybe.withDefault(Maybe.Nothing, "A") == "A"
  */
  fun withDefault (maybe : Maybe(value), defaultValue : value) : value {
    maybe or defaultValue
  }

  /*
  Returns the value of a maybe, or calls the given function otherwise.

    Maybe.withLazyDefault(Maybe.Just("B"), () { "A" }) == "B"
    Maybe.withLazyDefault(Maybe.Nothing, () { "A" }) == "A"
  */
  fun withLazyDefault (maybe : Maybe(value), function : Function(value)) : value {
    case maybe {
      Just(value) => value
      Nothing => function()
    }
  }
}
