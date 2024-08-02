/* Represents a subscription for `Provider.Mouse` */
type Provider.Mouse {
  clicks : Function(Html.Event, Promise(Void)),
  moves : Function(Html.Event, Promise(Void)),
  ups : Function(Html.Event, Promise(Void))
}

/*
A provider for global mouse events.

```
component Main {
  state position : Tuple(Number, Number) = {0, 0}

  use Provider.Mouse {
    clicks: Promise.never1,
    ups: Promise.never1,
    moves: (event : Html.Event) {
      next {
        position: {event.pageX, event.pageY}
      }
    }
  }

  fun render : Html {
    <div>"#{position[0]}, #{position[1]}"</div>
  }
}
```
*/
provider Provider.Mouse : Provider.Mouse {
  /* The unsubscribe functions. */
  state listeners : Maybe(Tuple(Function(Void), Function(Void), Function(Void))) =
    Maybe.Nothing

  /* The state to hold the animation frame ID. */
  state id : Number = 0

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(listeners,
        (methods : Tuple(Function(Void), Function(Void), Function(Void))) {
          let {clickListener, moveListener, upListener} =
            methods

          clickListener()
          moveListener()
          upListener()
        })

      next { listeners: Maybe.Nothing }
    } else {
      if listeners == Maybe.Nothing {
        next {
          listeners:
            Maybe.Just(
              {
                Window.addEventListener("click", true,
                  (event : Html.Event) {
                    for subscription of subscriptions {
                      subscription.clicks(event)
                    }
                  }),
                Window.addEventListener("mousemove", false,
                  (event : Html.Event) {
                    AnimationFrame.cancel(id)

                    next {
                      id:
                        AnimationFrame.request(
                          (timestamp : Number) {
                            for subscription of subscriptions {
                              subscription.moves(event)
                            }
                          })
                    }
                  }),
                Window.addEventListener("mouseup", false,
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
