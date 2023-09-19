type MutationObserver.Entry {
  target : Dom.Element,
  type : String
}

/* This module provides a wrapper for the Mutation Observer Web API. */
module MutationObserver {
  /*
  Creates a new resize observer.

    observer =
      MutationObserver.new((entries : MutationObserver.Entry) {
        for (entry of entries) {
          Debug.log(entry)
        }
      })
  */
  fun new (
    callback : Function(Array(MutationObserver.Entry), a)
  ) : MutationObserver {
    `new MutationObserver(#{callback})`
  }

  /* Observes the given element. */
  fun observe (
    observer : MutationObserver,
    element : Dom.Element,
    subtree : Bool,
    childList : Bool
  ) : MutationObserver {
    `
    #{observer}.observe(#{element}, {
      childList: #{childList},
      subtree: #{subtree}
    }) || #{observer}
    `
  }

  /* Unobserves the given element. */
  fun unobserve (observer : MutationObserver, element : Dom.Element) : MutationObserver {
    `#{observer}.disconnect(#{element}) || #{observer}`
  }
}
