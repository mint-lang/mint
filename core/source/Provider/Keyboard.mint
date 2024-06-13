/* Represents a subscription for `Provider.Keyboard` */
type Provider.Keyboard {
  downs : Function(Html.Event, Promise(Void)),
  ups : Function(Html.Event, Promise(Void))
}

/*
A provider for global keyboard events.

```
component Main {
  state keyCode : Number = 0

  use Provider.Keyboard {
    downs: (event : Html.Event) { next { keyCode: event.keyCode } },
    ups: (event : Html.Event) { next { keyCode: event.keyCode } }
  }

  fun render : Html {
    <div>"#{keyCode}"</div>
  }
}
```
*/
provider Provider.Keyboard : Provider.Keyboard {
  /* The unsubscribe functions. */
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
