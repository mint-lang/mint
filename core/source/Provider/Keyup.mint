/* Represents a subscription for `Provider.Keyup` */
record Provider.Keyup.Subscription {
  keyups : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global key up events. */
provider Provider.Keyup : Provider.Keyup.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  /* The event handler. */
  fun handle (event : Html.Event) : Array(Promise(Never, Void)) {
    for (subscription of subscriptions) {
      subscription.keyups(event)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        Maybe.map((unsubscribe : Function(Void)) { unsubscribe() }, listener)
        next { listener = Maybe::Nothing }
      }
    } else {
      case (listener) {
        Maybe::Nothing =>
          next { listener = Maybe::Just(Window.addEventListener("keyup", true, handle)) }

        => next { }
      }
    }
  }
}
