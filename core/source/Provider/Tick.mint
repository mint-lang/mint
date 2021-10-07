/* Represents a subscription for `Provider.Tick` */
record Provider.Tick.Subscription {
  ticks : Function(Promise(Never, Void))
}

/* A provider for periodic updates (every 1 seconds). */
provider Provider.Tick : Provider.Tick.Subscription {
  state id : Number = -1

  /* Call the subscribers. */
  fun process : Array(Promise(Never, Void)) {
    for (subscription of subscriptions) {
      subscription.ticks()
    }
  }

  /* Attaches the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      next { id = `clearInterval(#{id}) || -1` }
    } else if (id == -1) {
      next { id = `setInterval(#{process}, 1000)` }
    } else {
      next { }
    }
  }
}
