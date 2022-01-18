module Function {
  /*
  Debounces a function without arguments.

    Function.debounce(() { Debug.log("Hello World!") })
  */
  fun debounce (delay : Number, method : Function(a)) : Function(a) {
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

    Function.debounce1((argument : String) { Debug.log(argument) })
  */
  fun debounce1 (delay : Number, method : Function(a, b)) : Function(a, b) {
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
