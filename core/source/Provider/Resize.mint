/* Represents a subscription for `Provider.Resize` */
record Provider.Resize.Subscription {
  resizes : Function(Html.Event, Promise(Never, Void))
}

/* A provider for handling changes of the viewport. */
provider Provider.Resize : Provider.Resize.Subscription {
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
              "resize",
              false,
              (event : Html.Event) {
                for (subscription of subscriptions) {
                  subscription.resizes(event)
                }
              })
        }
    }
  }
}
