/*
This module provides functions to work with the [Animation Frame Web API].

[Animation Frame Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
*/
module AnimationFrame {
  /*
  Cancels a previously scheduled function call using the `request` function.

    AnimationFrame.cancel(id)
  */
  fun cancel (id : Number) : Number {
    `cancelAnimationFrame(#{id}) || -1`
  }

  /*
  Schedules the function to run on the next frame, and returns its ID for
  possible cancellation.

    let id =
      AnimationFrame.request((timestamp : Number) {
        Debug.log("Hello")
      })
  */
  fun request (function : Function(Number, a)) : Number {
    `requestAnimationFrame(#{function})`
  }
}
