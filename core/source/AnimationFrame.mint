/* This module provides a wrapper over the Animation Frame Web API. */
module AnimationFrame {
  /*
  Schedules the function to run on the next frame, and returns its ID.

    id = AnimationFrame.request((timestamp : Number) { Debug.log("Hello") })
  */
  fun request (method : Function(Number, a)) : Number {
    `requestAnimationFrame(#{method})`
  }

  /*
  Cancels a scheduled function call.

    AnimationFrame.cancel(id)
  */
  fun cancel (id : Number) : Number {
    `cancelAnimationFrame(#{id}) || -1`
  }
}
