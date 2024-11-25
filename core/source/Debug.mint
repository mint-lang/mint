/* This module provides functions for debugging purposes. */
module Debug {
  /*
  Returns a nicely formatted version of the value. Values of Mint types
  preserve their original name.

    Debug.inspect("Hello World!") // "Hello World!"
    Debug.inspect(Maybe.Nothing) // Maybe.Nothing
    Debug.inspect({ name: "Joe", age: 37 }) // User { name: "Joe", age: 37 }
  */
  fun inspect (value : a) : String {
    `#{%inspect%}(#{value})`
  }

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
