/* Represents a subscription for `Provider.OutsideClick` */
record Provider.OutsideClick.Subscription {
  clicks : Function(Promise(Void)),
  elements : Array(Maybe(Dom.Element))
}

/* A provider to provide events when clicking outside of the given element. */
provider Provider.OutsideClick : Provider.OutsideClick.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  /* The event handler. */
  fun handle (event : Html.Event) : Array(Promise(Void)) {
    for (subscription of subscriptions) {
      inside =
        subscription.elements
        |> Array.compact()
        |> Array.any((item : Dom.Element) { Dom.contains(event.target, item) })

      if (inside) {
        Promise.never()
      } else {
        subscription.clicks()
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if (Array.isEmpty(subscriptions)) {
      Maybe.map((unsubscribe : Function(Void)) { unsubscribe() }, listener)
      next { listener = Maybe::Nothing }
    } else {
      case (listener) {
        Maybe::Nothing =>
          next { listener = Maybe::Just(Window.addEventListener("mouseup", true, handle)) }

        => next { }
      }
    }
  }
}
