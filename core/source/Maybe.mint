enum Maybe(a) {
  Nothing
  Just(a)
}

module Maybe {
  /* Returns nothing. */
  fun nothing : Maybe(a) {
    Maybe::Nothing
  }

  /* Returns a maybe containing just the given value. */
  fun just (value : a) : Maybe(a) {
    Maybe::Just(value)
  }

  /*
  Returns whether or not the maybe is just a value or not.

     Maybe.isJust(Maybe.just("A")) == true
     Maybe.isJust(Maybe.nothing()) == false
  */
  fun isJust (maybe : Maybe(a)) : Bool {
    case (maybe) {
      Maybe::Nothing => false
      Maybe::Just => true
    }
  }

  /*
  Returns whether or not the maybe is just nothing or not.

    Maybe.isNothing(Maybe.just("A")) == false
    Maybe.isNothing(Maybe.nothing("A")) == false
  */
  fun isNothing (maybe : Maybe(a)) : Bool {
    case (maybe) {
      Maybe::Nothing => true
      Maybe::Just => false
    }
  }

  /*
  Maps the value of a maybe.

    (Maybe.just(1)
    |> Maybe.map((number : Number) : Number { number + 2 })) == 3
  */
  fun map (func : Function(a, b), maybe : Maybe(a)) : Maybe(b) {
    case (maybe) {
      Maybe::Just value => Maybe::Just(func(value))
      Maybe::Nothing => Maybe::Nothing
    }
  }

  /*
  Returns the value of a maybe or the given value if it's nothing.

    Maybe.withDefault("A", Maybe.nothing()) == "A"
    Maybe.withDefault("A", Maybe.just("B")) == "B"
  */
  fun withDefault (defaultValue : a, maybe : Maybe(a)) : a {
    case (maybe) {
      Maybe::Nothing => defaultValue
      Maybe::Just value => value
    }
  }

  /*
  Converts the maybe to a result using the given value as the error.

    Maybe.toResult("Error", Maybe.nothing()) == Result.error("Error")
    Maybe.toResult("Error", Maybe.just("A")) == Result.ok("A")
  */
  fun toResult (error : b, maybe : Maybe(a)) : Result(b, a) {
    case (maybe) {
      Maybe::Just value => Result::Ok(value)
      Maybe::Nothing => Result::Err(error)
    }
  }

  /*
  Flattens a nested maybe.

    (Maybe.just("A")
    |> Maybe.just()
    |> Maybe.flatten()) == Maybe.just("A")
  */
  fun flatten (maybe : Maybe(Maybe(a))) : Maybe(a) {
    case (maybe) {
      Maybe::Nothing => Maybe::Nothing
      Maybe::Just value => value
    }
  }

  /*
  Returns the first maybe with value of the array or nothing
  if it's all nothing.

    Maybe.oneOf([Maybe.just("A"), Maybe.nothing()]) == Maybe.just("A")
  */
  fun oneOf (array : Array(Maybe(a))) : Maybe(a) {
    array
    |> Array.find((item : Maybe(a)) : Bool { Maybe.isJust(item) })
    |> flatten()
  }

  /*
  Maps the value of a maybe with a possibility to discard it.

    Maybe::Just(4)
    |> Maybe.andThen((num : Number) : Maybe(String) {
      if (num > 4) {
        Maybe::Just(Number.toString(num))
      }
      else {
        Maybe::Nothing
      }
    })
  */
  fun andThen (transform : Function(a, Maybe(b)), maybe : Maybe(a)) : Maybe(b) {
    case (maybe) {
      Maybe::Just value => transform(value)
      Maybe::Nothing => Maybe::Nothing
    }
  }
}
