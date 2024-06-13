/* This module provides functions for writing complex tests. */
module Test.Context {
  /*
  Asserts the equality of the current value of the context with the specified
  one.

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

  /*
  Asserts that a spy (function) was called.

    test {
      let spy =
        Text.Context.spyOn(String.toUpperCase)

      "hello world!"
      |> Text.contextOf()
      |> Text.Context.map(spy)
      |> Test.Context.assertFunctionCalled(spy)
    }
  */
  fun assertFunctionCalled (context : Test.Context(c), function : a) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      if (!#{function}._called) {
        throw "The function was not called!"
      }

      return subject
    })
    `
  }

  /*
  Asserts that a spy (function) was not called.

    test {
      let spy =
        Text.Context.spyOn(String.toUpperCase)

      "hello world!"
      |> Text.contextOf()
      |> Text.Context.map(String.toUpperCase)
      |> Test.Context.assertFunctionNotCalled(spy)
    }
  */
  fun assertFunctionNotCalled (
    context : Test.Context(c),
    function : a
  ) : Test.Context(c) {
    `
    #{context}.step((subject) => {
      if (#{function}._called) {
        throw "The function was called!"
      }

      return subject
    })
    `
  }

  /*
  Asserts if the value equals of the returned value from the function.

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
  Asserts if the value equals of the returned value from the function.

    test {
      Test.Context.of(5)
      |> Test.Context.assert((value : Number) { value == 5 })
    }
  */
  fun assert (context : Test.Context(a), method : Function(a, bool)) : Test.Context(a) {
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
  Maps (transforms) the subject to a new subject.

    test {
      Test.Context.of(5)
      |> Test.Context.map(Number.toString)
    }
  */
  fun map (context : Test.Context(a), method : Function(a, b)) : Test.Context(b) {
    then(context, (item : a) : Promise(b) { await method(item) })
  }

  /*
  Starts a test using the value.

    test {
      Test.Context.of(5)
      |> assertEqual(5)
    }
  */
  fun of (a : a) : Test.Context(a) {
    `new #{%testContext%}(#{a})`
  }

  /*
  Spies on the entity if it's a function.

    test {
      let spy =
        Text.Context.spyOn(String.toUpperCase)

      "hello world!"
      |> Text.contextOf()
      |> Text.Context.map(spy)
      |> Test.Context.assertFunctionCalled(spy)
    }
  */
  fun spyOn (entity : a) : a {
    `
    (() => {
      if (typeof #{entity} == "function") {
        const _ = function (...args) {
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
      |> Test.Context.then((number : Number) { await (number + 2) })
      |> Test.Context.assertEqual(7)
    }
  */
  fun then (context : Test.Context(a), proc : Function(a, Promise(b))) : Test.Context(b) {
    `
    #{context}.step((subject) => {
      return #{proc}(subject)
    })
    `
  }

  /*
  Adds a timeout to the test using the duration (in milliseconds).

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
