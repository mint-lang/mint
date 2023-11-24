/* Represents a subscription for `Provider.Url` */
type Provider.Url.Subscription {
  changes : Function(Url, Promise(Void))
}

/* A provider for global "popstate" events, which emit the current URL. */
provider Provider.Url : Provider.Url.Subscription {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe.Nothing

  /* The event handler. */
  fun handle (event : Html.Event) : Array(Promise(Void)) {
    let url =
      Window.url()

    for subscription of subscriptions {
      subscription.changes(url)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(listener, (unsubscribe : Function(Void)) { unsubscribe() })
      next { listener: Maybe.Nothing }
    } else {
      if listener == Maybe.Nothing {
        next { listener: Maybe.Just(Window.addEventListener("popstate", false, handle)) }
      }
    }
  }
}
