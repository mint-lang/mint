/* Represents a subscription for `Provider.Resize` */
record Provider.Resize.Subscription {
  resizes : Function(Html.Event, Promise(Never, Void))
}

/* A provider for handling changes of the viewport. */
provider Provider.Resize : Provider.Resize.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  fun handle (event : Html.Event) : Array(Promise(Never, Void)) {
    for (subscription of subscriptions) {
      subscription.resizes(event)
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
          next { listener = Maybe::Just(Window.addEventListener("resize", true, handle)) }

        => next { }
      }
    }
  }
}
