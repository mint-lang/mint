/* Represents a subscription for `Provider.Resize` */
type Provider.Resize.Subscription {
  resizes : Function(Html.Event, Promise(Void))
}

/* A provider for handling changes of the viewport. */
provider Provider.Resize : Provider.Resize.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe.Nothing

  /* Handles the resize events. */
  fun handle (event : Html.Event) : Array(Promise(Void)) {
    for subscription of subscriptions {
      subscription.resizes(event)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(listener, (unsubscribe : Function(Void)) { unsubscribe() })
      next { listener: Maybe.Nothing }
    } else {
      if listener == Maybe.Nothing {
        next { listener: Maybe.Just(Window.addEventListener("resize", true, handle)) }
      }
    }
  }
}
