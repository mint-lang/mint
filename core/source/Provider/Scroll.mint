/* Represents a subscription for `Provider.Scroll` */
record Provider.Scroll.Subscription {
  scrolls : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global scroll events. */
provider Provider.Scroll : Provider.Scroll.Subscription {
  /* Calls the `scrolls` function of the subscribers with the given value. */
  fun scrolls (event : Html.Event) : Array(a) {
    subscriptions
    |> Array.map(.scrolls)
    |> Array.map(
      (method : Function(Html.Event, a)) : a { method(event) })
  }

  /* Attaches the provider. */
  fun attach : Void {
    `
    (() => {
      const scrolls = this._scrolls || (this._scrolls = ((event) => #{scrolls}(_normalizeEvent(event))))

      window.addEventListener("scroll", scrolls)
    })()
    `
  }

  /* Detaches the provider. */
  fun detach : Void {
    `
    (() => {
      window.removeEventListener("scroll", this._scrolls)
    })()
    `
  }
}
