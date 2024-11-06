/* Represents a subscription for `Provider.Tick` */
type Provider.Tick {
  ticks : Function(Promise(Void))
}

/*
A provider for periodic updates (every 1 seconds).

```
component Main {
  state count : Number = 0

  use Provider.Tick {
    ticks:
      () {
        next { count: count + 1 }
      }
  }

  fun render : Html {
    <div>"#{count}"</div>
  }
}
```
*/
provider Provider.Tick : Provider.Tick {
  state id : Number = -1

  /* Call the subscribers. */
  fun process : Array(Promise(Void)) {
    for subscription of subscriptions {
      subscription.ticks()
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    if Array.isEmpty(subscriptions) {
      next { id: `clearInterval(#{id}) || -1` }
    } else if id == -1 {
      next { id: `setInterval(#{process}, 1000)` }
    } else {
      next { }
    }
  }
}
