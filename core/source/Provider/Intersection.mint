/* Represents a subscription for `Provider.Intersection` */
type Provider.Intersection {
  callback : Function(Number, Promise(Void)),
  element : Maybe(Dom.Element),
  rootMargin : String,
  threshold : Number
}

/*
A provider to provide events when the given element is visible on the screen,
using the [Intersection Observer Web API].

[Intersection Observer Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API

```
component Main {
  state intersecting : Bool = false

  use Provider.Intersection {
    callback: (amount : Number) { next { intersecting: amount != 1 } },
    rootMargin: "0px",
    threshold: 1,
    element: div
  }

  style div {
    animation: animate 2s both alternate infinite;

    box-sizing: border-box;
    position: absolute;
    background: black;
    color: white;

    place-content: center;
    display: grid;

    padding: 20px;
    height: 200px;
    width: 200px;

    @keyframes animate {
      0% {
        left: 250px;
      }

      100% {
        left: -250px;
      }
    }
  }

  fun render : Html {
    <div>
      if intersecting {
        "Intersecting"
      } else {
        "Not Intersecting"
      }

      <div::div as div>"Hello World!"</div>
    </div>
  }
}
```
*/
provider Provider.Intersection : Provider.Intersection {
  /* The observers. */
  state observers : Array(Tuple(Provider.Intersection, IntersectionObserver)) =
    []

  /* Updates the provider. */
  fun update : Promise(Void) {
    /*
    Gather all of the current observers, and remove ones that are no longer
    present.
    */
    let currentObservers =
      for item of observers {
        let {subscription, observer} =
          item

        if Array.contains(subscriptions, subscription) {
          Maybe.Just({subscription, observer})
        } else {
          if let Maybe.Just(observed) = subscription.element {
            IntersectionObserver.unobserve(observer, observed)
            Maybe.Nothing
          }
        }
      }
      |> Array.compact()

    /* Create new observers. */
    let newObservers =
      for subscription of subscriptions {
        if let Maybe.Just(observed) = subscription.element {
          Maybe.Just(
            {
              subscription,
              IntersectionObserver.new(subscription.rootMargin,
                subscription.threshold, subscription.callback)
              |> IntersectionObserver.observe(observed)
            })
        }
      } when {
        Array.size(
          for item of observers {
            item
          } when {
            item[0] == subscription
          }) == 0
      }
      |> Array.compact()

    next { observers: Array.concat([currentObservers, newObservers]) }
  }
}
