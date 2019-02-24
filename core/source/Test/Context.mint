/* A module for writing complex tests. */
module Test.Context {
  /*
  Starts a test using the given value.

    test {
      with Test.Context {
        of(5)
        |> Test.assertEqual(5)
      }
    }
  */
  fun of (a : a) : Test.Context(a) {
    `new TestContext(a)`
  }

  /*
  Adds a transformation step to the test.

    test {
      with Test.Context {
        of(5)
        |> then(\number : Number => Promise.resolve(number + 2))
        |> assertEqual(7)
      }
    }
  */
  fun then (
    proc : Function(a, Promise(b, c)),
    context : Test.Context(a)
  ) : Test.Context(c) {
    `
    context.step((subject)=> {
      return proc(subject)
    })
    `
  }

  /* Adds a timeout to the text using the given duration (in milliseconds). */
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
        |> Test.assertEqual(5)
      }
    }
  */
  fun assertEqual (a : a, context : Test.Context(a)) : Test.Context(a) {
    `
    context.step((subject)=> {
      let result = _compare(a, subject)

      if (result) {
        return subject
      } else {
        throw \`Assertion failed ${a} === ${subject}\`
      }
    })
    `
  }

  fun assertOf (
    value : b,
    method : Function(a, b),
    context : Test.Context(a)
  ) : Test.Context(a) {
    `
    context.step((item) {
      let actual = method(item)

      if (actual == value) {
        return item
      } else {
        throw \`Assertion failed ${actual} === ${value}\`
      }
    })
    `
  }

  fun map (method : Function(a, b), context : Test.Context(a)) : Test.Context(b) {
    then(
      (item : a) : Promise(Never, Test.Context(a)) { Promise.resolve(method(item)) },
      context)
  }
}
