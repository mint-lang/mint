/* Represents a subscription for `Provider.Scroll` */
record Provider.Scroll.Subscription {
  scrolls : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global scroll events. */
provider Provider.Scroll : Provider.Scroll.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe::Nothing

  fun handle (event : Html.Event) : Array(Promise(Never, Void)) {
    for (subscription of subscriptions) {
      subscription.scrolls(event)
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
          next { listener = Maybe::Just(Window.addEventListener("scroll", false, handle)) }

        => next { }
      }
    }
  }
}
