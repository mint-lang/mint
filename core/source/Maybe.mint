/* The data structure for Maybe. */
enum Maybe(value) {
  Just(value)
  Nothing
}

module Maybe {
  /*
  Maps the value of a maybe with a possibility to discard it.

    Maybe::Just(4)
    |> Maybe.andThen((num : Number) : Maybe(String) {
      if (num > 4) {
        Maybe::Just(Number.toString(num))
      } else {
        Maybe::Nothing
      }
    })
  */
  fun andThen (
    transform : Function(value, Maybe(result)),
    maybe : Maybe(value)
  ) : Maybe(result) {
    case (maybe) {
      Maybe::Just(value) => transform(value)
      Maybe::Nothing => Maybe::Nothing
    }
  }

  /*
  Flattens a nested maybe.

    (Maybe.just("A")
    |> Maybe.just()
    |> Maybe.flatten()) == Maybe.just("A")
  */
  fun flatten (maybe : Maybe(Maybe(value))) : Maybe(value) {
    case (maybe) {
      Maybe::Nothing => Maybe::Nothing
      Maybe::Just(value) => value
    }
  }

  /*
  Returns whether or not the maybe is just a value or not.

     Maybe.isJust(Maybe.just("A")) == true
     Maybe.isJust(Maybe.nothing()) == false
  */
  fun isJust (maybe : Maybe(value)) : Bool {
    maybe != Maybe::Nothing
  }

  /*
  Returns whether or not the maybe is just nothing or not.

    Maybe.isNothing(Maybe.just("A")) == false
    Maybe.isNothing(Maybe.nothing("A")) == false
  */
  fun isNothing (maybe : Maybe(value)) : Bool {
    maybe == Maybe::Nothing
  }

  /* Returns a maybe containing just the given value. */
  fun just (value : value) : Maybe(value) {
    Maybe::Just(value)
  }

  /*
  Maps the value of a maybe.

    (Maybe.just(1)
    |> Maybe.map((number : Number) : Number { number + 2 })) == 3
  */
  fun map (func : Function(value, result), maybe : Maybe(value)) : Maybe(result) {
    case (maybe) {
      Maybe::Just(value) => Maybe::Just(func(value))
      Maybe::Nothing => Maybe::Nothing
    }
  }

  /* Returns nothing. */
  fun nothing : Maybe(value) {
    Maybe::Nothing
  }

  /*
  Returns the first maybe with value of the array or nothing if all are nothing.

    Maybe.oneOf([Maybe.just("A"), Maybe.nothing()]) == Maybe.just("A")
  */
  fun oneOf (array : Array(Maybe(value))) : Maybe(value) {
    array
    |> Array.find((item : Maybe(value)) : Bool { Maybe.isJust(item) })
    |> flatten()
  }

  /*
  Converts the maybe to a result using the given value as the error.

    Maybe.toResult("Error", Maybe.nothing()) == Result.error("Error")
    Maybe.toResult("Error", Maybe.just("A")) == Result.ok("A")
  */
  fun toResult (error : error, maybe : Maybe(value)) : Result(error, value) {
    case (maybe) {
      Maybe::Just(value) => Result::Ok(value)
      Maybe::Nothing => Result::Err(error)
    }
  }

  /*
  Returns the value of a maybe or the given value if it's nothing.

    Maybe.withDefault("A", Maybe.nothing()) == "A"
    Maybe.withDefault("A", Maybe.just("B")) == "B"
  */
  fun withDefault (defaultValue : value, maybe : Maybe(value)) : value {
    maybe or defaultValue
  }

  /*
  Returns the value of a *maybe*, or calls the given *func* otherwise.

    Maybe.withLazyDefault(() { "A" }, Maybe.nothing()) == "A"
    Maybe.withLazyDefault(() { "A" }, Maybe.just("B")) == "B"
  */
  fun withLazyDefault (func : Function(value), maybe : Maybe(value)) : value {
    case (maybe) {
      Maybe::Nothing => func()
      Maybe::Just(value) => value
    }
  }
}
