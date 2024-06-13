/* Represents a subscription for `Provider.Scroll` */
type Provider.Scroll {
  scrolls : Function(Html.Event, Promise(Void))
}

/*
A provider for global scroll events.

```
component Main {
  state scrollTop : Number = 0

  use Provider.Scroll {
    scrolls:
      (event : Html.Event) {
        next { scrollTop: Window.scrollTop() }
      }
  }

  style root {
    height: 200vh;
  }

  style position {
    position: fixed;
  }

  fun render : Html {
    <div::root>
      <div::position>"#{scrollTop}"</div>
    </div>
  }
}
```
*/
provider Provider.Scroll : Provider.Scroll {
  /* The listener unsubscribe function. */
  state listener : Maybe(Function(Void)) = Maybe.Nothing

  /* Handles the scroll events. */
  fun handle (event : Html.Event) : Array(Promise(Void)) {
    for subscription of subscriptions {
      subscription.scrolls(event)
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      Maybe.map(listener, (unsubscribe : Function(Void)) { unsubscribe() })
      next { listener: Maybe.Nothing }
    } else {
      if listener == Maybe.Nothing {
        next { listener: Maybe.Just(Window.addEventListener("scroll", false, handle)) }
      }
    }
  }
}
