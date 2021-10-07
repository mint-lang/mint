/* Represents a subscription for `Provider.Keydown` */
record Provider.Keydown.Subscription {
  keydowns : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global key down events. */
provider Provider.Keydown : Provider.Keydown.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  /* The event handler. */
  fun handle (event : Html.Event) : Array(Promise(Never, Void)) {
    for (subscription of subscriptions) {
      subscription.keydowns(event)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      Maybe.map((unsubscribe : Function(Void)) { unsubscribe() }, listener)
      next { listener = Maybe::Nothing }
    } else {
      case (listener) {
        Maybe::Nothing =>
          next { listener = Maybe::Just(Window.addEventListener("keydown", true, handle)) }

        => next { }
      }
    }
  }
}
