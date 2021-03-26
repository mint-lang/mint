module Function {
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
