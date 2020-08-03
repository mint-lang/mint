/* Represents a subscription for `Provider.Keydown` */
record Provider.Keydown.Subscription {
  keydowns : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global key down events. */
provider Provider.Keydown : Provider.Keydown.Subscription {
  /* The listener unsubscribe function. */
  state listener : Function(Void) = () { void }

  /* The event handler. */
  fun handleKeyDown (event : Html.Event) {
    for (subscription of subscriptions) {
      subscription.keydowns(event)
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
      next { listener = Window.addEventListener("keydown", true, handleKeyDown) }
    }
  }
}
