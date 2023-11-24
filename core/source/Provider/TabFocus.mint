/* Represents a subscription for `Provider.TabFocus` */
type Provider.TabFocus.Subscription {
  onTabOut : Function(Promise(Void)),
  onTabIn : Function(Promise(Void)),
  element : Maybe(Dom.Element)
}

/* A provider to provide the tab in and tab out events for an element. */
provider Providers.TabFocus : Provider.TabFocus.Subscription {
  /* The listener unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void))) = Maybe.Nothing

  /* The `keyUp` event handler. */
  fun handleKeyUp (event : Html.Event) : Array(Promise(Void)) {
    if event.keyCode == Html.Event.TAB {
      let activeElement =
        Dom.getActiveElement()

      for subscription of subscriptions {
        subscription.onTabIn()
      } when {
        subscription.element == activeElement
      }
    }
  }

  /* The `keyDown` event handler. */
  fun handleKeyDown (event : Html.Event) : Array(Promise(Void)) {
    if event.keyCode == Html.Event.TAB {
      let target =
        Maybe.Just(event.target)

      for subscription of subscriptions {
        subscription.onTabOut()
      } when {
        subscription.element == target
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(
        listeners,
        (methods : Tuple(Function(Void), Function(Void))) {
          let {keyDownListener, keyUpListener} =
            methods

          keyDownListener()
          keyUpListener()
        })

      next { listeners: Maybe.Nothing }
    } else {
      if listeners == Maybe.Nothing {
        next
          {
            listeners:
              Maybe.Just(
                {
                  Window.addEventListener("keydown", true, handleKeyDown),
                  Window.addEventListener("keyup", true, handleKeyUp)
                })
          }
      }
    }
  }
}
