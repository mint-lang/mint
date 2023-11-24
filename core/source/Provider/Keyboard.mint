/* Represents a subscription for `Provider.Keyboard` */
type Provider.Keyboard.Subscription {
  downs : Function(Html.Event, Promise(Void)),
  ups : Function(Html.Event, Promise(Void))
}

/* A provider for global keyboard events. */
provider Provider.Keyboard : Provider.Keyboard.Subscription {
  /* The listener unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void))) = Maybe.Nothing

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(
        listeners,
        (methods : Tuple(Function(Void), Function(Void))) {
          let {keydownListener, keyupListener} =
            methods

          keydownListener()
          keyupListener()
        })

      next { listeners: Maybe.Nothing }
    } else {
      if listeners == Maybe.Nothing {
        next
          {
            listeners:
              Maybe.Just(
                {
                  Window.addEventListener(
                    "keydown",
                    true,
                    (event : Html.Event) {
                      for subscription of subscriptions {
                        subscription.downs(event)
                      }
                    }),
                  Window.addEventListener(
                    "keyup",
                    true,
                    (event : Html.Event) {
                      for subscription of subscriptions {
                        subscription.ups(event)
                      }
                    })
                })
          }
      }
    }
  }
}
