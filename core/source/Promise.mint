/* Utility functions for working with promises. */
module Promise {
  /*
  Create a promise with manual resolve / reject.

    {resolve, reject, promise} = Promise.create()
  */
  fun create : Tuple(Function(value, Void), Function(error, Void), Promise(error, value)) {
    `
    (() => {
      let resolve, reject;

      const promise = new Promise((a, b) => {
        resolve = a
        reject = b
      })

      return [
        (value) => resolve(value),
        (error) => reject(error),
        promise
      ]
    })()
    `
  }

  /*
  Returns a resolved promise with `Void` which never fails.

    Promise.never()
  */
  fun never : Promise(Never, Void) {
    resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails with one
  argument which is ignored.

    Promise.never1("Value")
  */
  fun never1 (param1 : a) : Promise(Never, Void) {
    Promise.resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails with two
  arguments which are ignored.

    Promise.never1("Value1", "Value2")
  */
  fun never2 (param1 : a, param2 : b) : Promise(Never, Void) {
    Promise.resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails with three
  arguments which are ignored.

    Promise.never1("Value1", "Value2", "Value3")
  */
  fun never3 (param1 : a, param2 : b, param3 : c) : Promise(Never, Void) {
    Promise.resolve(void)
  }

  /*
  Creates an already rejected `Promise`.

    Promise.reject("Error")
  */
  fun reject (input : a) : Promise(a, b) {
    `Promise.reject(#{input})`
  }

  /*
  Creates an already resolved `Promise`.

    Promise.resolve("Value")
  */
  fun resolve (input : a) : Promise(b, a) {
    `Promise.resolve(#{input})`
  }
}
