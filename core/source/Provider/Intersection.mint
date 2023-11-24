/* Represents a subscription for `Provider.Intersection` */
type Provider.Intersection.Subscription {
  callback : Function(Number, Promise(Void)),
  element : Maybe(Dom.Element),
  rootMargin : String,
  threshold : Number
}

/* A provider to provide events when the given element is visible on the screen. */
provider Provider.Intersection : Provider.Intersection.Subscription {
  /* The array of observers. */
  state observers : Array(Tuple(Provider.Intersection.Subscription, IntersectionObserver)) = []

  /* Updates the provider. */
  fun update : Promise(Void) {
    /*
    Gather all of the current observers, and remove ones that are no
    longer present.
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
              IntersectionObserver.new(
                subscription.rootMargin,
                subscription.threshold,
                subscription.callback)
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
