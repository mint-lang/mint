/* Represents a subscription for `Provider.TabFocus` */
record Provider.TabFocus.Subscription {
  onTabOut : Function(Promise(Void)),
  onTabIn : Function(Promise(Void)),
  element : Maybe(Dom.Element)
}

/* A provider to provide the tab in and tab out events for an element. */
provider Providers.TabFocus : Provider.TabFocus.Subscription {
  /* The listener unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void))) = Maybe::Nothing

  /* The `keyUp` event handler. */
  fun handleKeyUp (event : Html.Event) : Array(Promise(Void)) {
    if (event.keyCode == Html.Event:TAB) {
      activeElement =
        Dom.getActiveElement()

      for (subscription of subscriptions) {
        subscription.onTabIn()
      } when {
        subscription.element == activeElement
      }
    } else {
      []
    }
  }

  /* The `keyDown` event handler. */
  fun handleKeyDown (event : Html.Event) : Array(Promise(Void)) {
    if (event.keyCode == Html.Event:TAB) {
      target =
        Maybe::Just(event.target)

      for (subscription of subscriptions) {
        subscription.onTabOut()
      } when {
        subscription.element == target
      }
    } else {
      []
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if (Array.isEmpty(subscriptions)) {
      Maybe.map(
        (methods : Tuple(Function(Void), Function(Void))) {
          {keyDownListener, keyUpListener} =
            methods

          keyDownListener()
          keyUpListener()
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
                    Window.addEventListener("keydown", true, handleKeyDown),
                    Window.addEventListener("keyup", true, handleKeyUp)
                  })
            }

        => next { }
      }
    }
  }
}
