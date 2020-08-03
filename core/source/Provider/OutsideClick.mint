/* Represents a subscription for `Provider.OutsideClick` */
record Provider.OutsideClick.Subscription {
  clicks : Function(Promise(Never, Void)),
  element : Maybe(Dom.Element)
}

/* A provider to provide events when clicking outside of the given element. */
provider Provider.OutsideClick : Provider.OutsideClick.Subscription {
  /* The listener unsubscribe function. */
  state listener : Function(Void) = () { void }

  /* The event handler. */
  fun handle (event : Html.Event) {
    for (subscription of subscriptions) {
      case (subscription.element) {
        Maybe::Just item =>
          if (Dom.contains(event.target, item)) {
            Promise.never()
          } else {
            subscription.clicks()
          }

        => Promise.never()
      }
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
      next { listener = Window.addEventListener("mouseup", true, handle) }
    }
  }
}
