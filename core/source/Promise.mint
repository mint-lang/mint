/* Utility functions for working with promises. */
module Promise {
  /* Returns a resolved promise with `Void` which never fails. */
  fun never : Promise(Never, Void) {
    resolve(void)
  }

  /* Creates an already rejected `Promise` */
  fun reject (input : a) : Promise(a, b) {
    `Promise.reject(input)`
  }

  /* Creates an already resolved `Promise` */
  fun resolve (input : a) : Promise(b, a) {
    `Promise.resolve(input)`
  }
}
