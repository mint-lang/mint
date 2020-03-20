/* Represents a subscription for `Provider.Tick` */
record Provider.Tick.Subscription {
  ticks : Function(Promise(Never, Void))
}

/* A provider for periodic updated (every 1 seconds). */
provider Provider.Tick : Provider.Tick.Subscription {
  /* Updates the subscribers. */
  fun update : Array(a) {
    subscriptions
    |> Array.map(
      (item : Provider.Tick.Subscription) : Function(a) { item.ticks })
    |> Array.map((func : Function(a)) : a { func() })
  }

  /* Attaches the provider. */
  fun attach : Void {
    `
    (() => {
      this.detach()
      this.id = setInterval(#{update}.bind(this), 1000)
    })()
    `
  }

  /* Detaches the provider. */
  fun detach : Void {
    `clearInterval(this.id)`
  }
}
