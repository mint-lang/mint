/* Represents a subscription for `Provider.ElementSize` */
record Provider.ElementSize.Subscription {
  changes : Function(Dom.Dimensions, Promise(Never, Void)),
  element : Maybe(Dom.Element)
}

/* A provider which provides events when the size of the element changes. */
provider Provider.ElementSize : Provider.ElementSize.Subscription {
  /* Keep a state of all observed elements. */
  state observedElements : Array(Maybe(Dom.Element)) = []

  /* The resize observer. */
  state observer = ResizeObserver.new(notify)

  /* Notifies all subscribers when there are changes. */
  fun notify (entries : Array(ResizeObserver.Entry)) : Array(Array(Promise(Never, Void))) {
    for (entry of entries) {
      for (subscription of subscriptions) {
        if (subscription.element == Maybe::Just(entry.target)) {
          subscription.changes(entry.dimensions)
        } else {
          next { }
        }
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Never, Void) {
    for (element of Array.compact(observedElements)) {
      ResizeObserver.unobserve(element, observer)
    }

    for (subscription of subscriptions) {
      case (subscription.element) {
        Maybe::Just(element) => {
          ResizeObserver.observe(element, observer)
          void
        }

        Maybe::Nothing => void
      }
    }

    next { observedElements = Array.map(.element, subscriptions) }
  }
}
