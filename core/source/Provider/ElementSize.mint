/* Represents a subscription for `Provider.ElementSize` */
type Provider.ElementSize.Subscription {
  changes : Function(Dom.Dimensions, Promise(Void)),
  element : Maybe(Dom.Element)
}

/* A provider which provides events when the size of the element changes. */
provider Provider.ElementSize : Provider.ElementSize.Subscription {
  /* Keep a state of all observed elements. */
  state observedElements : Array(Maybe(Dom.Element)) = []

  /* The resize observer. */
  state observer = ResizeObserver.new(notify)

  /* Notifies all subscribers when there are changes. */
  fun notify (entries : Array(ResizeObserver.Entry)) : Array(Array(Promise(Void))) {
    for entry of entries {
      for subscription of subscriptions {
        if subscription.element == Maybe.Just(entry.target) {
          subscription.changes(entry.dimensions)
        } else {
          next { }
        }
      }
    }
  }

  /* Updates the provider. */
  fun update : Promise(Void) {
    for element of Array.compact(observedElements) {
      ResizeObserver.unobserve(observer, element)
    }

    for subscription of subscriptions {
      if let Maybe.Just(element) = subscription.element {
        ResizeObserver.observe(observer, element)
        void
      }
    }

    next
      {
        observedElements:
          for subscription of subscriptions {
            subscription.element
          }
      }
  }
}
