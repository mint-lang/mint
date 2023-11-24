/* Represents a subscription for `Provider.OutsideClick` */
type Provider.OutsideClick.Subscription {
  clicks : Function(Promise(Void)),
  elements : Array(Maybe(Dom.Element))
}

/* A provider to provide events when clicking outside of the given element. */
provider Provider.OutsideClick : Provider.OutsideClick.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe.Nothing

  /* The event handler. */
  fun handle (event : Html.Event) : Array(Promise(Void)) {
    for subscription of subscriptions {
      let inside =
        subscription.elements
        |> Array.compact()
        |> Array.any((item : Dom.Element) { Dom.contains(item, event.target) })

      if inside {
        Promise.never()
      } else {
        subscription.clicks()
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(listener, (unsubscribe : Function(Void)) { unsubscribe() })
      next { listener: Maybe.Nothing }
    } else {
      if listener == Maybe.Nothing {
        next { listener: Maybe.Just(Window.addEventListener("mouseup", true, handle)) }
      }
    }
  }
}
