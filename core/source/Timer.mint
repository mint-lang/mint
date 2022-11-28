/* Time related utility functions. */
module Timer {
  /* Returns a promise which resolves after the next `animationFrame`. */
  fun nextFrame : Promise(Never, Void) {
    `
    new Promise((resolve) => {
      requestAnimationFrame(() => {
        resolve(#{void})
      })
    })
    `
  }

  /*
  Returns a promise which resolves after the given number of time in
  milliseconds.
  */
  fun timeout (duration : Number) : Promise(Never, Void) {
    `
    new Promise((resolve) => {
      setTimeout(() => {
        resolve(#{void})
      }, #{duration})
    })
    `
  }
}
