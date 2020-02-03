/* Represents a subscription for `Provider.MediaQuery` */
record Provider.MediaQuery.Subscription {
  changes : Function(Bool, Promise(Never, Void)),
  query : String
}

/*
This provider sends changes when the given media query in the subscription
changes.
*/
provider Provider.MediaQuery : Provider.MediaQuery.Subscription {
  fun attach : Void {
    `
    (() => {
      if (!this.listeners) {
        this.listeners = new Map
        this.queries = new Map
      }

      #{subscriptions}.forEach((subscription) => {
        const listeners = this.listeners.get(subscription.query)

        // Add a listener
        if (!listeners) {
          const query = window.matchMedia(subscription.query)

          const listener = () => {
            #{subscriptions}
              .filter((item) => item.query === subscription.query)
              .forEach((item) => {
                item.changes(query.matches)
              })
          }

          query.addListener(listener)

          this.queries.set(subscription.query, query)
          this.listeners.set(subscription.query, listener)
        }

        // Call all listeners...
        this.listeners.forEach((listener) => listener())
      })

      // Check if we need to remove some keys
      this.listeners.forEach((value, key) => {
        const present = #{subscriptions}.filter((subscription) => subscription.query === key).length > 0

        if (!present) {
          this.listeners.delete(key)
          this.queries.get(key).removeListener(value)
          this.queries.delete(key)
        }
      })
    })()
    `
  }

  fun detach : Void {
    `
    (() => {
      this.listeners.forEach((value, key) => {
        this.listeners.delete(key)
        this.queries.get(key).removeListener(value)
        this.queries.delete(key)
      })
    })()
    `
  }
}
