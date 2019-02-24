/* Time related utility functions. */
module Timer {
  /*
  Returns a promise which resovles after the given number of time in
  milliseconds.
  */
  fun timeout (duration : Number, subject : a) : Promise(Never, a) {
    `
    new Promise((resolve) => {
    	setTimeout(() => {
        resolve(subject)
      }, duration)
    })
    `
  }

  /* Returns a promise which resolves after the next `animationFrame`. */
  fun nextFrame (subject : a) : Promise(Never, a) {
    `
    new Promise((resolve) => {
    	requestAnimationFrame(() => {
        resolve(subject)
      })
    })
    `
  }
}
