module Maybe {
  /* Returns nothing. */
  fun nothing : Maybe(a) {
    `new Nothing`
  }

  /* Returns a maybe containing just the given value. */
  fun just (value : a) : Maybe(a) {
    `new Just(value)`
  }

  /*
  Returns whether or not the maybe is just a value or not.

     Maybe.isJust(Maybe.just("A")) == true
     Maybe.isJust(Maybe.nothing()) == false
  */
  fun isJust (maybe : Maybe(a)) : Bool {
    `maybe instanceof Just`
  }

  /*
  Returns whether or not the maybe is just nothing or not.

    Maybe.isNothing(Maybe.just("A")) == false
    Maybe.isNothing(Maybe.nothing("A")) == false
  */
  fun isNothing (maybe : Maybe(a)) : Bool {
    `maybe instanceof Nothing`
  }

  /*
  Maps the value of a maybe.

    (Maybe.just(1)
    |> Maybe.map((number : Number) : Number { number + 2 })) == 3
  */
  fun map (func : Function(a, b), maybe : Maybe(a)) : Maybe(b) {
    `
    (() => {
     	if (maybe instanceof Just) {
     		return new Just(func(maybe.value))
     	} else {
     		return maybe
     	}
    })()
    `
  }

  /*
  Returns the value of a maybe or the given value if it's nothing.

    Maybe.withDefault("A", Maybe.nothing()) == "A"
    Maybe.withDefault("A", Maybe.just("B")) == "B"
  */
  fun withDefault (value : a, maybe : Maybe(a)) : a {
    `
    (() => {
    	if (maybe instanceof Just) {
    		return maybe.value
    	} else {
    		return value
    	}
    })()
    `
  }

  /*
  Converts the maybe to a result using the given value as the error.

    Maybe.toResult("Error", Maybe.nothing()) == Result.error("Error")
    Maybe.toResult("Error", Maybe.just("A")) == Result.ok("A")
  */
  fun toResult (error : b, maybe : Maybe(a)) : Result(b, a) {
    `
    (() => {
      if (maybe instanceof Just) {
        return new Ok(maybe.value)
      } else {
        return new Err(error)
      }
    })()
    `
  }

  /*
  Flattens a nested maybe.

    (Maybe.just("A")
    |> Maybe.just()
    |> Maybe.flatten()) == Maybe.just("A")
  */
  fun flatten (maybe : Maybe(Maybe(a))) : Maybe(a) {
    `
    (() => {
      if (maybe instanceof Just) {
        return maybe.value
      } else {
        return maybe
      }
    })()
    `
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
}
