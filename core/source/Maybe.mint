/* The data structure for Maybe. */
type Maybe(value) {
  Just(value)
  Nothing
}

module Maybe {
  /*
  Maps the value of a maybe with a possibility to discard it.

    Maybe.Just(4)
    |> Maybe.andThen((num : Number) : Maybe(String) {
      if (num > 4) {
        Maybe.Just(Number.toString(num))
      } else {
        Maybe.Nothing
      }
    })
  */
  fun andThen (
    maybe : Maybe(value),
    transform : Function(value, Maybe(result))
  ) : Maybe(result) {
    case maybe {
      Just(value) => transform(value)
      Nothing => Maybe.Nothing
    }
  }

  /*
  Flattens a nested maybe.

    (Maybe.Just("A")
    |> Maybe.Just()
    |> Maybe.flatten()) == Maybe.Just("A")
  */
  fun flatten (maybe : Maybe(Maybe(value))) : Maybe(value) {
    case maybe {
      Nothing => Maybe.Nothing
      Just(value) => value
    }
  }

  /*
  Returns whether or not the maybe is just a value or not.

     Maybe.isJust(Maybe.Just("A")) == true
     Maybe.isJust(Maybe.Nothing) == false
  */
  fun isJust (maybe : Maybe(value)) : Bool {
    maybe != Maybe.Nothing
  }

  /*
  Returns whether or not the maybe is just nothing or not.

    Maybe.isNothing(Maybe.Just("A")) == false
    Maybe.isNothing(Maybe.Nothing("A")) == false
  */
  fun isNothing (maybe : Maybe(value)) : Bool {
    maybe == Maybe.Nothing
  }

  /* Returns a maybe containing just the given value. */
  fun just (value : value) : Maybe(value) {
    Maybe.Just(value)
  }

  /*
  Maps the value of a maybe.

    (Maybe.Just(1)
    |> Maybe.map((number : Number) : Number { number + 2 })) == 3
  */
  fun map (maybe : Maybe(value), func : Function(value, result)) : Maybe(result) {
    case maybe {
      Just(value) => Maybe.Just(func(value))
      Nothing => Maybe.Nothing
    }
  }

  /* Returns nothing. */
  fun nothing : Maybe(value) {
    Maybe.Nothing
  }

  /*
  Returns the first maybe with value of the array or nothing if all are nothing.

    Maybe.oneOf([Maybe.Just("A"), Maybe.Nothing]) == Maybe.just("A")
  */
  fun oneOf (array : Array(Maybe(value))) : Maybe(value) {
    array
    |> Array.find(Maybe.isJust)
    |> flatten()
  }

  /*
  Converts the maybe to a result using the given value as the error.

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

    Maybe.withDefault(Maybe.Nothing, "A") == "A"
    Maybe.withDefault(Maybe.Just("B"), "A") == "B"
  */
  fun withDefault (maybe : Maybe(value), defaultValue : value) : value {
    maybe or defaultValue
  }

  /*
  Returns the value of a *maybe*, or calls the given *func* otherwise.

    Maybe.withLazyDefault(Maybe.nothing(), () { "A" }) == "A"
    Maybe.withLazyDefault(Maybe.just("B"), () { "A" }) == "B"
  */
  fun withLazyDefault (maybe : Maybe(value), func : Function(value)) : value {
    case maybe {
      Just(value) => value
      Nothing => func()
    }
  }
}
