/* Represents a subscription for `Provider.AnimationFrame` */
record Provider.AnimationFrame.Subscription {
  frames : Function(Number, Promise(Never, Void))
}

/* A provider for the `requestAnimationFrame` API. */
provider Provider.AnimationFrame : Provider.AnimationFrame.Subscription {
  /* The current animation frame callback id. */
  state id : Number = -1

  /* Call the subscribers. */
  fun process (timestamp : Number) : Promise(Never, Void) {
    for (subscription of subscriptions) {
      subscription.frames(timestamp)
    }

    next { id = AnimationFrame.request(process) }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      next { id = AnimationFrame.cancel(id) }
    } else if (id == -1) {
      next { id = AnimationFrame.request(process) }
    } else {
      next { }
    }
  }
}
