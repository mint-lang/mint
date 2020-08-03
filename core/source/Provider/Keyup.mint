/* Represents a subscription for `Provider.Keyup` */
record Provider.Keyup.Subscription {
  keyups : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global key up events. */
provider Provider.Keyup : Provider.Keyup.Subscription {
  /* The listener unsubscribe function. */
  state listener : Function(Void) = () { void }

  /* The event handler. */
  fun handle (event : Html.Event) {
    for (subscription of subscriptions) {
      subscription.keyups(event)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        listener()

        next { listener = () { void } }
      }
    } else {
      next { listener = Window.addEventListener("keyup", true, handle) }
    }
  }
}
