/* Represents a subscription for `Provider.MediaQuery` */
type Provider.MediaQuery {
  changes : Function(Bool, Promise(Void)),
  query : String
}

/*
This provider sends changes when the media query in the subscription changes.

```
component Main {
  state matches : Bool = false

  use Provider.MediaQuery {
    query: "(max-width: 1000px)",
    changes: -> matches
  }

  fun render : Html {
    <div>
      Bool.toString(matches)
    </div>
  }
}
```
*/
provider Provider.MediaQuery : Provider.MediaQuery {
  /* The listeners. */
  state listeners : Map(String, Function(Void)) = Map.empty()

  /* Updates the provider. */
  fun update : Promise(Void) {
    let updatedListeners =
      subscriptions
      |> Array.reduce(listeners,
        (memo : Map(String, Function(Void)), subscription : Provider.MediaQuery) {
          if Map.get(listeners, subscription.query) == Maybe.Nothing {
            Map.set(memo, subscription.query,
              Window.addMediaQueryListener(subscription.query,
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
      |> Map.reduce(updatedListeners,
        (memo : Map(String, Function(Void)), query : String,
          listener : Function(Void)) {
          let subscription =
            subscriptions
            |> Array.find((item : Provider.MediaQuery) { item.query == query })

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
