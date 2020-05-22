/* Represents a subscription for `Provider.Scroll` */
record Provider.Scroll.Subscription {
  scrolls : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global scroll events. */
provider Provider.Scroll : Provider.Scroll.Subscription {
  state listener : Function(Void) = () { void }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        listener()

        next { listener = () { void } }
      }
    } else {
      next
        {
          listener =
            Window.addEventListener(
              "scroll",
              false,
              (event : Html.Event) {
                for (subscription of subscriptions) {
                  subscription.scrolls(event)
                }
              })
        }
    }
  }
}
