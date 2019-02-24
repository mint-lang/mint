/* Functions for debugging purpuses */
module Debug {
  /* Logs an arbritaty value to the windows console. */
  fun log (value : a) : a {
    `
    (() => {
      console.log(value)
      return value
    })()
    `
  }
}
