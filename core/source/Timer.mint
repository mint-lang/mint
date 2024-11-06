/* This module provides functions related to timers. */
module Timer {
  /*
  Returns a promise which resolves after the next `animationFrame`

    await Timer.nextFrame()
    Debug.log("This runs after the next frame...")
  */
  fun nextFrame : Promise(Void) {
    `
    new Promise((resolve) => {
      requestAnimationFrame(() => {
        resolve(#{void})
      })
    })
    `
  }

  /*
  Returns a promise which resolves after the specified time in milliseconds.

    await Timer.timeout(2000)
    Debug.log("This runs after 2 seconds...")
  */
  fun timeout (duration : Number) : Promise(Void) {
    `
    new Promise((resolve) => {
      setTimeout(() => {
        resolve(#{void})
      }, #{duration})
    })
    `
  }
}
