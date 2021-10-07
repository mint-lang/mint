/* Represents a subscription for `Provider.Mouse` */
record Provider.Mouse.Subscription {
  clicks : Function(Html.Event, Promise(Never, Void)),
  moves : Function(Html.Event, Promise(Never, Void)),
  ups : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global mouse events. */
provider Provider.Mouse : Provider.Mouse.Subscription {
  /* The listener unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void), Function(Void))) = Maybe::Nothing

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      Maybe.map(
        (
          methods : Tuple(Function(Void), Function(Void), Function(Void))
        ) {
          try {
            {clickListener, moveListener, upListener} =
              methods

            clickListener()
            moveListener()
            upListener()
          }
        },
        listeners)

      next { listeners = Maybe::Nothing }
    } else {
      case (listeners) {
        Maybe::Nothing =>
          next
            {
              listeners =
                Maybe::Just(
                  {
                    Window.addEventListener(
                      "click",
                      true,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.clicks(event)
                        }
                      }),
                    Window.addEventListener(
                      "mousemove",
                      false,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.moves(event)
                        }
                      }),
                    Window.addEventListener(
                      "mouseup",
                      false,
                      (event : Html.Event) {
                        for (subscription of subscriptions) {
                          subscription.ups(event)
                        }
                      })
                  })
            }

        => next { }
      }
    }
  }
}
