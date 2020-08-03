/* Represents a subscription for `Provider.Url` */
record Provider.Url.Subscription {
  changes : Function(Url, Promise(Never, Void))
}

/* A provider for global "popstate" events, which emit the current URL. */
provider Provider.Url : Provider.Url.Subscription {
  /* The listener unsubscribe function. */
  state listener : Function(Void) = () { void }

  /* The event handler. */
  fun handle (event : Html.Event) {
    try {
      url =
        Window.url()

      for (subscription of subscriptions) {
        subscription.changes(url)
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
      next { listener = Window.addEventListener("popstate", false, handle) }
    }
  }
}
