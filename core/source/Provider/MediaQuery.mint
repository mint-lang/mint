/* Represents a subscription for `Provider.MediaQuery` */
record Provider.MediaQuery.Subscription {
  changes : Function(Bool, Promise(Never, Void)),
  query : String
}

/*
This provider sends changes when the given media query in the subscription
changes.
*/
provider Provider.MediaQuery : Provider.MediaQuery.Subscription {
  /* The map of the listeners. */
  state listeners : Map(String, Function(Void)) = Map.empty()

  fun update : Promise(Never, Void) {
    updatedListeners =
      subscriptions
      |> Array.reduce(
        listeners,
        (
          memo : Map(String, Function(Void)),
          subscription : Provider.MediaQuery.Subscription
        ) {
          case (Map.get(subscription.query, listeners)) {
            Maybe::Nothing =>
              Map.set(
                subscription.query,
                Window.addMediaQueryListener(
                  subscription.query,
                  (active : Bool) {
                    for (item of subscriptions) {
                      subscription.changes(active)
                    } when {
                      item.query == subscription.query
                    }
                  }),
                memo)

            Maybe::Just => memo
          }
        })

    finalListeners =
      updatedListeners
      |> Map.reduce(
        updatedListeners,
        (
          memo : Map(String, Function(Void)),
          query : String,
          listener : Function(Void)
        ) {
          subscription =
            subscriptions
            |> Array.find(
              (item : Provider.MediaQuery.Subscription) { item.query == query })

          case (subscription) {
            Maybe::Just => memo

            Maybe::Nothing =>
              {
                listener()
                Map.delete(query, memo)
              }
          }
        })

    next { listeners = finalListeners }
  }
}
