/* Represents a subscription for `Provider.AnimationFrame` */
record Provider.AnimationFrame.Subscription {
  frames : Function(Promise(Never, Void))
}

/* A provider for the `requestAnimationFrame` API. */
provider Provider.AnimationFrame : Provider.AnimationFrame.Subscription {
  /* Updates the subscribers. */
  fun update : Array(a) {
    subscriptions
    |> Array.map(
      (item : Provider.AnimationFrame.Subscription) : Function(a) { item.frames })
    |> Array.map((func : Function(a)) : a { func() })
  }

  /* Attaches the provider. */
  fun attach : Void {
    `
    (() => {
      this.detach()

      const fn = () => {
        requestAnimationFrame(() => {
          #{update()}
          fn()
        })
      }

      this.id = fn()
    })()
    `
  }

  /* Detaches the provider. */
  fun detach : Void {
    `cancelAnimationFrame(this.id)`
  }
}
