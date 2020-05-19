record Provider.Intersection.Subscription {
  callback : Function(Number, Promise(Never, Void)),
  element : Maybe(Dom.Element),
  rootMargin : String,
  treshold : Number
}

provider Provider.Intersection : Provider.Intersection.Subscription {
  state observers : Array(Tuple(Provider.Intersection.Subscription, IntersectionObserver)) = []

  fun update : Promise(Never, Void) {
    try {
      currentObservers =
        for (item of observers) {
          try {
            {subscription, observer} =
              item

            if (Array.contains(subscription, subscriptions)) {
              Maybe::Just({subscription, observer})
            } else {
              try {
                case (subscription.element) {
                  Maybe::Just observed =>
                    try {
                      IntersectionObserver.unobserve(observed, observer)
                      Maybe::Nothing
                    }

                  => Maybe::Nothing
                }
              }
            }
          }
        }
        |> Array.compact()

      newObservers =
        for (subscription of subscriptions) {
          case (subscription.element) {
            Maybe::Just observed =>
              Maybe::Just({
                subscription, IntersectionObserver.new(subscription.rootMargin, subscription.treshold, subscription.callback)
                |> IntersectionObserver.observe(observed)
              })

            => Maybe::Nothing
          }
        } when {
          try {
            size =
              observers
              |> Array.select(
                (
                  item : Tuple(Provider.Intersection.Subscription, IntersectionObserver)
                ) {
                  try {
                    {key, value} =
                      item

                    (key == subscription)
                  }
                })
              |> Array.size()

            (size == 0)
          }
        }
        |> Array.compact()

      next { observers = Array.concat([currentObservers, newObservers]) }
    }
  }
}
