/* Functions for debugging purpuses */
module Debug {
  /* Logs an arbritaty value to the windows console. */
  log (value : a) : a {
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
