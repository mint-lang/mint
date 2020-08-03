/* Represents a subscription for `Provider.TabFocus` */
record Provider.TabFocus.Subscription {
  onTabOut : Function(Promise(Never, Void)),
  onTabIn : Function(Promise(Never, Void)),
  element : Maybe(Dom.Element)
}

/* A provider to provide the tab in and tab out events for an element. */
provider Providers.TabFocus : Provider.TabFocus.Subscription {
  /* The `keyDown` listener unsubscribe function. */
  state keyDownListener : Function(Void) = () { void }

  /* The `keyUp` listener unsubscribe function. */
  state keyUpListener : Function(Void) = () { void }

  /* The `keyUp` event handler. */
  fun handleKeyUp (event : Html.Event) {
    if (event.keyCode == Html.Event:TAB) {
      try {
        activeElement =
          Dom.getActiveElement()

        for (subscription of subscriptions) {
          subscription.onTabIn()
        } when {
          subscription.element == activeElement
        }
      }
    } else {
      []
    }
  }

  /* The `keyDown` event handler. */
  fun handleKeyDown (event : Html.Event) {
    if (event.keyCode == Html.Event:TAB) {
      try {
        target =
          Maybe::Just(event.target)

        for (subscription of subscriptions) {
          subscription.onTabOut()
        } when {
          subscription.element == target
        }
      }
    } else {
      []
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    if (Array.isEmpty(subscriptions)) {
      try {
        keyDownListener()
        keyUpListener()

        next
          {
            keyDownListener = () { void },
            keyUpListener = () { void }
          }
      }
    } else {
      next
        {
          keyDownListener = Window.addEventListener("keydown", true, handleKeyDown),
          keyUpListener = Window.addEventListener("keyup", true, handleKeyUp)
        }
    }
  }
}
