/* A module for writing complex tests. */
module Test.Context {
  /*
  Starts a test using the given value.

    test {
      Test.Context.of(5)
      |> Test.Context.assertEqual(5)
    }
  */
  fun of (a : a) : Test.Context(a) {
    `new TestContext(#{a})`
  }

  /*
  Adds a transformation step to the test.

    test {
      Test.Context.of(5)
      |> Test.Context.then((number : Number) { Promise.resolve(number + 2) })
      |> Test.Context.assertEqual(7)
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
  Adds a timeout to the test using the given duration (in milliseconds).

    test {
      Test.Context.of(5)
      |> Test.Context.timeout(1000)
      |> Test.Context.assertEqual(5)
    }
  */
  fun timeout (duration : Number, context : Test.Context(a)) : Test.Context(a) {
    context
    |> then((subject : a) : Promise(Never, a) { Timer.timeout(duration, subject) })
  }

  /*
  Asserts the equality of the current value of the test with the given one.

    test {
      Test.Context.of(5)
      |> Test.Context.assertEqual(5)
    }
  */
  fun assertEqual (value : a, context : Test.Context(a)) : Test.Context(a) {
    `
    #{context}.step((subject) => {
      if (!_compare(#{value}, subject)) {
        throw \`Assertion failed: ${#{value}} === ${subject}\`
      }
      return subject
    })
    `
  }

  /*
  Asserts if the given value equals of the returned value from the given
  function.

    test {
      Test.Context.of(5)
      |> Test.Context.assertOf("5", Number.toString)
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

      if (!_compare(#{value}, actual)) {
        throw \`Assertion failed: ${actual} === ${#{value}}\`
      }
      return subject
    })
    `
  }

  /*
  Maps the given subject to a new subject.

    test {
      Test.Context.of(5)
      |> Test.Context.map(Number.toString)
    }
  */
  fun map (method : Function(a, b), context : Test.Context(a)) : Test.Context(b) {
    context
    |> then((item : a) : Promise(Never, b) { Promise.resolve(method(item)) })
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
