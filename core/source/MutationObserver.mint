record MutationObserver.Entry {
  target : Dom.Element,
  type : String
}

/* This module provides a wrapper for the Resize Observer Web API. */
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
    element : Dom.Element,
    subtree : Bool,
    childList : Bool,
    observer : MutationObserver
  ) : MutationObserver {
    `
    #{observer}.observe(#{element}, {
      childList: #{childList},
      subtree: #{subtree}
    }) || #{observer}
    `
  }

  /* Unobserves the given element. */
  fun unobserve (element : Dom.Element, observer : MutationObserver) : MutationObserver {
    `#{observer}.disconnect(#{element}) || #{observer}`
  }
}
