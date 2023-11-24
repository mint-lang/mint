/* Represents a subscription for `Provider.MediaQuery` */
type Provider.MediaQuery.Subscription {
  changes : Function(Bool, Promise(Void)),
  query : String
}

/*
This provider sends changes when the given media query in the subscription
changes.
*/
provider Provider.MediaQuery : Provider.MediaQuery.Subscription {
  /* The map of the listeners. */
  state listeners : Map(String, Function(Void)) = Map.empty()

  fun update : Promise(Void) {
    let updatedListeners =
      subscriptions
      |> Array.reduce(
        listeners,
        (
          memo : Map(String, Function(Void)),
          subscription : Provider.MediaQuery.Subscription
        ) {
          if Map.get(listeners, subscription.query) == Maybe.Nothing {
            Map.set(
              memo,
              subscription.query,
              Window.addMediaQueryListener(
                subscription.query,
                (active : Bool) {
                  for item of subscriptions {
                    subscription.changes(active)
                  } when {
                    item.query == subscription.query
                  }
                }))
          } else {
            memo
          }
        })

    let finalListeners =
      updatedListeners
      |> Map.reduce(
        updatedListeners,
        (
          memo : Map(String, Function(Void)),
          query : String,
          listener : Function(Void)
        ) {
          let subscription =
            subscriptions
            |> Array.find(
              (item : Provider.MediaQuery.Subscription) { item.query == query })

          if subscription == Maybe.Nothing {
            // Unsubscribe
            listener()
            Map.delete(memo, query)
          } else {
            memo
          }
        })

    next { listeners: finalListeners }
  }
}
