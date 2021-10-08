/* Represents a subscription for `Provider.Intersection` */
record Provider.Intersection.Subscription {
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
    currentObservers =
      for (item of observers) {
        {subscription, observer} =
          item

        if (Array.contains(subscription, subscriptions)) {
          Maybe::Just({subscription, observer})
        } else {
          case (subscription.element) {
            Maybe::Just(observed) =>
              {
                IntersectionObserver.unobserve(observed, observer)
                Maybe::Nothing
              }

            => Maybe::Nothing
          }
        }
      }
      |> Array.compact()

    /* Create new observers. */
    newObservers =
      for (subscription of subscriptions) {
        case (subscription.element) {
          Maybe::Just(observed) =>
            Maybe::Just(
              {
                subscription,
                IntersectionObserver.new(
                  subscription.rootMargin,
                  subscription.threshold,
                  subscription.callback)
                |> IntersectionObserver.observe(observed)
              })

          => Maybe::Nothing
        }
      } when {
        size =
          observers
          |> Array.select(
            (
              item : Tuple(Provider.Intersection.Subscription, IntersectionObserver)
            ) {
              item[0] == subscription
            })
          |> Array.size()

        (size == 0)
      }
      |> Array.compact()

    next { observers = Array.concat([currentObservers, newObservers]) }
  }
}
