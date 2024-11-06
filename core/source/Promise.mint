/* This module provides functions for working with promises. */
module Promise {
  /*
  Returns a resolved promise with `Void` which never fails.

    Promise.never()
  */
  fun never : Promise(Void) {
    resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails, with one
  argument which is ignored.

    Promise.never1("Value")
  */
  fun never1 (param1 : a) : Promise(Void) {
    Promise.resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails, with two
  arguments which are ignored.

    Promise.never1("Value1", "Value2")
  */
  fun never2 (param1 : a, param2 : b) : Promise(Void) {
    Promise.resolve(void)
  }

  /*
  Returns a resolved promise with `Void` which never fails, with three
  arguments which are ignored.

    Promise.never1("Value1", "Value2", "Value3")
  */
  fun never3 (param1 : a, param2 : b, param3 : c) : Promise(Void) {
    Promise.resolve(void)
  }

  /* Creates an already resolved `Promise` */
  fun resolve (input : a) : Promise(a) {
    `Promise.resolve(#{input})`
  }

  /*
  Create a promise with manual resolve.

    let {resolve, promise} =
      Promise.create()
  */
  fun create : Tuple(Function(value, Void), Promise(value)) {
    `
    (() => {
      let resolve;

      const promise = new Promise((a) => { resolve = a })

      return [
        (value) => resolve(value),
        promise
      ]
    })()
    `
  }
}
