/* Represents a subscription for `Provider.Resize` */
record Provider.Resize.Subscription {
  resizes : Function(Html.Event, Promise(Void))
}

/* A provider for handling changes of the viewport. */
provider Provider.Resize : Provider.Resize.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  fun handle (event : Html.Event) : Array(Promise(Void)) {
    for (subscription of subscriptions) {
      subscription.resizes(event)
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
          next { listener = Maybe::Just(Window.addEventListener("resize", true, handle)) }

        => next { }
      }
    }
  }
}
