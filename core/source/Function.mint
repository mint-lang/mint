module Function {
  /*
  Debounces a function without arguments.

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
  Debounces a function with only one argument.

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
