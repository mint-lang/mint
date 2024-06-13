/* This module provides functions for working with functions. */
module Function {
  /*
  Returns a debounced version of the function which when called repeatedly
  under inside delay, will be called only once.

    Function.debounce(() { Debug.log("Hello World!") }, 100)
  */
  fun debounce (method : Function(a), delay : Number) : Function(a) {
    `
    (() => {
      let _id;

      return () => {
        clearTimeout(_id);
        _id = setTimeout(() => #{method}(), #{delay});
      }
    })()
    `
  }

  /*
  Same as `debounce` but for functions with only one argument.

    Function.debounce1((argument : String) { Debug.log(argument) }, 100)
  */
  fun debounce1 (method : Function(a, b), delay : Number) : Function(a, b) {
    `
    (() => {
      let _id;

      return _arg => {
        clearTimeout(_id);
        _id = setTimeout(() => #{method}(_arg), #{delay});
      }
    })()
    `
  }
}
