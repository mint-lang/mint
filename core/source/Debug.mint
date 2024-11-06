/* This module provides functions for debugging purposes. */
module Debug {
  /*
  Logs an arbitrary value to the windows console.

    Debug.log("Hello World!")
  */
  fun log (value : a) : a {
    `
    (() => {
      if (window.DEBUG) {
        window.DEBUG.log(#{value})
      } else {
        console.log(#{value})
      }

      return #{value}
    })()
    `
  }
}
