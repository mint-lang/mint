/* Represents a subscription for `Provider.Resize` */
record Provider.Resize.Subscription {
  resizes : Function(Html.Event, Promise(Never, Void))
}

/* A provider for handling changes of the viewport. */
provider Provider.Resize : Provider.Resize.Subscription {
  /* Calls the `resizes` function of the subscribers with the given value. */
  resizes (event : Html.Event) : Array(a) {
    subscriptions
    |> Array.map(.resizes)
    |> Array.map(
      (method : Function(Html.Event, a)) : a { method(event) })
  }

  /* Attaches the provider. */
  attach : Void {
    `
    (() => {
      const resizes = this._resizes || (this._resizes = ((event) => #{resizes}(_normalizeEvent(event))))

      window.addEventListener("resize", resizes)
    })()
    `
  }

  /* Detaches the provider. */
  detach : Void {
    `
    (() => {
      window.removeEventListener("resize", this._resizes)
    })()
    `
  }
}
