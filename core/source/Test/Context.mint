/* A module for writing complex tests. */
module Test.Context {
  /*
  Starts a test using the given value.

    test {
      with Test.Context {
        of(5)
        |> assertEqual(5)
      }
    }
  */
  fun of (a : a) : Test.Context(a) {
    `new TestContext(#{a})`
  }

  /*
  Adds a transformation step to the test.

    test {
      with Test.Context {
        of(5)
        |> then((number : Number) { Promise.resolve(number + 2) })
        |> assertEqual(7)
      }
    }
  */
  fun then (
    proc : Function(a, Promise(b, c)),
    context : Test.Context(a)
  ) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      return #{proc}(subject)
    })
    `
  }

  /*
  Adds a timeout to the text using the given duration (in milliseconds).

    test {
      with Test.Context {
        of(5)
        |> timeout(1000)
        |> assertEqual(5)
      }
    }
  */
  fun timeout (duration : Number, context : Test.Context(a)) : Test.Context(a) {
    then(
      (subject : a) : Promise(Never, a) { Timer.timeout(duration, subject) },
      context)
  }

  /*
  Asserts the equality of the current value of the test with the given one.

    test {
      with Test.Context {
        of(5)
        |> assertEqual(5)
      }
    }
  */
  fun assertEqual (value : a, context : Test.Context(a)) : Test.Context(a) {
    `
    #{context}.step((subject)=> {
      let result = _compare(#{value}, subject)

      if (result) {
        return subject
      } else {
        throw \`Assertion failed ${#{value}} === ${subject}\`
      }
    })
    `
  }

  /*
  Asserts if the given value equals of the returned value from the given
  function.

    with Test.Context {
      of(5)
      |> assertOf("5", Number.toString)
    }
  */
  fun assertOf (
    value : b,
    method : Function(a, b),
    context : Test.Context(a)
  ) : Test.Context(a) {
    `
    #{context}.step((subject) => {
      const actual = #{method}(subject)

      if (_compare(actual, #{value})) {
        return subject
      } else {
        throw \`Assertion failed ${actual} == ${value}\`
      }
    })
    `
  }

  /*
  Asserts that the current subject does not equal to the given value.

    test {
      with Test.Context {
        of(5)
        |> assertNotEqual(6)
      }
    }
  */
  fun assertNotEqual(value : a, context : Test.Context(a)) : Test.Context(a) {
    then((subject : a) : Promise(String, a) {
      if (subject == value) {
        Promise.reject(`\`Assertion failed ${#{subject}} != ${#{value}}\``)
      } else {
        Promise.resolve(subject)
      }
    }, context)
  }

  /*
  Maps the given subject to a new subject.

    test {
      with Test.Context {
        of(5)
        |> map(Number.toString)
      }
    }
  */
  fun map (method : Function(a, b), context : Test.Context(a)) : Test.Context(b) {
    then(
      (item : a) : Promise(Never, b) { Promise.resolve(method(item)) },
      context)
  }

  /* Spies on the given entity if it's a function. */
  fun spyOn (entity : a) : a {
    `
    (() => {
      if (typeof #{entity} == "function") {
        let _

        _ = function (...args) {
          _._called = true
          return #{entity}(...args)
        }

        return _
      } else {
        return #{entity}
      }
    })()
    `
  }

  /* Asserts that a given spy (function) was called. */
  fun assertFunctionCalled (entity : a, context : Test.Context(c)) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      if (!#{entity}._called) {
        throw "The given function was not called!"
      }
      return subject
    })
    `
  }

  /* Asserts that a given spy (function) was not called. */
  fun assertFunctionNotCalled (entity : a, context : Test.Context(c)) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      if (#{entity}._called) {
        throw "The given function was called!"
      }
      return subject
    })
    `
  }
}
