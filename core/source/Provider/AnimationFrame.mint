/* Represents a subscription for `Provider.AnimationFrame` */
type Provider.AnimationFrame {
  frames : Function(Number, Promise(Void))
}

/*
A provider for the [`requestAnimationFrame`] Web API.

[`requestAnimationFrame`]: https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame

```
component Main {
  state id : Number = 0

  use Provider.AnimationFrame {
    frames: (id : Number) {
      next { id: id }
    }
  }

  fun render : Html {
    <div>
      "#{id}"
    </div>
  }
}
```
*/
provider Provider.AnimationFrame : Provider.AnimationFrame {
  /* The current animation frame callback ID. */
  state id : Number = -1

  /* Notifies all subscribers. */
  fun notify (timestamp : Number) : Promise(Void) {
    for subscription of subscriptions {
      subscription.frames(timestamp)
    }

    next { id: AnimationFrame.request(notify) }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      next { id: AnimationFrame.cancel(id) }
    } else if id == -1 {
      next { id: AnimationFrame.request(notify) }
    } else {
      next { }
    }
  }
}
