/* Represents a subscription for `Provider.Mouse` */
record Provider.Mouse.Subscription {
  clicks : Function(Html.Event, Promise(Never,Void)),
  moves : Function(Html.Event, Promise(Never,Void)),
  ups : Function(Html.Event, Promise(Never,Void))
}

/* A provider for global mouse events. */
provider Provider.Mouse : Provider.Mouse.Subscription {
  /* Calls the `moves` function on the subscribers with the given event. */
  fun moves (event : Html.Event) : Array(a) {
    subscriptions
    |> Array.map(
      (subcription : Provider.Mouse.Subscription) : Function(Html.Event, a) { subcription.moves })
    |> Array.map(
      (func : Function(Html.Event, a)) : a { func(event) })
  }

  /* Calls the `clicks` function on the subscribers with the given event. */
  fun clicks (event : Html.Event) : Array(a) {
    subscriptions
    |> Array.map(
      (subcription : Provider.Mouse.Subscription) : Function(Html.Event, a) { subcription.clicks })
    |> Array.map(
      (func : Function(Html.Event, a)) : a { func(event) })
  }

  /* Calls the `ups` function on the subscribers with the given event. */
  fun ups (event : Html.Event) : Array(a) {
    subscriptions
    |> Array.map(
      (subcription : Provider.Mouse.Subscription) : Function(Html.Event, a) { subcription.ups })
    |> Array.map(
      (func : Function(Html.Event, a)) : a { func(event) })
  }

  /* Attaches the provider. */
  fun attach : Void {
    `
    (() => {
      const clicks = this._clicks || (this._clicks = ((event) => #{clicks}(_normalizeEvent(event))))
      const moves = this._moves || (this._moves = ((event) => #{moves}(_normalizeEvent(event))))
      const ups = this._ups || (this._ups = ((event) => #{ups}(_normalizeEvent(event))))

      window.addEventListener("click", clicks, true)
      window.addEventListener("mousemove", moves)
      window.addEventListener("mouseup", ups)
    })()
    `
  }

  /* Detaches the provider. */
  fun detach : Void {
    `
    (() => {
      window.removeEventListener("click", this._clicks, true)
      window.removeEventListener("mousemove", this._moves)
      window.removeEventListener("mouseup", this._ups)
    })()
    `
  }
}
