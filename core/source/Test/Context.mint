/* A module for writing complex tests. */
module Test.Context {
  /*
  Asserts the equality of the current value of the test with the given one.

    test {
      Test.Context.of(5)
      |> Test.Context.assertEqual(5)
    }
  */
  fun assertEqual (context : Test.Context(a), value : a) : Test.Context(a) {
    `
    #{context}.step((subject) => {
      if (!#{%compare%}(#{value}, subject)) {
        throw \`Assertion failed: ${#{value}} === ${subject}\`
      }
      return subject
    })
    `
  }

  /* Asserts that a given spy (function) was called. */
  fun assertFunctionCalled (context : Test.Context(c), entity : a) : Test.Context(c) {
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
  fun assertFunctionNotCalled (context : Test.Context(c), entity : a) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      if (#{entity}._called) {
        throw "The given function was called!"
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
    context : Test.Context(a),
    value : b,
    method : Function(a, b)
  ) : Test.Context(a) {
    `
    #{context}.step((subject) => {
      const actual = #{method}(subject)

      if (!#{%compare%}(#{value}, actual)) {
        throw \`Assertion failed: ${actual} === ${#{value}}\`
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
      |> Test.Context.assert((value : Number) { value == 5 })
    }
  */
  fun assert (
    context : Test.Context(a),
    method : Function(a, bool)
  ) : Test.Context(a) {
    `
    #{context}.step((subject) => {
      if (!#{method}(subject)) {
        throw \`Assertion failed!\`
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
  fun map (context : Test.Context(a), method : Function(a, b)) : Test.Context(b) {
    then(context, (item : a) : Promise(b) { Promise.resolve(method(item)) })
  }

  /*
  Starts a test using the given value.

    test {
      Test.Context.of(5)
      |> assertEqual(5)
    }
  */
  fun of (a : a) : Test.Context(a) {
    `new #{%testContext%}(#{a})`
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

  /*
  Adds a transformation step to the test.

    test {
      Test.Context.of(5)
      |> Test.Context.then((number : Number) { Promise.resolve(number + 2) })
      |> Test.Context.assertEqual(7)
    }
  */
  fun then (
    context : Test.Context(a),
    proc : Function(a, Promise(b))
  ) : Test.Context(b) {
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
  fun timeout (context : Test.Context(a), duration : Number) : Test.Context(a) {
    then(
      context,
      (subject : a) : Promise(a) {
        await Timer.timeout(duration)
        subject
      })
  }
}
