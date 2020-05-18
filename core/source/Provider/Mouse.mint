/* Represents a subscription for `Provider.Mouse` */
record Provider.Mouse.Subscription {
  clicks : Function(Html.Event, Promise(Never, Void)),
  moves : Function(Html.Event, Promise(Never, Void)),
  ups : Function(Html.Event, Promise(Never, Void))
}

/* A provider for global mouse events. */
provider Provider.Mouse : Provider.Mouse.Subscription {
  state clickListener : Function(Void) = () { void }
  state moveListener : Function(Void) = () { void }
  state upListener : Function(Void) = () { void }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        clickListener()
        moveListener()
        upListener()

        next
          {
            clickListener = () { void },
            moveListener = () { void },
            upListener = () { void }
          }
      }
    } else {
      next
        {
          clickListener =
            Window.addEventListener(
              "click",
              true,
              (event : Html.Event) {
                for (subscription of subscriptions) {
                  subscription.clicks(event)
                }
              }),
          moveListener =
            Window.addEventListener(
              "mousemove",
              false,
              (event : Html.Event) {
                for (subscription of subscriptions) {
                  subscription.moves(event)
                }
              }),
          upListener =
            Window.addEventListener(
              "mouseup",
              false,
              (event : Html.Event) {
                for (subscription of subscriptions) {
                  subscription.ups(event)
                }
              })
        }
    }
  }
}
